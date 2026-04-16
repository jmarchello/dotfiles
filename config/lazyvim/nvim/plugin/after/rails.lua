local wk = require("which-key")

local function _get_source_dir()
  local cwd = vim.fn.getcwd()
  local app_path = cwd .. "/app"
  if vim.fn.isdirectory(app_path) == 1 then
    return "app/"
  else
    return "lib/"
  end
end

local function _get_test_dir()
  local cwd = vim.fn.getcwd()
  local app_path = cwd .. "/spec"
  if vim.fn.isdirectory(app_path) == 1 then
    return "spec/"
  else
    return "test/"
  end
end

function _toggle_test_file()
  local source_dir = _get_source_dir()
  local test_dir = _get_test_dir()
  local test_file_suffix = "_" .. test_dir:gsub("/", ".rb")
  local buffer_path = vim.api.nvim_buf_get_name(0)
  if string.match(buffer_path, test_dir) then
    buffer_path = string.gsub(buffer_path, test_dir, source_dir)
    buffer_path = string.gsub(buffer_path, test_file_suffix, ".rb")
  else
    buffer_path = string.gsub(buffer_path, source_dir, test_dir)
    buffer_path = string.gsub(buffer_path, ".rb", test_file_suffix)
  end
  if not vim.fn.filereadable(buffer_path) then
    if vim.fn.input("Create test file? [y/n]: ") == "n" then
      return
    end
  end
  vim.api.nvim_command("edit " .. buffer_path)
end

wk.add({
  { "<leader>.", "<cmd>lua _toggle_test_file()<cr>", desc = "Toggle Test File" },
})
