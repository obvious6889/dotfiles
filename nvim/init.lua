-- =============================================================================
-- init.lua — Neovim configuration
-- =============================================================================

-- --- Options -----------------------------------------------------------------
local opt = vim.opt

opt.number         = true          -- line numbers
opt.relativenumber = true          -- relative line numbers
opt.signcolumn     = "yes"         -- always show sign column
opt.cursorline     = true          -- highlight current line

opt.tabstop        = 4             -- tab width
opt.shiftwidth     = 4             -- indent width
opt.expandtab      = true          -- spaces instead of tabs
opt.smartindent    = true          -- smart auto-indenting

opt.wrap           = false         -- no line wrapping
opt.scrolloff      = 8             -- keep 8 lines above/below cursor
opt.sidescrolloff  = 8

opt.hlsearch       = true          -- highlight search results
opt.incsearch      = true          -- incremental search
opt.ignorecase     = true          -- case-insensitive search...
opt.smartcase      = true          -- ...unless uppercase used

opt.splitbelow     = true          -- horizontal splits go below
opt.splitright     = true          -- vertical splits go right

opt.termguicolors  = true          -- true color support
opt.background     = "dark"

opt.undofile       = true          -- persistent undo
opt.swapfile       = false
opt.backup         = false

opt.updatetime     = 250           -- faster CursorHold events
opt.timeoutlen     = 300           -- faster key sequence timeout

opt.clipboard      = "unnamedplus" -- sync with system clipboard

-- --- Keymaps -----------------------------------------------------------------
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Keep cursor centered when scrolling
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n",     "nzzzv")
map("n", "N",     "Nzzzv")

-- Move selected lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Don't overwrite clipboard when pasting over selection
map("x", "<leader>p", [["_dP]], { desc = "Paste without overwriting clipboard" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Neo-tree toggle
map("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" })
map("n", "<leader>o", "<cmd>Neotree focus<CR>",  { desc = "Focus file explorer" })

-- Buffer navigation
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>",     { desc = "Next buffer" })

-- --- Bootstrap lazy.nvim -----------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- --- Plugins -----------------------------------------------------------------
require("lazy").setup({

  -- Colorscheme (gruvbox to match your starship theme)
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({ contrast = "hard" })
      vim.cmd.colorscheme("gruvbox")
    end,
  },

  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        window = { width = 30 },
        filesystem = {
          filtered_items = {
            hide_dotfiles   = false,
            hide_gitignored = false,
          },
          follow_current_file = { enabled = true },
        },
      })
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({ options = { theme = "gruvbox" } })
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>",  desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>",   desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>",     desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>",   desc = "Help tags" },
    },
  },

  -- Treesitter (better syntax highlighting)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main  = "nvim-treesitter.configs",
    opts  = {
      ensure_installed = { "lua", "python", "javascript", "typescript", "bash", "json", "yaml", "markdown" },
      highlight        = { enable = true },
      indent           = { enable = true },
    },
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event  = "InsertEnter",
    config = true,
  },

  -- Git signs in gutter
  {
    "lewis6991/gitsigns.nvim",
    config = true,
  },

  -- Comment toggling
  {
    "numToStr/Comment.nvim",
    config = true,
  },

  -- Which-key (shows available keybindings)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = true,
  },

})
