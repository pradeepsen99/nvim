-- Fuzzy finder
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
