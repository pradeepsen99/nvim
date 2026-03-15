# AGENTS.md

Guidance for coding agents working in `nvim`.

## Scope

- This repo is a personal Neovim configuration.
- First-party code is mainly `init.lua`, plus a small helper script.
- `pack/plugins/start/*` contains git submodules, not first-party app code.
- Treat submodules as vendored dependencies unless the user explicitly asks you to edit one.
- The source of truth for installed plugins is `.gitmodules`.

## Rule Sources

- `CLAUDE.md` exists and is active guidance for this repo.
- Its guidance is reflected here: single-file config, submodule-managed plugins, existing keymap and LSP patterns.
- No `.cursor/rules/` directory was found during repo scan.
- No `.cursorrules` file was found.
- No `.github/copilot-instructions.md` file was found.

## Repository Layout

- `init.lua`: main Neovim config.
- `.gitmodules`: canonical plugin list.
- `install_packages.sh`: setup helper with dependency checks.
- `README.md`: short overview and keybinding map.
- `tmux.conf`: separate tmux config; ignore unless the task is tmux-related.
- `pack/plugins/start/*`: plugin submodules loaded with native Neovim package support.

## Canonical Commands

- Install or update plugins: `git submodule update --init --recursive`
- Add a plugin: `git submodule add <GITHUB_URL> pack/plugins/start/<plugin_name>`
- Inspect configured plugin paths: `git config --file .gitmodules --get-regexp path`
- Smoke test startup: `nvim --headless "+qa"`
- Manual verification: `nvim`
- The helper script exists, but `git submodule update --init --recursive` is the canonical setup command.

## Build, Lint, and Test Reality

- There is no root-level build system.
- There is no root-level formatter config like `stylua.toml`.
- There is no root-level lint config like `.luacheckrc`.
- There is no first-party automated test suite for the root config.
- Test and lint files found under `pack/plugins/start/*` belong to submodules and do not count as repo-level commands.
- Do not present submodule commands as if they validate `init.lua`.

## Single-Test Guidance

- There is no canonical single-test command for the root config because there is no root test suite.
- For a narrow verification after a small change, rerun `nvim --headless "+qa"`.
- For behavioral changes, open `nvim` and exercise only the changed keymap, plugin command, or LSP flow.
- If the task is inside a plugin submodule, switch to that submodule's own tooling instead of inventing a root single-test command.
- Be explicit when a request cannot be satisfied with automated first-party tests.

## Validation Expectations

- After editing `init.lua`, run `nvim --headless "+qa"`.
- Current observed startup behavior: Neovim loads, but emits a deprecation warning for `vim.tbl_add_reverse_lookup`.
- For keymap changes, manually verify the mapping in `nvim`.
- For plugin config changes, verify startup and the specific affected plugin behavior.
- For LSP changes, open a matching filetype and confirm the server attaches.
- For completion changes, verify insert-mode completion with `nvim-cmp`.

## Architecture

- The configuration is intentionally centralized in one file.
- Preserve the existing high-level order in `init.lua` unless the user asks for a refactor.
- Current order is roughly: settings, keymaps, plugin setup, LSP setup, UI extras, completion.
- Keep plugin setup close to related comments and nearby plugin blocks.
- Respect ordering constraints, such as configuring a colorscheme before loading it.
- Prefer focused edits over broad restructuring.

## Style Baseline

- Match the existing repository style before applying generic Lua preferences.
- Keep code direct and configuration-oriented; avoid unnecessary abstractions.
- Preserve the single-file approach unless the user explicitly requests modularization.
- Keep diffs small and local.
- Avoid large cleanup passes while doing feature work.
- Use ASCII unless the file already needs something else.

## Formatting

- Use 2-space indentation in first-party files.
- Prefer spaces over tabs in new or edited root-level code.
- Keep lines readable without rewrapping unrelated content.
- Retain trailing commas in multiline Lua tables when the surrounding block uses them.
- Avoid mass reformatting unrelated sections.
- Follow the local style of the block you are editing if the file is mixed.

## Imports and Modules

- Use `require(...)` near the section that configures the plugin or feature.
- Store repeated module references in `local` variables.
- Existing root patterns include `local lspconfig = require('lspconfig')` and `local cmp = require'cmp'`.
- Do not introduce custom loader layers for this small config.
- When adding a plugin, configure it inline in `init.lua` unless asked to refactor structure.

## Lua, Types, and Naming

- Prefer `local` for reusable values and module handles.
- Limit globals to intentional Neovim globals such as `vim.g.mapleader` and similar `vim.g.*` settings.
- Use descriptive snake_case names for new locals.
- Keep table keys and option names exactly as required by Neovim or plugin APIs.
- There is no explicit type system in the root config; keep Lua tables simple and shape-compatible with upstream APIs.
- Prefer small inline callback functions over extra wrappers.
- Avoid clever metaprogramming.

## Keymaps

- Top-level mappings currently use `vim.api.nvim_set_keymap`.
- Buffer-local LSP mappings currently use `vim.keymap.set` inside `LspAttach`.
- Preserve that adjacent style unless you have a strong local reason not to.
- Keep leader mappings mnemonic and grouped by feature area.
- Avoid changing existing bindings unless the task requires it.

## Plugin Configuration

- Keep each plugin block self-contained and near its related section comment.
- Do not remove or rename submodule paths casually.
- When adding a plugin, prefer `git submodule add` over hand-editing `.gitmodules` alone.
- Do not assume plugin submodule code follows the same style as the root config.
- Avoid editing plugin internals for a root-level config task.
- Treat setup order as meaningful.

## LSP and Completion

- Reuse shared `cmp_nvim_lsp` capabilities when adding or editing LSP servers.
- Keep buffer-local LSP bindings inside the `LspAttach` autocmd.
- Match the existing small-table setup style for server configs.
- Respect intentional current settings, including `pyright` type checking set to `off`.
- Keep `nvim-cmp` source and mapping changes inside the existing completion section unless a larger refactor is requested.
- Verify filetype-specific behavior manually when changing LSP or completion.

## Error Handling

- In shell scripts, print clear errors to stderr and exit non-zero.
- `install_packages.sh` is the model for shell-style failure handling in this repo.
- In root Lua config, prefer failing loudly over silently hiding broken startup state.
- Only use `pcall` or similar guards when a dependency is truly optional.
- Do not swallow Neovim or plugin errors without a strong reason.

## Comments and Documentation

- Keep comments brief and functional.
- Preserve useful section headers.
- Do not add comments for obvious assignments.
- Add comments only for non-obvious ordering, Neovim quirks, or plugin behavior.
- Update `README.md` when user-facing behavior changes enough to make it stale.

## What To Avoid

- Do not replace the native package setup with a plugin manager unless explicitly asked.
- Do not split `init.lua` into modules just because it seems cleaner.
- Do not assume submodule tests validate root config changes.
- Do not claim build, lint, or test commands exist at root when they only exist in submodules.
- Do not edit vendored plugin code for a root task.
- Do not hide validation gaps; state them clearly.

## Default Agent Workflow

- Read `CLAUDE.md`, `init.lua`, and nearby files before editing.
- Make the smallest reasonable change in first-party code.
- Validate with `nvim --headless "+qa"` after config edits.
- Do any necessary manual verification in `nvim` for behavior that has no automated test.
- Mention the observed deprecation warning if it appears during validation.
