-- general
lvim.format_on_save = true
lvim.lint_on_save = true
-- lvim.colorscheme = "solarized"

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = ","
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
-- unmap a default keymapping
-- lvim.keys.normal_mode["<C-Up>"] = ""
-- edit a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>"

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>lua require'telescope'.extensions.project.project{}<CR>", "Projects" }
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+Trouble",
--   r = { "<cmd>Trouble lsp_references<cr>", "References" },
--   f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
--   d = { "<cmd>Trouble lsp_document_diagnostics<cr>", "Diagnosticss" },
--   q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
--   l = { "<cmd>Trouble loclist<cr>", "LocationList" },
--   w = { "<cmd>Trouble lsp_workspace_diagnostics<cr>", "Diagnosticss" },
-- }
lvim.builtin.which_key.mappings["t"] = {
  name = "+Rspec",
  t = {"<cmd>Dispatch rspec %<cr>", "Run Specs in current file"},
  a = {"<cmd>Dispatch rspec .<cr>"},
}

lvim.builtin.which_key.mappings["k"] = {
  name = "+QuickFix",
  k = {"<cmd>copen<cr>", "Open QuickFix buffer"},
  c = {"<cmd>cclose<cr>", "close QuickFix buffer"},
  n = {"<cmd>cnext<cr>", "Next QuickFix item"},
  p = {"<cmd>cprevious<cr>", "Previous QuickFix item"},
}

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.dashboard.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.side = "right"
lvim.builtin.nvimtree.width = 50
lvim.builtin.nvimtree.show_icons.git = 1
lvim.builtin.nvimtree.quit_on_open = 1
lvim.builtin.nvimtree.auto_open = 0
lvim.builtin.nvimtree.hide_dotfiles = 0
vim.g.rooter_patterns = {'.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json', 'requirements.txt', 'Gemfile', 'go.mod'}
vim.wo.wrap = true
vim.o.foldmethod = 'indent'
vim.o.foldlevelstart = 99

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {}
lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- generic LSP settings
-- you can set a custom on_attach function that will be used for all the language servers
-- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- set a formatter if you want to override the default lsp one (if it exists)
-- lvim.lang.python.formatters = {
--   {
--     exe = "black",
--     args = {}
--   }
-- }
-- set an additional linter
-- lvim.lang.python.linters = {
--   {
--     exe = "flake8",
--     args = {}
--   }
-- }
lvim.lang.ruby.lsp.setup.cmd = {"solargraph", "stdio"}
lvim.lang.javascript.linters = {
  {
    exe = "eslint_d",
    args = {}
  }
}

require('lspconfig').stylelint_lsp.setup {
 filetypes = {
    'css',
    'less',
    'scss',
  },
  settings = {
    stylelintplus = {
      autoFixOnSave = true,
      autoFixOnFormat = true,
    }
  },
}

-- Additional Plugins
lvim.plugins = {
  {"tpope/vim-rails"},
  {"tpope/vim-dispatch"},
  {"tpope/vim-fugitive"}
--     {"folke/tokyonight.nvim"}, {
--         "ray-x/lsp_signature.nvim",
--         config = function() require"lsp_signature".on_attach() end,
--         event = "InsertEnter"
--     },
}

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- lvim.autocommands.custom_groups = {
--   { "BufWritePre", "*", "%s/\s\+$//e" },
-- }

vim.api.nvim_set_option('grepprg', 'rg --vimgrep')

vim.cmd [[
  au VimEnter * hi DiffText guibg=#0c7d9d guifg=#bbbbbb
]]
