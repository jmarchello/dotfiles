local wk = require("which-key")

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

wk.register({
  ["."] = { "<cmd>lua _toggle_test_file()<cr>", "Toggle Test File" }
}, { prefix = "<leader>" })
