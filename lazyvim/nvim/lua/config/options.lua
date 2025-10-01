-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

if vim.fn.executable("asdf") == 1 then
  vim.env.PATH = vim.fn.expand("~/.asdf/shims:" .. vim.env.PATH)
end

function copy_current_file_name()
  vim.fn.setreg("+", vim.api.nvim_buf_get_name(0))
end

vim.api.nvim_create_user_command("CopyFileName", ":lua copy_current_file_name()", {})

vim.opt.clipboard = ""

vim.g.lazyvim_prettier_needs_config = false
