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
    local banner_width = 0
    for _, line in ipairs(banner) do
      banner_width = math.max(banner_width, #line)
    end
    local frame_paths = vim.fn.globpath(vim.fn.stdpath('config') .. '/frames', 'frame_*.txt', false, true)
    table.sort(frame_paths)
    assert(#frame_paths > 0, 'DEEPMAN startup frames are missing')
    local frames = {}
    local frame_width = 0
    for _, frame_path in ipairs(frame_paths) do
      local frame = vim.fn.readfile(frame_path)
      assert(#frame > 0, 'Empty DEEPMAN frame: ' .. frame_path)
      frames[#frames + 1] = frame
      assert(#frame == #frames[1], 'DEEPMAN frames must have the same height')
      for _, line in ipairs(frame) do
        frame_width = math.max(frame_width, vim.fn.strdisplaywidth(line))
      end
    end
    local frame_index = 1
    local animation_visible = false
    local animation_timer
    local header_row = 0
    local header_padding = ''
    local displayed_header = {}
    local function stop_animation()
      if animation_timer then
        vim.fn.timer_stop(animation_timer)
        animation_timer = nil
      end
      frame_index = 1
    end
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
    local saved_mouse = vim.o.mouse
    if not saved_mouse:find('[an]') then
      vim.opt.mouse:append('n')
    end
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
    vim.bo[buffer].undolevels = -1
    vim.bo[buffer].filetype = 'deepman'

    local function draw_startup(reset_cursor)
      local cursor = vim.api.nvim_win_get_cursor(window)
      local width = vim.api.nvim_win_get_width(window)
      animation_visible = width >= frame_width + 4
        and vim.api.nvim_win_get_height(window) >= #frames[1] + #menu + 4
      if animation_timer and not animation_visible then
        stop_animation()
      end
      local idle_header = width >= banner_width + 4
        and vim.api.nvim_win_get_height(window) >= #banner + #menu + 4 and banner or { 'DEEPMAN' }
      local header = animation_timer and frames[frame_index] or idle_header
      local header_width = animation_timer and frame_width or (idle_header == banner and banner_width or 7)
      local header_height = animation_visible and math.max(#idle_header, #frames[1]) or #idle_header
      local top = math.max(1, math.floor((vim.api.nvim_win_get_height(window) - header_height - #menu - 2) / 2))
      header_row = top + math.floor((header_height - #header) / 2)
      displayed_header = header
      local lines = {}
      for _ = 1, header_row do
        lines[#lines + 1] = ''
      end
      header_padding = string.rep(' ', math.max(0, math.floor((width - header_width) / 2)))
      for _, line in ipairs(header) do
        lines[#lines + 1] = header_padding .. line
      end
      while #lines < top + header_height + 2 do
        lines[#lines + 1] = ''
      end
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
            end_col = #lines[index], hl_group = index <= top + header_height and 'Title' or 'Special',
          })
        end
      end
      vim.bo[buffer].modified = false
      vim.bo[buffer].readonly = true
      vim.bo[buffer].modifiable = false
      vim.api.nvim_win_set_cursor(window, reset_cursor and { top + header_height + 3, #menu_padding } or cursor)
    end

    for _, item in ipairs(menu) do
      vim.keymap.set('n', item[1], item[3], { buffer = buffer, silent = true, desc = item[2] })
    end
    vim.api.nvim_create_autocmd('BufWinLeave', {
      group = startup_group,
      buffer = buffer,
      once = true,
      callback = function()
        stop_animation()
        vim.o.mouse = saved_mouse
        if vim.api.nvim_win_is_valid(window) then
          for name, value in pairs(saved_options) do
            vim.api.nvim_set_option_value(name, value, { win = window })
          end
        end
      end,
    })
    local function rotate_banner()
      if animation_timer or not animation_visible or not vim.api.nvim_buf_is_valid(buffer)
        or not vim.api.nvim_win_is_valid(window) or vim.api.nvim_get_current_buf() ~= buffer then
        return
      end
      frame_index = 1
      animation_timer = vim.fn.timer_start(80, function()
        if not vim.api.nvim_buf_is_valid(buffer) or not vim.api.nvim_win_is_valid(window) then
          stop_animation()
          return
        end
        -- Pause without consuming frames while a picker or command line has focus.
        if vim.api.nvim_get_current_buf() ~= buffer or vim.fn.mode() ~= 'n' then
          return
        end
        if frame_index == #frames then
          stop_animation()
        else
          frame_index = frame_index + 1
        end
        draw_startup(false)
      end, { ['repeat'] = -1 })
      draw_startup(false)
    end
    -- Allow longer Space-led mappings to resolve before rotating.
    vim.keymap.set('n', '<Space>', rotate_banner, { buffer = buffer, silent = true, desc = 'Rotate DEEPMAN once' })
    for _, click_key in ipairs({ '<LeftMouse>', '<2-LeftMouse>', '<3-LeftMouse>', '<4-LeftMouse>' }) do
      vim.keymap.set('n', click_key, function()
        local mouse = vim.fn.getmousepos()
        local line = displayed_header[mouse.line - header_row]
        local column = mouse.column - #header_padding
        if mouse.winid == window and line and line:find('%S')
          and column >= line:find('%S') and column <= #line then
          -- Expression mappings cannot change buffer text directly.
          vim.schedule(rotate_banner)
          return ''
        end
        return click_key
      end, { buffer = buffer, expr = true, silent = true, desc = 'Rotate DEEPMAN once' })
    end
    local leave_autocmd = vim.api.nvim_create_autocmd('VimLeavePre', {
      group = startup_group,
      once = true,
      callback = function()
        stop_animation()
      end,
    })
    local resize_autocmd = vim.api.nvim_create_autocmd('VimResized', {
      group = startup_group,
      callback = function()
        if vim.api.nvim_win_is_valid(window) and vim.api.nvim_win_get_buf(window) == buffer then
          draw_startup(true)
        end
      end,
    })
    vim.api.nvim_create_autocmd('BufWipeout', {
      group = startup_group,
      buffer = buffer,
      once = true,
      callback = function()
        stop_animation()
        vim.api.nvim_del_autocmd(resize_autocmd)
        vim.api.nvim_del_autocmd(leave_autocmd)
      end,
    })
    draw_startup(true)
  end,
})
