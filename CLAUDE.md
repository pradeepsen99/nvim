# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal Neovim configuration that uses native Neovim package loading with git submodules instead of traditional package managers like packer or lazy.nvim. Configuration is split across `init.lua` and modules under `lua/`.

## Commands

### Plugin Management
- **Add new plugin**: `git submodule add ${GITHUB_URL} pack/plugins/start/${plugin_name}`
- **Install/update all plugins**: `git submodule update --init --recursive`

The source of truth for plugins is `.gitmodules` - all installed plugins are git submodules in `pack/plugins/start/`.

## Configuration Architecture

### Module Layout
`init.lua` is a banner plus an explicit, ordered list of `require` calls. There is no loader layer or glob - load order is visible in `init.lua` and matters (see below).

| File | Contents |
| --- | --- |
| `lua/config/options.lua` | Editor settings: tab width (2 spaces), relative line numbers, clipboard, `cmdheight=0`, `syntax enable` |
| `lua/config/keymaps.lua` | Leader key and all global keybinds, via `vim.api.nvim_set_keymap` |
| `lua/config/autocmds.lua` | `FiletypeIndentation` augroup: per-filetype indent overrides |
| `lua/plugins/ui.lua` | catppuccin + `colorscheme`, lualine, indent-blankline, noice |
| `lua/plugins/editor.lua` | telescope, nvim-treesitter, nvim-tree |
| `lua/plugins/lsp.lua` | LSP server configs and the `LspAttach` keybind autocmd |
| `lua/plugins/completion.lua` | nvim-cmp and vsnip |
| `lua/git/inline_blame.lua` | Inline git blame: `CursorHold` virtual text, `:InlineBlameToggle` |
| `lua/git/blame_age.lua` | Commit-age heat bar in `statuscolumn`, `:BlameAgeToggle` |

Load-order constraints:
- `vim.g.mapleader` is set at the top of `config/keymaps.lua`, before any `<leader>` mapping.
- `catppuccin.setup()` must precede `vim.cmd.colorscheme` - both live in `plugins/ui.lua`.
- The `lua/git/*` modules load after `plugins.ui` so their highlight groups resolve against the real catppuccin palette on first paint.
- `_G.blame_age_statuscol` is intentionally global: `'statuscolumn'` calls it as `v:lua.blame_age_statuscol()` on every visible line on every redraw.

A new plugin that needs Lua setup goes in the matching `lua/plugins/*.lua` file; vimscript plugins (fugitive, commentary, copilot, vim-rails) need no setup and load themselves as native packages.

### LSP Setup
Four language servers, configured with the Nvim 0.11 native API (`vim.lsp.config` / `vim.lsp.enable`) on top of the server definitions nvim-lspconfig ships in its `lsp/` directory. The `require('lspconfig')` framework is deprecated and is deliberately not used.
- **ts_ls**: TypeScript/JavaScript, with `filetypes` overridden to add the compound `javascript.jsx` / `typescript.tsx` types the default omits
- **solargraph**: Ruby
- **pyright**: Python with `typeCheckingMode = "off"`
- **gopls**: Go

`cmp_nvim_lsp` capabilities are applied once to all servers via `vim.lsp.config('*', ...)`. LSP keybinds are set on attach via the `LspAttach` autocmd.

### Autocompletion
Uses nvim-cmp with:
- **Snippet engine**: vsnip
- **Completion sources**: nvim_lsp, vsnip, buffer
- **Custom settings**: max 5 items, minimum 2 characters to trigger
- **Keybinds**: `<CR>` confirms, `<C-Space>` completes, `<C-e>` aborts

### Key Binding System
All keybinds use `<space>` as leader. Pattern:
- **Telescope**: `<leader><leader>` (find_files), `<leader>sb` (buffer search), `<leader>sp` (live_grep), `<leader>tl` (buffers)
- **Git**: `<leader>g{b,c,a,s,p}` (blame, commit, add, status, push), `<leader>gB` (toggle inline blame), `<leader>gh` (toggle commit-age gutter)
- **Tabs**: `<leader>t{n,c}` (new, close), `<leader><tab>/<s-tab>` (next/prev), `<leader>tm` (move)
- **Sessions**: `<leader>ss` (save), `<leader>so` (load) - stored at `~/.config/nvim/session.vim`
- **File explorer**: `<leader>e` (toggle nvim-tree)
- **LSP** (when attached): `gd` (definition), `K` (hover), `gi` (implementation), `gr` (references), `<leader>rn` (rename), `<space>ca` (code action), `<space>f` (format)

### Installed Plugins
Core plugins (from `.gitmodules`):
- **catppuccin**: Color scheme (mocha flavor, transparent background)
- **telescope.nvim**: Fuzzy finder with hidden files enabled
- **nvim-treesitter**: Syntax highlighting for typescript, python, javascript, lua, vim, regex, bash, markdown
- **nvim-tree.lua**: File explorer, width=30, auto-focus on file open
- **nvim-lspconfig**: LSP client configurations
- **nvim-cmp + cmp-nvim-lsp**: Autocompletion framework with LSP source
- **vim-vsnip**: Snippet engine
- **lualine.nvim**: Statusline with catppuccin theme
- **indent-blankline.nvim**: Indent guides
- **noice.nvim + nui.nvim**: Enhanced UI for cmdline, messages, and LSP hover
- **vim-fugitive**: Git commands (`:Git`)
- **vim-commentary**: Comment toggling
- **copilot.vim**: GitHub Copilot integration
- **vim-rails**: Rails navigation
- **go.nvim**: Additional Go tooling

## Important Implementation Details

### Editor Behavior
- `relativenumber = true`: Relative line numbers enabled
- `$` remapped to `g_`: End of line excludes trailing whitespace
- Paste in visual mode with `p` yanks replaced text: Allows repeated pasting
- `<leader>d` copies full file path to clipboard
- Clipboard set to "unnamed" for system clipboard integration
- Tab width is 2 spaces (`tabstop`, `shiftwidth`, `softtabstop` all set to 2)