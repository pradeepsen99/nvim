-- Colorscheme
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

-- Enable Statusbar
require('lualine').setup{
  options = { theme = 'catppuccin' } 
}

-- Indent guides
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
