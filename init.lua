-- setup must be called before loading
vim.cmd("colorscheme kanagawa-wave")

-- Main settings
vim.wo.relativenumber = true
vim.opt.completeopt = "noinsert,menuone,noselect"
vim.opt.showtabline=2
vim.opt.number = true

vim.api.nvim_set_keymap('n', '<leader><leader>', '<cmd>Telescope find_files<CR>', { noremap = true, silent = true })

-- Key bindings
vim.api.nvim_set_keymap('n', '<leader><leader>', '<cmd>Telescope find_files<CR>', { noremap = true, silent = true })
vim.g.mapleader = ' '

-- Plugins
require('kanagawa').setup({
    compile = false,             -- enable compiling the colorscheme
    undercurl = true,            -- enable undercurls
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true},
    statementStyle = { bold = true },
    typeStyle = {},
    transparent = false,         -- do not set background color
    dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
    terminalColors = true,       -- define vim.g.terminal_color_{0,17}
    colors = {                   -- add/modify theme and palette colors
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
    },
    overrides = function(colors) -- add/modify highlights
        return {}
    end,
    theme = "wave",              -- Load "wave" theme when 'background' option is not set
    background = {               -- map the value of 'background' option to a theme
        dark = "wave",           -- try "dragon" !
        light = "lotus"
    },
})

require('telescope').setup{
  defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    mappings = {
      i = {
        ["<C-h>"] = "which_key"
      }
    }
  },
  pickers = {
    find_files = {
	themes = "get_dropdown"
    }
  },
  
}

-- Enable nvim-treesitter and configure it for TypeScript
require'nvim-treesitter.configs'.setup {
  ensure_installed = {'typescript'}, -- Install the parser
  highlight = {
    enable = true,              -- Enable syntax highlighting
    disable = {},               -- Disable syntax highlighting
  },
}


