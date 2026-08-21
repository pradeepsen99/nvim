-- Per-filetype indentation
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
