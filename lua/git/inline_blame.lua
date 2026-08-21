-- Inline git blame
local blame_ns = vim.api.nvim_create_namespace('inline_blame')
local blame_enabled = true

local function clear_blame(buf)
  vim.api.nvim_buf_clear_namespace(buf, blame_ns, 0, -1)
end

local function show_blame()
  local buf = vim.api.nvim_get_current_buf()
  clear_blame(buf)
  if not blame_enabled then return end
  local file = vim.api.nvim_buf_get_name(buf)
  if file == '' or vim.bo[buf].buftype ~= '' then return end
  local line = vim.fn.line('.')
  vim.system(
    { 'git', 'blame', '-L', line .. ',' .. line, '--line-porcelain', '--', file },
    { cwd = vim.fs.dirname(file) },
    vim.schedule_wrap(function(out)
      if out.code ~= 0 or not blame_enabled then return end
      local author = out.stdout:match('\nauthor ([^\n]*)')
      local summary = out.stdout:match('\nsummary ([^\n]*)')
      if not author or author == 'Not Committed Yet' then return end
      -- Bail if the cursor moved on while git was running
      if vim.api.nvim_get_current_buf() ~= buf or vim.fn.line('.') ~= line then return end
      vim.api.nvim_buf_set_extmark(buf, blame_ns, line - 1, 0, {
        virt_text = { { '  ' .. author .. ' · ' .. summary, 'Comment' } },
        virt_text_pos = 'eol',
      })
    end)
  )
end

local blame_group = vim.api.nvim_create_augroup('InlineBlame', { clear = true })
vim.api.nvim_create_autocmd('CursorHold', {
  group = blame_group,
  callback = show_blame,
})
vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'InsertEnter', 'BufLeave' }, {
  group = blame_group,
  callback = function() clear_blame(vim.api.nvim_get_current_buf()) end,
})

vim.api.nvim_create_user_command('InlineBlameToggle', function()
  blame_enabled = not blame_enabled
  if blame_enabled then
    show_blame()
  else
    clear_blame(vim.api.nvim_get_current_buf())
  end
  vim.notify('inline blame ' .. (blame_enabled and 'on' or 'off'))
end, {})
