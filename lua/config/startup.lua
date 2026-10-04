-- Startup page
local startup_group = vim.api.nvim_create_augroup('DeepmanStartup', { clear = true })
local startup_stdin = false
vim.api.nvim_create_autocmd('StdinReadPre', {
  group = startup_group,
  once = true,
  callback = function()
    startup_stdin = true
  end,
})

vim.api.nvim_create_autocmd('VimEnter', {
  group = startup_group,
  once = true,
  callback = function()
    if startup_stdin or vim.fn.argc() > 0 or vim.v.this_session ~= ''
      or #vim.api.nvim_list_uis() == 0 or #vim.api.nvim_list_wins() ~= 1
      or vim.api.nvim_buf_get_name(0) ~= '' or vim.bo.buftype ~= ''
      or vim.bo.modified or vim.api.nvim_buf_line_count(0) ~= 1
      or vim.api.nvim_get_current_line() ~= '' then
      return
    end

    local banner = {
      [=[      /\ \               /\ \            /\ \            /\ \           /\_\/\_\ _           / /\                /\ \     _]=],
      [=[     /  \ \____         /  \ \          /  \ \          /  \ \         / / / / //\_\        / /  \              /  \ \   /\_\]=],
      [=[    / /\ \_____\       / /\ \ \        / /\ \ \        / /\ \ \       /\ \/ \ \/ / /       / / /\ \            / /\ \ \_/ / /]=],
      [=[   / / /\/___  /      / / /\ \_\      / / /\ \_\      / / /\ \_\     /  \____\__/ /       / / /\ \ \          / / /\ \___/ /]=],
      [=[  / / /   / / /      / /_/_ \/_/     / /_/_ \/_/     / / /_/ / /    / /\/________/       / / /  \ \ \        / / /  \/____/]=],
      [=[ / / /   / / /      / /____/\       / /____/\       / / /__\/ /    / / /\/_// / /       / / /___/ /\ \      / / /    / / /]=],
      [=[/ / /   / / /      / /\____\/      / /\____\/      / / /_____/    / / /    / / /       / / /_____/ /\ \    / / /    / / /]=],
      [=[\ \ \__/ / /      / / /______     / / /______     / / /          / / /    / / /       / /_________/\ \ \  / / /    / / /]=],
      [=[ \ \___\/ /      / / /_______\   / / /_______\   / / /           \/_/    / / /       / / /_       __\ \_\/ / /    / / /]=],
      [=[  \/_____/       \/__________/   \/__________/   \/_/                    \/_/        \_\___\     /____/_/\/_/     \/_/]=],
    }
    local menu = {
      { 'f', 'Find files', '<cmd>Telescope find_files<CR>' },
      { 'r', 'Recent files', '<cmd>Telescope oldfiles<CR>' },
      { 'g', 'Search text', '<cmd>Telescope live_grep<CR>' },
      { 's', 'Restore session', function()
        local session = vim.fn.stdpath('config') .. '/session.vim'
        if vim.fn.filereadable(session) == 0 then
          vim.notify('No saved session. Use <leader>ss to save one.', vim.log.levels.INFO)
          return
        end
        vim.cmd.source(vim.fn.fnameescape(session))
      end },
      { 'n', 'New file', '<cmd>enew<CR>' },
      { 'q', 'Quit', '<cmd>quit<CR>' },
    }
    local buffer = vim.api.nvim_get_current_buf()
    local window = vim.api.nvim_get_current_win()
    local namespace = vim.api.nvim_create_namespace('DeepmanStartup')
    local saved_options = {}
    for name, value in pairs({
      number = false, relativenumber = false, signcolumn = 'no',
      foldcolumn = '0', wrap = false, cursorline = false, list = false,
      fillchars = 'eob: ',
    }) do
      saved_options[name] = vim.api.nvim_get_option_value(name, { win = window })
      vim.api.nvim_set_option_value(name, value, { win = window })
    end
    vim.bo[buffer].buftype = 'nofile'
    vim.bo[buffer].bufhidden = 'wipe'
    vim.bo[buffer].buflisted = false
    vim.bo[buffer].swapfile = false
    vim.bo[buffer].filetype = 'deepman'

    local function draw_startup()
      local width = vim.api.nvim_win_get_width(window)
      local banner_width = 0
      for _, line in ipairs(banner) do
        banner_width = math.max(banner_width, #line)
      end
      local header = width >= banner_width + 4 and banner or { 'DEEPMAN' }
      local header_width = header == banner and banner_width or 7
      local top = math.max(1, math.floor((vim.api.nvim_win_get_height(window) - #header - #menu - 2) / 2))
      local lines = {}
      for _ = 1, top do
        lines[#lines + 1] = ''
      end
      local header_padding = string.rep(' ', math.max(0, math.floor((width - header_width) / 2)))
      for _, line in ipairs(header) do
        lines[#lines + 1] = header_padding .. line
      end
      lines[#lines + 1] = ''
      lines[#lines + 1] = ''
      local menu_padding = string.rep(' ', math.max(0, math.floor((width - 21) / 2)))
      for _, item in ipairs(menu) do
        lines[#lines + 1] = menu_padding .. '[' .. item[1] .. ']  ' .. item[2]
      end
      vim.bo[buffer].modifiable = true
      vim.bo[buffer].readonly = false
      vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)
      vim.api.nvim_buf_clear_namespace(buffer, namespace, 0, -1)
      for index = top + 1, #lines do
        if lines[index] ~= '' then
          vim.api.nvim_buf_set_extmark(buffer, namespace, index - 1, 0, {
            end_col = #lines[index], hl_group = index <= top + #header and 'Title' or 'Special',
          })
        end
      end
      vim.bo[buffer].modified = false
      vim.bo[buffer].readonly = true
      vim.bo[buffer].modifiable = false
      vim.api.nvim_win_set_cursor(window, { top + #header + 3, #menu_padding })
    end

    for _, item in ipairs(menu) do
      vim.keymap.set('n', item[1], item[3], { buffer = buffer, silent = true, desc = item[2] })
    end
    vim.api.nvim_create_autocmd('BufWinLeave', {
      group = startup_group,
      buffer = buffer,
      once = true,
      callback = function()
        if vim.api.nvim_win_is_valid(window) then
          for name, value in pairs(saved_options) do
            vim.api.nvim_set_option_value(name, value, { win = window })
          end
        end
      end,
    })
    local resize_autocmd = vim.api.nvim_create_autocmd('VimResized', {
      group = startup_group,
      callback = function()
        if vim.api.nvim_win_is_valid(window) and vim.api.nvim_win_get_buf(window) == buffer then
          draw_startup()
        end
      end,
    })
    vim.api.nvim_create_autocmd('BufWipeout', {
      group = startup_group,
      buffer = buffer,
      once = true,
      callback = function()
        vim.api.nvim_del_autocmd(resize_autocmd)
      end,
    })
    draw_startup()
  end,
})
