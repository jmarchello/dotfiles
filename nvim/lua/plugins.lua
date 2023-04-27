--
-- Bootstrap lazy.nvim
--
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  'neovim/nvim-lspconfig',
  'L3MON4D3/LuaSnip',
  'github/copilot.vim',
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'tokyonight'
        }
      })
    end
  },
  { 'folke/tokyonight.nvim', lazy = false },
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  },
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup()
    end
  },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
  { 'akinsho/toggleterm.nvim', version = "*", config = true },
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "cmp-nvim-lsp",
      "cmp_luasnip",
      "cmp-buffer",
      "cmp-path",
      "cmp-cmdline",
    },
  },
  { "hrsh7th/cmp-nvim-lsp", lazy = true },
  { "saadparwaiz1/cmp_luasnip", lazy = true },
  { "hrsh7th/cmp-buffer", lazy = true },
  { "hrsh7th/cmp-path", lazy = true },
  { "hrsh7th/cmp-cmdline", lazy = true },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end
  },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" }
})

local wk = require('which-key')

--
-- Telescope
--

wk.register({
  f = {
    name = "Find",
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    b = { "<cmd>Telescope buffers<cr>", "Find File" },
    g = { "<cmd>Telescope live_grep<cr>", "Find File" }
  },
}, { prefix = "<leader>" })


--
-- NvimTree
--
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup({
  view = {
    float = {
      enable = true,
      quit_on_focus_loss = true
    },
    width = {}
  },
  update_focused_file = {
    enable = true
  }
})

wk.register({
  e = { '<cmd>NvimTreeToggle<cr>', 'NvimTree' },
}, { prefix = "<leader>" })

--
-- LazyGit
--
local Terminal = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = 'float' })

function _lazygit_toggle()
  lazygit:toggle()
end

wk.register({
  g = { '<cmd>lua _lazygit_toggle()<CR>', 'Git' }
}, { prefix = "<leader>" })

--
-- ToggleTerm
--
require("toggleterm").setup{}

wk.register({
  t = {
    name = 'Terminal',
    t = { '<cmd>1ToggleTerm dir=git_dir direction=float<cr>', 'floating terminal' },
    b = { '<cmd>1ToggleTerm dir=git_dir direction=horizontal<cr>', 'horizontal terminal' },
    v = { '<cmd>1ToggleTerm dir=git_dir direction=vertical<cr>', 'vertical terminal' },
  }
}, { prefix = '<leader>' })

-- Tokyonight
require("tokyonight").setup({
  style = 'night',
  transparent = true
})

vim.cmd[[colorscheme tokyonight]]

vim.cmd[[ hi LineNr guibg=NONE guifg=Grey ]]
vim.cmd[[ hi Comment guifg=Grey ]]
