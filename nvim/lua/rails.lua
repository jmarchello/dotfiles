local wk = require("which-key")

local toggleTerm = require("toggleterm")
local Terminal = require("toggleterm.terminal").Terminal

function _run_rails_test()
  local buffer_path = vim.api.nvim_buf_get_name(0)
  if not string.match(buffer_path, "test/") then
    buffer_path = string.gsub(buffer_path, "app/", "test/")
    buffer_path = string.gsub(buffer_path, ".rb", "_test.rb")
  end
  cmd = string.format("bin/rails test %s", buffer_path)
  toggleTerm.exec(cmd, 1, 25, git_dir, 'float', true)
end

function _toggle_test_file()
  local buffer_path = vim.api.nvim_buf_get_name(0)
  if string.match(buffer_path, "test/") then
    buffer_path = string.gsub(buffer_path, "test/", "app/")
    buffer_path = string.gsub(buffer_path, "_test.rb", ".rb")
  else
    buffer_path = string.gsub(buffer_path, "app/", "test/")
    buffer_path = string.gsub(buffer_path, ".rb", "_test.rb")
  end
  if not vim.fn.filereadable(buffer_path) then
    if vim.fn.input("Create test file? [y/n]: ") == "n" then
     return
    end
  end
  vim.api.nvim_command("edit " .. buffer_path)
end

function _run_rails_console()
  cmd = string.format("bin/rails console", buffer_path)
  toggleTerm.exec(cmd, 13, 25, git_dir, 'float', true)
end

function _run_rails_server()
  cmd = 'bin/rails server'
  if vim.fn.filereadable(".josh/rails_server.sh") then
    cmd = ".josh/rails_server.sh"
  end
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
  if vim.fn.filereadable(".josh/rails_jobs.sh") then
    cmd = ".josh/rails_jobs.sh"
  end
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
  },
  ["."] = { "<cmd>lua _toggle_test_file()<cr>", "Toggle Test File" }
}, { prefix = "<leader>" })
