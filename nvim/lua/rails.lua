local wk = require("which-key")

local toggleTerm = require("toggleterm")
local Terminal = require("toggleterm.terminal").Terminal

function _run_rails_test()
  local buffer_path = vim.api.nvim_buf_get_name(0)
  cmd = string.format("bin/rails test %s", buffer_path)
  toggleTerm.exec(cmd, 10, 25, git_dir, 'horizontal', true)
end

function _run_rails_console()
  cmd = string.format("bin/rails console", buffer_path)
  toggleTerm.exec(cmd, 13, 25, git_dir, 'float', true)
end

function _run_rails_server()
  cmd = 'bin/rails server'
  local terminal = Terminal:new({
    count = 11,
    cmd = cmd,
    dir = git_dir,
    direction = 'tab',
    close_on_exit = true,
    auto_scroll = true,
  })
  terminal:toggle()
end

function _run_rails_jobs()
  cmd = 'bin/rails jobs:work'
  local terminal = Terminal:new({
    count = 12,
    cmd = cmd,
    dir = git_dir,
    direction = 'tab',
    close_on_exit = true,
    auto_scroll = true,
  })
  terminal:toggle()
end

wk.register({
  r = {
    name = "rails",
    t = { "<cmd>lua _run_rails_test()<cr>", "test" },
    s = { "<cmd>lua _run_rails_server()<cr>", "server" },
    j = { "<cmd>lua _run_rails_jobs()<cr>", "jobs" },
    c = { "<cmd>lua _run_rails_console()<cr>", "console" },
  }
}, { prefix = "<leader>" })