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
  {
    'jmarchello/vim-monochrome',
    config = function()
      vim.g.monochrome_italic_comments = 1
      vim.cmd [[ colorscheme monochrome ]]
    end
  },
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


wk.register({
  e = { '<cmd>Explore<cr>', 'Explore' },
}, { prefix = "<leader>" })

