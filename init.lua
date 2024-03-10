                                                                                                                             
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
vim.opt.completeopt = "noinsert,menuone,noselect"
vim.opt.showtabline=2
vim.opt.list = true
vim.opt.number = true
vim.g.have_nerd_font = true

-- Key bindings--
-- Leader key
vim.g.mapleader = ' '

-- Telescope key bindings
vim.api.nvim_set_keymap('n', '<leader><leader>', '<cmd>Telescope find_files<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>sb', '<cmd>Telescope current_buffer_fuzzy_find<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>sp', '<cmd>Telescope live_grep<CR>', { noremap = true })

-- Git key bindings
vim.api.nvim_set_keymap('n', '<leader>gb', '<cmd>Git blame<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gc', '<cmd>Git commit<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gd', '<cmd>Git add<CR>', { noremap = true })
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

-- Plugins
require('kanagawa').setup({
    compile = true,             -- enable compiling the colorscheme
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
vim.cmd("colorscheme kanagawa-wave")

require('telescope').setup{
  defaults = {
    mappings = {
      i = {
	["<C-h>"] = "which_key",
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
  ensure_installed = {'typescript', 'python', 'javascript', 'lua'}, -- Install the parser
  highlight = {
    enable = true,              -- Enable syntax highlighting
    disable = {},               -- Disable syntax highlighting
  },
}

--setup must be called before loading
