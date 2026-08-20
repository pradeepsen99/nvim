                                                                                                                             --      /\ \               /\ \            /\ \            /\ \           /\_\/\_\ _           / /\                /\ \     _  
--     /  \ \____         /  \ \          /  \ \          /  \ \         / / / / //\_\        / /  \              /  \ \   /\_\
--    / /\ \_____\       / /\ \ \        / /\ \ \        / /\ \ \       /\ \/ \ \/ / /       / / /\ \            / /\ \ \_/ / /
--   / / /\/___  /      / / /\ \_\      / / /\ \_\      / / /\ \_\     /  \____\__/ /       / / /\ \ \          / / /\ \___/ / 
--  / / /   / / /      / /_/_ \/_/     / /_/_ \/_/     / / /_/ / /    / /\/________/       / / /  \ \ \        / / /  \/____/  
-- / / /   / / /      / /____/\       / /____/\       / / /__\/ /    / / /\/_// / /       / / /___/ /\ \      / / /    / / /   
--/ / /   / / /      / /\____\/      / /\____\/      / / /_____/    / / /    / / /       / / /_____/ /\ \    / / /    / / /    
--\ \ \__/ / /      / / /______     / / /______     / / /          / / /    / / /       / /_________/\ \ \  / / /    / / /     
-- \ \___\/ /      / / /_______\   / / /_______\   / / /           \/_/    / / /       / / /_       __\ \_\/ / /    / / /      
--  \/_____/       \/__________/   \/__________/   \/_/                    \/_/        \_\___\     /____/_/\/_/     \/_/       
                                                                                                                             
-- Author: Pradeep
-- 

-- Main settings
vim.wo.relativenumber = true
vim.opt.completeopt = "menuone,noselect"
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.number = true
vim.g.have_nerd_font = true
vim.opt.termguicolors = true
vim.api.nvim_set_option("clipboard","unnamed")
vim.opt.cmdheight = 0
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.updatetime = 500
-- vim.opt.cindent = true

local indentation_group = vim.api.nvim_create_augroup('FiletypeIndentation', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  group = indentation_group,
  pattern = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'lua', 'ruby' },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = indentation_group,
  pattern = 'python',
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = indentation_group,
  pattern = 'go',
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- Key bindings--
-- Leader key
vim.g.mapleader = ' '

-- Misc key bindings
vim.api.nvim_set_keymap('n', '<leader>d', ':let @+ = expand("%:p")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'p', 'pgvy', { noremap = true })

-- 
vim.api.nvim_set_keymap('n', '$', 'g_', { noremap = true })
vim.api.nvim_set_keymap('v', '$', 'g_', { noremap = true })

-- Telescope key bindings
vim.api.nvim_set_keymap('n', '<leader><leader>', '<cmd>Telescope find_files<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>sb', '<cmd>Telescope current_buffer_fuzzy_find<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>sp', '<cmd>Telescope live_grep<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>tl', '<cmd>Telescope buffers<CR>', { noremap = true })

-- Git key bindings
vim.api.nvim_set_keymap('n', '<leader>gb', '<cmd>rightbelow Git blame<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gc', '<cmd>Git commit<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>ga', '<cmd>Git add -p<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gs', '<cmd>Git status<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gp', '<cmd>Git push<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gB', '<cmd>InlineBlameToggle<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gh', '<cmd>BlameAgeToggle<CR>', { noremap = true })

-- Session bindings
vim.api.nvim_set_keymap('n', '<leader>ss', ':mksession! ~/.config/nvim/session.vim<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>so', ':source ~/.config/nvim/session.vim<CR>', { noremap = true, silent = true })

-- Tab key bindings
vim.api.nvim_set_keymap('n', '<leader>tn', ':tabnew<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tc', ':tabclose<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader><tab>', ':tabnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader><s-tab>', ':tabprevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tm', ':tabmove ', { noremap = true, silent = true })

-- Tree key bindings
vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Random
vim.cmd('syntax enable')

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


-- Plugins
require("catppuccin").setup({
    flavour = "mocha", 
    background = { -- :h background
        light = "latte",
        dark = "mocha",
    },
    transparent_background = true, -- disables setting the background color.
    show_end_of_buffer = true, -- shows the '~' characters after the end of buffers
    term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
        -- miscs = {}, -- Uncomment to turn off hard-coded styles
    },
    color_overrides = {},
    custom_highlights = {},
    default_integrations = true,
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = false,
        noice = true,
        mini = {
            enabled = true,
            indentscope_color = "",
        },
    },
})

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"
require('telescope').setup{
  defaults = {
    preview = {
      treesitter = false,
    },
    mappings = {
      i = {
	["<C-h>"] = "which_key",
      }
    }
  },
  pickers = {
    find_files = {
	themes = "get_dropdown",
        hidden = true,
        no_ignore = true,
    },
    live_grep = {
      additional_args = { "--no-ignore" },
    }
  },
  
}

-- Enable nvim-treesitter and configure it for TypeScript
require'nvim-treesitter.configs'.setup {
  ensure_installed = {'typescript', 'python', 'javascript', 'lua', 'vim', 'regex', 'bash', 'markdown', 'markdown_inline'}, -- Install the parser
  highlight = {
    enable = true,              -- Enable syntax highlighting
  },
}

-- Enable nvim-tree
require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
	  -- dotfiles = true,
  },
  update_focused_file = {
    enable = true,
  }
})

-- Enable LSP
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local lspconfig = require('lspconfig')
lspconfig.tsserver.setup {
  -- allow this to be enabled on js files
    capabilities = capabilities,
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" }
}
lspconfig.solargraph.setup{
    capabilities = capabilities,
}
lspconfig.pyright.setup{
    capabilities = capabilities,
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "off",
            },
        },
    },
}
lspconfig.gopls.setup{
    capabilities = capabilities,
}
-- lspconfig.jedi_language_server.setup{
--     capabilities = capabilities,
-- }


-- Enable Statusbar
require('lualine').setup{
  options = { theme = 'catppuccin' } 
}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

require("ibl").setup()

-- Enable noice.nvim
require("noice").setup({
  lsp = {
    -- Override markdown rendering so that cmp and other plugins use Treesitter
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true, -- Integrates with nvim-cmp
    },
  },
  presets = {
    bottom_search = true, -- Use a classic bottom cmdline for search
    command_palette = true, -- Position the cmdline and popupmenu together
    long_message_to_split = true, -- Long messages will be sent to a split
    inc_rename = false, -- Enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- Add a border to hover docs and signature help
  },
})

local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)    
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noselect',
    max_item_count = 5,
    keyword_length = 2
  },
  window = {
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  })
})
