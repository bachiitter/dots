vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.have_nerd_font = true
vim.o.termguicolors = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = ''
vim.o.breakindent = true
vim.o.showmode = false
vim.o.cmdheight = 1
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes:1'
vim.o.updatetime = 100
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.wrap = false
vim.o.list = true
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.cmd 'set expandtab'
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.fillchars = { eob = ' ' }
vim.opt.title = true
vim.opt.winborder = 'single'
