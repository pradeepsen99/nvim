# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal Neovim configuration that uses native Neovim package loading with git submodules instead of traditional package managers like packer or lazy.nvim. All configuration is contained in a single `init.lua` file (~285 lines).

## Commands

### Plugin Management
- **Add new plugin**: `git submodule add ${GITHUB_URL} pack/plugins/start/${plugin_name}`
- **Install/update all plugins**: `git submodule update --init --recursive`

The source of truth for plugins is `.gitmodules` - all installed plugins are git submodules in `pack/plugins/start/`.

## Configuration Architecture

### Single File Design
All configuration lives in `init.lua` with the following structure:
1. **Editor settings** (lines 15-29): Tab width (2 spaces), relative line numbers, clipboard, cmdheight=0
2. **Key mappings** (lines 31-68): All keybinds defined upfront using `vim.api.nvim_set_keymap`
3. **Plugin configurations** (lines 73-250): Each plugin's `setup()` called inline
4. **LSP configuration** (lines 169-229): LSP servers and autocommands for LSP attach events
5. **Autocompletion** (lines 252-284): nvim-cmp setup with sources

### LSP Setup
Four language servers configured with nvim-lspconfig:
- **tsserver**: TypeScript/JavaScript with extended filetypes for jsx/tsx
- **solargraph**: Ruby
- **pyright**: Python with `typeCheckingMode = "off"`
- **gopls**: Go

All LSP servers use `cmp_nvim_lsp` capabilities for autocompletion integration. LSP keybinds are dynamically set on attach via `LspAttach` autocmd.

### Autocompletion
Uses nvim-cmp with:
- **Snippet engine**: vsnip
- **Completion sources**: nvim_lsp, vsnip, buffer
- **Custom settings**: max 5 items, minimum 2 characters to trigger
- **Keybinds**: `<CR>` confirms, `<C-Space>` completes, `<C-e>` aborts

### Key Binding System
All keybinds use `<space>` as leader. Pattern:
- **Telescope**: `<leader><leader>` (find_files), `<leader>sb` (buffer search), `<leader>sp` (live_grep), `<leader>tl` (buffers)
- **Git**: `<leader>g{b,c,a,s,p}` (blame, commit, add, status, push)
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