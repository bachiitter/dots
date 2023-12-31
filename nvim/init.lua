vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Lazy Package Manager ]]

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  install = {
    missing = true,
  },
  checker = {
    enabled = true,
  },
  change_detection = {
    enabled = true,
  },
  ui = {
    icons = {
      ft = "",
      lazy = "󰂠 ",
      loaded = "",
      not_loaded = "",
    },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "ftplugin",
        "gzip",
        "matchit",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
      },
    },
  },
})

-- [[ Options ]]
local opts = vim.o

opts.hlsearch = false

opts.number = true
opts.relativenumber = true

opts.tabstop = 2
opts.softtabstop = 2
opts.shiftwidth = 2
opts.expandtab = true
opts.smartindent = true

opts.mouse = "a"

opts.clipboard = "unnamedplus"

opts.breakindent = true

opts.undofile = true
opts.swapfile = false
opts.backup = false

opts.ignorecase = true
opts.smartcase = true

opts.scrolloff = 8
opts.signcolumn = "yes"

opts.updatetime = 250
opts.timeout = true
opts.timeoutlen = 300

opts.termguicolors = true
opts.background = "dark"

opts.cursorline = true

vim.opt.fillchars:append { eob = " " }

-- [[ Create autocmd ]]
local autocmd = vim.api.nvim_create_autocmd

local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

--- [[ Remove all trailing whitespace on save ]]
local TrimWhiteSpaceGrp =
  vim.api.nvim_create_augroup("TrimWhiteSpaceGrp", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  command = [[:%s/\s\+$//e]],
  group = TrimWhiteSpaceGrp,
})

-- [[ Disable Auto Commenting ]]
vim.cmd [[au BufEnter * set fo-=c fo-=r fo-=o]]

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group =
  vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- [[ Wrap and spell check text files ]]
autocmd("FileType", {
  group = augroup "wrap_spell",
  pattern = { "gitcommit", "markdown", "norg" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- [[ Keymaps ]]

local map = vim.keymap.set

-- See `:help vim.keymap.set()`
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Move selected line / block of text in visual mode
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor centered when scrolling
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Move line up/down
map("n", "<leader>j", "ddp", {})
map("n", "<leader>k", "ddkP", {})

-- Better paste
map("v", "p", [["_dP]])

-- Copy line
map("n", "<leader>l", "yyp", {})
map("n", "<leader>Y", [["+Y]])

-- New empty line
map("n", "<leader>o", "o<Esc>", {})
map("n", "<leader>O", "O<Esc>", {})
