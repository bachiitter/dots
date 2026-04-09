--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------
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

-- Run TSUpdate if Treesitter is updated
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'nvim-treesitter' and kind == 'update' then
      if not ev.data.active then
        vim.cmd.packadd 'nvim-treesitter'
      end
      vim.cmd 'TSUpdate'
    end
  end,
})

--------------------------------------------------------------------------------
-- Plugins
--------------------------------------------------------------------------------
vim.pack.add {
  { src = 'https://github.com/bachiitter/orng.nvim' },
  { src = 'https://github.com/folke/snacks.nvim' },
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/nvim-mini/mini.nvim' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', branch = 'main' },
  { src = 'https://github.com/saghen/blink.cmp' },
  { src = 'https://github.com/stevearc/conform.nvim' },
  { src = 'https://github.com/stevearc/oil.nvim' },
  { src = 'https://github.com/mason-org/mason.nvim' },
}

-- Colorscheme (immediate)
require('orng').setup {
  transparent = true, -- Enable transparent background
}

vim.cmd.colorscheme 'orng'

-- Mini (immediate - lightweight)
require('mini.pairs').setup {
  modes = { command = true },
}
require('mini.statusline').setup()
require('mini.icons').setup()

-- Snacks (immediate - needed for keybinds)
local Snacks = require 'snacks'

-- Guard against double-setup when re-sourcing init.lua
if not vim.g.snacks_setup_done then
  Snacks.setup {
    input = { enabled = true },
    picker = {
      enabled = true,
      previewers = {
        diff = { style = 'fancy' },
      },
      layout = {
        preset = 'sidebar', -- or "ivy", "vertical", "sidebar", "vscode", etc.
      },
    },
  }
  vim.g.snacks_setup_done = true
end

--------------------------------------------------------------------------------
-- Helper Functions
--------------------------------------------------------------------------------
local function pack_clean()
  local unused_plugins = {}

  for _, plugin in ipairs(vim.pack.get()) do
    if not plugin.active then
      table.insert(unused_plugins, plugin.spec.name)
    end
  end

  if #unused_plugins == 0 then
    print 'No unused plugins'
    return
  end

  local choice = vim.fn.confirm('Remove unused plugins', '&Yes\n&No', 2)
  if choice == 1 then
    vim.pack.del(unused_plugins)
  end
end

--------------------------------------------------------------------------------
-- Keymaps
--------------------------------------------------------------------------------

-- General
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>e', function()
  vim.diagnostic.open_float { scope = 'line' }
end, { desc = 'Diagnostic float' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostic quickfix' })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set('v', 'p', '"_dP', { silent = true })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Focus left' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Focus right' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Focus down' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Focus up' })
vim.keymap.set('n', '<leader>ec', function()
  vim.cmd.edit(vim.fn.stdpath 'config' .. '/init.lua')
end, { desc = 'Edit config' })

vim.keymap.set('n', '<leader>pc', pack_clean)

-- Search (Snacks picker)
vim.keymap.set('n', '<leader>sf', function()
  Snacks.picker.git_files()
end, { desc = 'Search Files (git)' })
vim.keymap.set('n', '<leader>sa', function()
  Snacks.picker.files()
end, { desc = 'Search All Files' })
vim.keymap.set('n', '<leader>sg', function()
  Snacks.picker.grep()
end, { desc = 'Search Grep' })
vim.keymap.set('n', '<leader>sd', function()
  Snacks.picker.diagnostics()
end, { desc = 'Search Diagnostics' })
vim.keymap.set('n', '<leader><leader>', function()
  Snacks.picker.buffers()
end, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>sp', function()
  Snacks.picker.projects()
end, { desc = 'Search Projects' })
vim.keymap.set('n', '<leader>s/', function()
  Snacks.picker.lines()
end, { desc = 'Search Projects' })

-- Format
vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
  require('conform').format { async = true, lsp_format = 'never', stop_after_first = true }
end, { desc = 'Format buffer' })

-- Oil
vim.keymap.set('n', '<leader>-', function()
  require('oil').toggle_float()
end, { desc = 'Oil' })

--------------------------------------------------------------------------------
-- Autocmds
--------------------------------------------------------------------------------
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd('BufEnter', {
  group = augroup('no-auto-comment', { clear = true }),
  command = 'set formatoptions-=cro',
})

-- Highlight when yanking (copying) text
autocmd('TextYankPost', {
  group = augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank { timeout = 200 }
  end,
})

-- Enable spell check for md and texg files
autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.txt', '*.md', '*.mdx', '*.tex' },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = 'en'
  end,
})

-- Restore cursor position on file open
vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Restore cursor position on file open',
  group = vim.api.nvim_create_augroup('kickstart-restore-cursor', { clear = true }),
  pattern = '*',
  callback = function()
    local line = vim.fn.line '\'"'
    if line > 1 and line <= vim.fn.line '$' then
      vim.cmd 'normal! g\'"'
    end
  end,
})

--------------------------------------------------------------------------------
-- Diagnostics
--------------------------------------------------------------------------------
vim.diagnostic.config {
  severity_sort = true,
  update_in_insert = false,
  float = {
    border = 'rounded',
    source = 'if_many',
  },
  underline = true,
  virtual_text = {
    spacing = 2,
    source = 'if_many',
    prefix = '●',
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  },
}

--------------------------------------------------------------------------------
-- LSP
--------------------------------------------------------------------------------
vim.lsp.config('tailwindcss', {
  settings = {
    tailwindCSS = {
      classFunctions = { 'cva', 'cx', 'cn' },
    },
  },
})

vim.lsp.enable { 'astro', 'biome', 'cssls', 'gopls', 'jsonls', 'lua_ls', 'tailwindcss', 'tsgo' }

require('mason').setup()

autocmd('LspAttach', {
  group = augroup('lsp-attach', { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    map('n', 'K', vim.lsp.buf.hover, 'LSP Hover')
    map('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
    map('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration')
    map('n', 'gi', vim.lsp.buf.implementation, 'Go to implementation')
    map('n', 'gr', vim.lsp.buf.references, 'References')
    map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename symbol')
    map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, 'Code action')

    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    if client:supports_method('textDocument/documentHighlight', args.buf) then
      local hl_group = augroup('lsp-highlight', { clear = false })
      autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = args.buf,
        group = hl_group,
        callback = vim.lsp.buf.document_highlight,
      })
      autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = args.buf,
        group = hl_group,
        callback = vim.lsp.buf.clear_references,
      })
      autocmd('LspDetach', {
        group = augroup('lsp-detach', { clear = true }),
        callback = function(e)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = e.buf }
        end,
      })
    end

    if client:supports_method('textDocument/inlayHint', args.buf) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = args.buf })
      end, 'Toggle Inlay Hints')
    end
  end,
})

-- Treesitter
require('nvim-treesitter').install {
  'astro',
  'bash',
  'css',
  'go',
  'gomod',
  'gosum',
  'gowork',
  'html',
  'javascript',
  'json',
  'lua',
  'luadoc',
  'markdown',
  'toml',
  'tsx',
  'typescript',
  'yaml',
}

vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local buf, filetype = args.buf, args.match

    local language = vim.treesitter.language.get_lang(filetype)
    if not language then
      return
    end

    -- check if parser exists and load it
    if not vim.treesitter.language.add(language) then
      return
    end
    -- enables syntax highlighting and other treesitter features
    vim.treesitter.start(buf, language)

    vim.opt.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- Gitsigns
require('gitsigns').setup {
  signs = { add = { text = '+' }, change = { text = '~' }, delete = { text = '_' }, topdelete = { text = '‾' }, changedelete = { text = '~' } },
  current_line_blame = true,
  current_line_blame_opts = { delay = 500 },
  current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
}

-- Conform
require('conform').setup {
  notify_on_error = false,
  format_on_save = { timeout_ms = 500, lsp_format = 'never' },
  formatters_by_ft = {
    astro = { 'biome' },
    css = { 'biome' },
    go = { 'goimports', 'gofumpt' },
    html = { 'biome' },
    javascript = { 'biome' },
    json = { 'biome' },
    lua = { 'stylua' },
    typescript = { 'biome' },
    typescriptreact = { 'biome' },
  },
}

-- Oil
_G.OilBar = function()
  return '  ' .. vim.fn.fnamemodify(vim.fn.expand('%'):gsub('oil://', ''), ':.')
end

require('oil').setup {
  columns = { 'icon' },
  keymaps = { ['<C-h>'] = false, ['<C-l>'] = false, ['<C-k>'] = false, ['<C-j>'] = false, ['<M-h>'] = 'actions.select_split', ['<C-r>'] = 'actions.refresh' },
  win_options = { winbar = '%{v:lua.OilBar()}' },
  view_options = { show_hidden = true },
}

-- Blink.cmp
require('blink.cmp').setup {
  keymap = {
    ['<C-p>'] = { 'select_prev', 'fallback' },
    ['<C-n>'] = { 'select_next', 'fallback' },
    ['<C-c>'] = { 'cancel', 'fallback' },
    ['<CR>'] = { 'select_and_accept', 'fallback' },
    ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
    ['<C-Space>'] = { 'show', 'fallback' },
    ['<Tab>'] = {
      function(cmp)
        return cmp.snippet_active() and cmp.snippet_forward() or cmp.select_next()
      end,
      'fallback',
    },
    ['<S-Tab>'] = {
      function(cmp)
        return cmp.snippet_active() and cmp.snippet_backward() or cmp.select_prev()
      end,
      'fallback',
    },
  },
  appearance = { use_nvim_cmp_as_default = false, nerd_font_variant = 'normal' },
  sources = {
    default = { 'lsp', 'path', 'buffer' },
    providers = {
      lsp = { score_offset = 1000 },
      path = { score_offset = 3 },
      buffer = { score_offset = -150, min_keyword_length = 4 },
    },
  },
  signature = {
    enabled = true,
    trigger = { show_on_trigger_character = false, show_on_insert_on_trigger_character = false },
    window = { border = 'rounded', show_documentation = true },
  },
  completion = {
    trigger = { show_on_trigger_character = true },
    menu = {
      border = 'rounded',
      max_height = 10,
      auto_show = true,
      draw = {
        columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'source_name' } },
        components = {
          source_name = {
            text = function(ctx)
              return ({ lsp = '[LSP]', buffer = '[Buf]', path = '[Path]' })[ctx.source_name] or ('[' .. ctx.source_name .. ']')
            end,
            highlight = 'CmpItemMenu',
          },
        },
      },
    },
    documentation = { auto_show = true, window = { border = 'rounded' } },
    ghost_text = { enabled = true },
    list = { selection = { preselect = true } },
    accept = { auto_brackets = { enabled = true } },
  },
  fuzzy = { implementation = 'lua' },
}
