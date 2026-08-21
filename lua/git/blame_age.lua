-- Git gutter: commit-age heat bar
-- Draws a thin bar in 'statuscolumn', immediately right of the line number, coloured
-- by how old that line's commit is, so uncommitted work stands out. Toggle: <leader>gh.
local age_enabled = true
local age_hl = {} -- bufnr -> { [lnum] = highlight group }

local DAY = 24 * 60 * 60
local age_scale = {
  { hl = 'BlameAgeToday',   max = DAY,         key = 'red' },
  { hl = 'BlameAgeWeek',    max = 7 * DAY,     key = 'peach' },
  { hl = 'BlameAgeMonth',   max = 30 * DAY,    key = 'yellow' },
  { hl = 'BlameAgeSeason',  max = 182 * DAY,   key = 'green' },
  { hl = 'BlameAgeYear',    max = 365 * DAY,   key = 'blue' },
  { hl = 'BlameAgeAncient', max = math.huge,   key = 'surface2' },
}
local age_dirty_hl = 'BlameAgeDirty'

local function set_age_highlights()
  local ok, palettes = pcall(require, 'catppuccin.palettes')
  local p = ok and palettes.get_palette('mocha') or {
    red = '#f38ba8', peach = '#fab387', yellow = '#f9e2af', green = '#a6e3a1',
    blue = '#89b4fa', surface2 = '#585b70', mauve = '#cba6f7',
  }
  for _, bucket in ipairs(age_scale) do
    vim.api.nvim_set_hl(0, bucket.hl, { fg = p[bucket.key] })
  end
  vim.api.nvim_set_hl(0, age_dirty_hl, { fg = p.mauve, bold = true })
end

local function bucket_for(sha, commit_time, now)
  if sha:match('^0+$') then return age_dirty_hl end
  local age = now - (commit_time[sha] or now)
  for _, bucket in ipairs(age_scale) do
    if age <= bucket.max then return bucket.hl end
  end
  return age_scale[#age_scale].hl
end

-- Called by 'statuscolumn' for every visible line on every redraw, so keep it cheap.
-- Renders the hybrid relative/absolute number, then the age bar hard against the text.
-- The number highlight is set explicitly: a %{} expression does not inherit CursorLineNr.
function _G.blame_age_statuscol()
  -- Windows with no number column (nvim-tree, telescope, terminals) keep just their signs
  if not (vim.wo.number or vim.wo.relativenumber) then return '%s' end
  if vim.v.virtnum ~= 0 then return '%s%=  ' end -- wrapped continuation: no number, no bar
  local num = vim.v.relnum == 0
      and ('%#CursorLineNr#' .. vim.v.lnum)
      or ('%#LineNr#' .. vim.v.relnum)
  local lines = age_hl[vim.api.nvim_get_current_buf()]
  local hl = lines and lines[vim.v.lnum]
  -- A space after the number, then the bar hard against the text
  return '%s%=' .. num .. ' ' .. (hl and ('%#' .. hl .. '#▏') or ' ')
end

local age_statuscolumn = '%{%v:lua.blame_age_statuscol()%}'

local function draw_age(buf)
  if not age_enabled or not vim.api.nvim_buf_is_valid(buf) then return end
  local file = vim.api.nvim_buf_get_name(buf)
  if file == '' or vim.bo[buf].buftype ~= '' then return end
  -- Blaming a huge file on every edit is not worth the git churn
  if vim.api.nvim_buf_line_count(buf) > 20000 then return end

  local tick = vim.b[buf].changedtick
  -- Feed the live buffer to git so unsaved lines register as uncommitted
  local contents = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), '\n') .. '\n'
  vim.system(
    { 'git', 'blame', '--porcelain', '--contents', '-', '--', file },
    { cwd = vim.fs.dirname(file), stdin = contents },
    vim.schedule_wrap(function(out)
      if out.code ~= 0 or not age_enabled then return end
      if not vim.api.nvim_buf_is_valid(buf) or vim.b[buf].changedtick ~= tick then return end

      local commit_time, line_sha, sha = {}, {}, nil
      for _, l in ipairs(vim.split(out.stdout, '\n', { plain = true })) do
        if l:sub(1, 1) ~= '\t' then
          local header, final = l:match('^(%x+) %d+ (%d+)')
          if header then
            sha = header
            line_sha[tonumber(final)] = header
          else
            local t = l:match('^author%-time (%d+)')
            if t and sha then commit_time[sha] = tonumber(t) end
          end
        end
      end

      local now, resolved = os.time(), {}
      for lnum, line_commit in pairs(line_sha) do
        resolved[lnum] = bucket_for(line_commit, commit_time, now)
      end
      age_hl[buf] = resolved
      vim.api.nvim__redraw({ buf = buf, statuscolumn = true })
    end)
  )
end

-- Coalesce bursts of edits into a single blame
local age_token = 0
local function schedule_age(buf)
  age_token = age_token + 1
  local mine = age_token
  vim.defer_fn(function()
    if mine == age_token then draw_age(buf) end
  end, 300)
end

set_age_highlights()
vim.opt.statuscolumn = age_statuscolumn

local age_group = vim.api.nvim_create_augroup('BlameAge', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave', 'TextChanged' }, {
  group = age_group,
  callback = function(ev) schedule_age(ev.buf) end,
})
vim.api.nvim_create_autocmd({ 'BufDelete', 'BufWipeout' }, {
  group = age_group,
  callback = function(ev) age_hl[ev.buf] = nil end,
})
vim.api.nvim_create_autocmd('ColorScheme', { group = age_group, callback = set_age_highlights })

vim.api.nvim_create_user_command('BlameAgeToggle', function()
  age_enabled = not age_enabled
  if age_enabled then
    vim.opt.statuscolumn = age_statuscolumn
    draw_age(vim.api.nvim_get_current_buf())
  else
    age_hl = {}
    vim.opt.statuscolumn = ''
  end
  vim.notify('blame age gutter ' .. (age_enabled and 'on' or 'off'))
end, {})
