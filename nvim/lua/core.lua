
-- Leader
vim.g.mapleader = ','

-- Tabs
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

-- UI
vim.opt.number = true
-- vim.opt.colorcolumn = '120'
-- vim.opt.signcolumn = 'yes'

-- netrw
vim.g.netrw_liststyle = 3

-- Folding
vim.g.foldmethod = 'manual'
vim.g.foldnestmax = 10
vim.g.nofoldenable = true

-- Grepping
if vim.fn.executable('rg') == 1 then
  vim.o.grepprg = 'rg --vimgrep'
end

-- Wildignore
vim.opt.wildignore = {
'**/node_modules/**',
'**/build/**',
'env/**'
}

--
-- KEYBINDINGS
--
local map = vim.api.nvim_set_keymap

---- Terminal
map('t', '<esc><esc>', '<C-\\><C-n>', { noremap = true })
map('t', '<A-h>', '<C-\\><C-N><C-w>h', { noremap = true })
map('t', '<A-j>', '<C-\\><C-N><C-w>j', { noremap = true })
map('t', '<A-k>', '<C-\\><C-N><C-w>k', { noremap = true })
map('t', '<A-l>', '<C-\\><C-N><C-w>l', { noremap = true })

---- Insert
map('i', '<A-h>', '<C-\\><C-N><C-w>h', { noremap = true })
map('i', '<A-j>', '<C-\\><C-N><C-w>j', { noremap = true })
map('i', '<A-k>', '<C-\\><C-N><C-w>k', { noremap = true })
map('i', '<A-l>', '<C-\\><C-N><C-w>l', { noremap = true })

---- Normal
------ Easy Window Movement
map('n', '<A-h>', '<C-w>h', { noremap = true})
map('n', '<A-j>', '<C-w>j', { noremap = true})
map('n', '<A-k>', '<C-w>k', { noremap = true})
map('n', '<A-l>', '<C-w>l', { noremap = true})

------ Cnext/CPrevious
map('n', '<Leader>cn', ':cnext<CR>', {})
map('n', '<Leader>cp', ':cprevious<CR>', {})

------ Clear Search Highlight
map('n', '<Leader>/', ':noh<CR>', {})

--
-- COMMANDS
--
function copy_current_file_name()
  vim.fn.setreg('*', vim.api.nvim_buf_get_name(0))
end

vim.api.nvim_create_user_command('CopyFileName', ':lua copy_current_file_name()', {})

--
-- AUTOCOMMANDS
--

---- Clear trailing whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', { command = ':%s/\\s\\+$//e' })

---- No Numbers in terminal
vim.api.nvim_create_autocmd('TermOpen', { command = 'setlocal nonumber norelativenumber' })

