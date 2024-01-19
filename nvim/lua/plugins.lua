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
  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {},
  -- },
  { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = {}},
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.1.1",
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        -- options = {
        --   theme = 'tokyonight'
        -- }
      })
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
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
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
-- require("tokyonight").setup({
--   -- your configuration comes here
--   -- or leave it empty to use the default settings
--   style = "day", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
--   terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
--   styles = {
--     -- Style to be applied to different syntax groups
--     -- Value is any valid attr-list value for `:help nvim_set_hl`
--     comments = { italic = true },
--     keywords = { italic = true },
--     functions = {},
--     variables = {},
--     -- Background styles. Can be "dark", "transparent" or "normal"
--     sidebars = "dark", -- style for sidebars, see below
--     floats = "dark", -- style for floating windows
--   },
--   lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold
-- })
--
-- vim.cmd[[colorscheme tokyonight]]

require("gruvbox").setup({
  terminal_colors = true, -- add neovim terminal colors
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = false,
    emphasis = true,
    comments = true,
    operators = false,
    folds = true,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = false,
})
vim.o.background = "dark"
vim.cmd("colorscheme gruvbox")

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

-- Treesitter
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "lua", "vim", "vimdoc", "query", "sql", "ruby", "go", "html", "css", "javascript" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = {},

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = {},

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldenable = false

