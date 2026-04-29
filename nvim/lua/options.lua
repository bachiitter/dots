-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.localleader = ' '

-- Disable netrw (immediate)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Disable Providers (silence health check warnings)
vim.g.loaded_node_provider = 0 -- Disable Node.js provider
vim.g.loaded_perl_provider = 0 -- Disable Perl provider
vim.g.loaded_python3_provider = 0 -- Disable Python 3 provider
vim.g.loaded_ruby_provider = 0 -- Disable Ruby provider

local o = vim.o

-- Basic settings
o.mouse = '' -- Disable mouse support
o.number = true -- Line numbers
o.relativenumber = true -- Relative line numbers
o.cursorline = true -- Highlight current line
o.wrap = false -- Don't wrap lines
o.scrolloff = 10 -- Keep 10 lines above/below cursor
o.sidescrolloff = 8 -- Keep 8 columns left/right of cursor
vim.schedule(function() -- Use system clipboard
  vim.o.clipboard = 'unnamedplus'
end)
o.backspace = 'indent,eol,start' -- Better backspace behavior
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' } -- Completion options
o.conceallevel = 0 -- Show all text normally (no concealment)
o.autoread = true -- Automatically reload files changed outside of Neovim

-- Indentation
o.tabstop = 2 -- Tab width
o.shiftwidth = 2 -- Indent width
o.softtabstop = 2 -- Soft tab stop
o.expandtab = true -- Use spaces instead of tabs
o.smartindent = true -- Smart auto-indenting
o.autoindent = true -- Copy indent from current line

-- Search settings
o.ignorecase = true -- Case insensitive search
o.smartcase = true -- Case sensitive if uppercase in search
o.hlsearch = false -- Don't highlight search results
o.incsearch = true -- Show matches as you type
o.inccommand = 'split' -- Show matches in a split

-- Visual settings
o.termguicolors = true -- Enable 24-bit colors
o.signcolumn = 'yes:1' -- Always show sign column
o.showmatch = true -- Highlight matching brackets
o.cmdheight = 1 -- Command line height
o.showmode = false -- Don't show mode in command line
o.undofile = false -- Don't create undo file
o.swapfile = false -- Don't create swap files
o.updatetime = 100 -- Faster completion
o.timeoutlen = 300 -- Key timeout duration
o.splitright = true -- Vertical splits go right
o.splitbelow = true -- Horizontal splits go below
vim.opt.fillchars = { eob = ' ' } -- Hide ~ characters on empty lines
vim.opt.winborder = 'single' -- Set popup border to single line

vim.diagnostic.config {
  severity_sort = true,
  update_in_insert = false,
  float = {
    border = 'rounded',
    source = 'if_many',
  },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = {
    spacing = 2,
    source = 'if_many',
    prefix = '●',
  },
  virtual_line = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  },
  jump = { float = true },
}
