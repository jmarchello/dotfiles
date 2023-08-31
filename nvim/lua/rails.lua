local wk = require("which-key")

-- local toggleTerm = require("toggleterm")
-- local Terminal = require("toggleterm.terminal").Terminal

-- local testTerm = Terminal:new({
--   count = 10,
--   dir = git_dir,
--   direction = 'float',
--   auto_scroll = true,
-- })
--
-- local consoleTerm = Terminal:new({
--   count = 11,
--   dir = git_dir,
--   direction = 'float',
--   auto_scroll = true,
-- })
--
-- local serverTerm = Terminal:new({
--   count = 12,
--   dir = git_dir,
--   direction = 'tab',
--   close_on_exit = true,
--   auto_scroll = true,
-- })
--
-- local jobsTerm = Terminal:new({
--   count = 13,
--   dir = git_dir,
--   direction = 'tab',
--   close_on_exit = true,
--   auto_scroll = true,
-- })
--
-- function _run_in_term(term, cmd, go_back)
--   if not term:is_open() then
--     term:open()
--   end
--   term:send(cmd, go_back)
-- end

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

-- function _run_rails_test()
--   local buffer_path = vim.api.nvim_buf_get_name(0)
--   if not string.match(buffer_path, "test/") then
--     buffer_path = string.gsub(buffer_path, "app/", "test/")
--     buffer_path = string.gsub(buffer_path, ".rb", "_test.rb")
--   end
--   cmd = string.format("bin/rails test %s", buffer_path)
--   _run_in_term(testTerm, cmd)
-- end
--
-- function _run_rails_console()
--   cmd = string.format("bin/rails console", buffer_path)
--   _run_in_term(consoleTerm, cmd)
-- end
--
-- function _run_rails_server()
--   cmd = 'bin/rails server'
--   if vim.fn.filereadable(".josh/rails_server.sh") then
--     cmd = ".josh/rails_server.sh"
--   end
--   _run_in_term(serverTerm, cmd)
--   serverTerm:set_mode("normal")
-- end
--
-- function _run_rails_jobs()
--   cmd = 'bin/rails jobs:work'
--   if vim.fn.filereadable(".josh/rails_jobs.sh") then
--     cmd = ".josh/rails_jobs.sh"
--   end
--   _run_in_term(jobsTerm, cmd)
--   serverTerm:set_mode("normal")
-- end

wk.register({
  -- r = {
  --   name = "rails",
  --   t = { "<cmd>lua _run_rails_test()<cr>", "test" },
  --   s = { "<cmd>lua _run_rails_server()<cr>", "server" },
  --   j = { "<cmd>lua _run_rails_jobs()<cr>", "jobs" },
  --   c = { "<cmd>lua _run_rails_console()<cr>", "console" },
  -- },
  ["."] = { "<cmd>lua _toggle_test_file()<cr>", "Toggle Test File" }
}, { prefix = "<leader>" })
