-- =============================================================================
-- init.lua — Neovim configuration
-- =============================================================================

-- Leader keys must be set BEFORE lazy.nvim loads (fix #2)
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

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
local map = vim.keymap.set

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Keep cursor centered when scrolling (fix #5 — added desc)
map("n", "<C-d>", "<C-d>zz",  { desc = "Scroll down (centered)" })
map("n", "<C-u>", "<C-u>zz",  { desc = "Scroll up (centered)" })
map("n", "n",     "nzzzv",    { desc = "Next search result (centered)" })
map("n", "N",     "Nzzzv",    { desc = "Prev search result (centered)" })

-- Move selected lines up/down in visual mode (fix #5 — added desc)
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Don't overwrite clipboard when pasting over selection
map("x", "<leader>p", [["_dP]], { desc = "Paste without overwriting clipboard" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Quit without saving
map("n", "<leader>q", "<cmd>q!<CR>", { desc = "Quit without saving" })

-- Neo-tree toggle
map("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" })
map("n", "<leader>o", "<cmd>Neotree focus<CR>",  { desc = "Focus file explorer" })

-- Buffer navigation
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>",     { desc = "Next buffer" })

-- --- Bootstrap lazy.nvim -----------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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
      require("gruvbox").setup({ contrast = "hard", transparent_mode = true })
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
        -- fix #1 — merged both window blocks into one
        window = {
          width = 30,
          mappings = {
            ["l"] = "open",
            ["h"] = "close_node",
          },
        },
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

  -- Fuzzy finder (fix #3 — consistent 2-space indent inside plugin table)
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- suggestion #6 — fzf native for faster sorting (requires `brew install make` / build tools)
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>",  desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>",   desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>",     desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>",   desc = "Help tags" },
      -- Git keys
      { "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = "Git branches (switch)" },
      { "<leader>gs", "<cmd>Telescope git_status<CR>",   desc = "Git status" },
      { "<leader>gc", "<cmd>Telescope git_commits<CR>",  desc = "Git commits" },  -- suggestion #4
    },
    config = function()
      require("telescope").setup({
        defaults = {
          preview = { treesitter = false },
        },
      })
      -- load fzf extension (suggestion #6)
      pcall(require("telescope").load_extension, "fzf")
    end,
  },

  -- Treesitter (better syntax highlighting)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufReadPost",
    config = function()
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if not ok then return end
      configs.setup({
        ensure_installed = { "lua", "python", "javascript", "typescript", "bash", "json", "yaml", "markdown" },
        highlight        = { enable = true },
        indent           = { enable = true },
      })
    end,
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

