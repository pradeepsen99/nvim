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
