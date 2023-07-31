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
  'fxn/vim-monochrome',
  -- 'L3MON4D3/LuaSnip',
  -- 'github/copilot.vim',
  -- {
  --   'nvim-lualine/lualine.nvim',
  --   dependencies = { 'nvim-tree/nvim-web-devicons' },
  --   config = function()
  --     require('lualine').setup({
  --       options = {
  --         theme = 'tokyonight'
  --       }
  --     })
  --   end
  -- },
  -- { 'folke/tokyonight.nvim', lazy = false },
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
  -- { 'akinsho/toggleterm.nvim', version = "*", config = true },
  -- {
  --   "hrsh7th/nvim-cmp",
  --   event = { "InsertEnter", "CmdlineEnter" },
  --   dependencies = {
  --     "cmp-nvim-lsp",
  --     "cmp_luasnip",
  --     "cmp-buffer",
  --     "cmp-path",
  --     "cmp-cmdline",
  --   },
  -- },
  -- { "hrsh7th/cmp-nvim-lsp", lazy = true },
  -- { "saadparwaiz1/cmp_luasnip", lazy = true },
  -- { "hrsh7th/cmp-buffer", lazy = true },
  -- { "hrsh7th/cmp-path", lazy = true },
  -- { "hrsh7th/cmp-cmdline", lazy = true },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        current_line_blame = false,
        current_line_blame_opts = {
          virt_text_pos = 'eol'
        }
      })
    end
  }
})

local wk = require('which-key')

--
-- ColorScheme
--
vim.g.monochrome_italic_comments = 1
vim.cmd [[ colorscheme monochrome ]]

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
  },
  git = {
    ignore = false
  }
})

wk.register({
  e = { '<cmd>NvimTreeToggle<cr>', 'NvimTree' },
}, { prefix = "<leader>" })


--
-- LazyGit
--
-- local Terminal = require('toggleterm.terminal').Terminal
-- local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = 'float' })

-- function _lazygit_toggle()
--   lazygit:toggle()
-- end

-- wk.register({
--   g = { '<cmd>lua _lazygit_toggle()<CR>', 'Git' }
-- }, { prefix = "<leader>" })

--
-- ToggleTerm
--
-- local toggleTerm = require('toggleterm')
-- local TerminalMod = require('toggleterm.terminal')
--
-- toggleTerm.setup{}
--
--
-- function _toggle_focused_term()
--   local focused_id = TerminalMod.get_focused_id()
--   toggleTerm.toggle(focused_id)
-- end
--
--
-- wk.register({
--   t = {
--     name = 'Terminal',
--     t = { '<cmd>1ToggleTerm dir=git_dir direction=float<cr>', 'floating terminal' },
--     b = { '<cmd>1ToggleTerm dir=git_dir direction=horizontal<cr>', 'horizontal terminal' },
--     v = { '<cmd>1ToggleTerm dir=git_dir direction=vertical<cr>', 'vertical terminal' },
--   }
-- }, { prefix = '<leader>' })
--
-- wk.register({
--   ['<esc><esc>'] = { '<cmd>lua _toggle_focused_term()<cr>', 'close all terminals' }
-- }, { mode = 't' })
--
-- -- Tokyonight
-- require("tokyonight").setup({
--   style = 'night',
--   transparent = true
-- })
--
-- vim.cmd[[colorscheme tokyonight]]
--
-- vim.cmd[[ hi LineNr guibg=NONE guifg=Grey ]]
-- vim.cmd[[ hi Comment guifg=Grey ]]

-- Treesitter
-- vim.opt.foldmethod = 'expr'
-- vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
-- vim.opt.foldenable = false
