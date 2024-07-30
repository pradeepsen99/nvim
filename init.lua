                                                                                                                             
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
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.number = true
vim.g.have_nerd_font = true
vim.opt.termguicolors = true
vim.api.nvim_set_option("clipboard","unnamed")
vim.opt.cmdheight = 0

-- Key bindings--
-- Leader key
vim.g.mapleader = ' '

-- Misc key bindings
vim.api.nvim_set_keymap('n', '<leader>d', ':let @+ = expand("%:p")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'p', 'pgvy', { noremap = true })

-- fold key bindings

-- Telescope key bindings
vim.api.nvim_set_keymap('n', '<leader><leader>', '<cmd>Telescope find_files<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>sb', '<cmd>Telescope current_buffer_fuzzy_find<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>sp', '<cmd>Telescope live_grep<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>tl', '<cmd>Telescope buffers<CR>', { noremap = true })

-- Git key bindings
vim.api.nvim_set_keymap('n', '<leader>gb', '<cmd>Git blame<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gc', '<cmd>Git commit<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>ga', '<cmd>Git add -p<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gs', '<cmd>Git status<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gp', '<cmd>Git push<CR>', { noremap = true })

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

-- Plugins
require("catppuccin").setup({
    flavour = "mocha", 
    background = { -- :h background
        light = "latte",
        dark = "mocha",
    },
    transparent_background = false, -- disables setting the background color.
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
        mini = {
            enabled = true,
            indentscope_color = "",
        },
    },
})

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"require('telescope').setup{
  defaults = {
    mappings = {
      i = {
	["<C-h>"] = "which_key",
      }
    }
  },
  pickers = {
    find_files = {
	themes = "get_dropdown",
        hidden = true
    }
  },
  
}

-- Enable nvim-treesitter and configure it for TypeScript
require'nvim-treesitter.configs'.setup {
  ensure_installed = {'typescript', 'python', 'javascript', 'lua'}, -- Install the parser
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

local cmp = require'cmp'

  cmp.setup({

    window = {
      completion = cmp.config.window.bordered(),
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
