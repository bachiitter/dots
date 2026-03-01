--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------
vim.g.mapleader = ' '
vim.g.localleader = ' '

local o = vim.o
o.termguicolors = true
o.number = true
o.relativenumber = true
o.showmode = false
o.mouse = ''
o.breakindent = true
o.undofile = true
o.ignorecase = true
o.smartcase = true
o.signcolumn = 'yes:1'
o.updatetime = 100
o.timeoutlen = 300
o.splitright = true
o.splitbelow = true
o.wrap = false
o.list = true
o.inccommand = 'split'
o.cursorline = true
o.scrolloff = 10
o.expandtab = true
o.tabstop = 2
o.softtabstop = 2
o.shiftwidth = 2

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.fillchars = { eob = ' ' }
vim.opt.winborder = 'single'

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
require('mini.pairs').setup()
require('mini.statusline').setup()
require('mini.icons').setup()

-- Snacks (immediate - needed for keybinds)
local Snacks = require 'snacks'

-- Guard against double-setup when re-sourcing init.lua
if not vim.g.snacks_setup_done then
  Snacks.setup { input = { enabled = true }, picker = { enabled = true } }
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
local map = vim.keymap.set

-- General
map('n', '<Esc>', '<cmd>nohlsearch<CR>')
map('n', '<leader>e', function()
  vim.diagnostic.open_float { scope = 'line' }
end, { desc = 'Diagnostic float' })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostic quickfix' })
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
map('v', 'p', '"_dP', { silent = true })

map('n', '<C-h>', '<C-w><C-h>', { desc = 'Focus left' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Focus right' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Focus down' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Focus up' })
map('n', '<leader>ec', function()
  vim.cmd.edit(vim.fn.stdpath 'config' .. '/init.lua')
end, { desc = 'Edit config' })

map('n', '<leader>pc', pack_clean)

-- Search (Snacks picker)
map('n', '<leader>sf', function()
  Snacks.picker.git_files()
end, { desc = 'Search Files (git)' })
map('n', '<leader>sa', function()
  Snacks.picker.files()
end, { desc = 'Search All Files' })
map('n', '<leader>sg', function()
  Snacks.picker.grep()
end, { desc = 'Search Grep' })
map('n', '<leader>sd', function()
  Snacks.picker.diagnostics()
end, { desc = 'Search Diagnostics' })
map('n', '<leader><leader>', function()
  Snacks.picker.buffers()
end, { desc = 'Buffers' })
map('n', '<leader>sp', function()
  Snacks.picker.projects()
end, { desc = 'Search Projects' })
map('n', '<leader>s/', function()
  Snacks.picker.lines()
end, { desc = 'Search Projects' })

-- Format
map({ 'n', 'v' }, '<leader>f', function()
  require('conform').format { async = true, lsp_format = 'never', stop_after_first = true }
end, { desc = 'Format buffer' })

-- Oil
map('n', '<leader>-', function()
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
  virtual_text = true,
  virtual_lines = false,
  underline = { severity = vim.diagnostic.severity.ERROR },
  update_in_insert = false,
  severity_sort = true,
  jump = { float = true },
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
vim.lsp.enable { 'astro', 'biome', 'cssls', 'gopls', 'jsonls', 'lua_ls', 'tailwindcss', 'vtsls' }

require('mason').setup()

autocmd('LspAttach', {
  group = augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local function lsp_map(keys, func, desc, mode)
      map(mode or 'n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    lsp_map('gd', function()
      Snacks.picker.lsp_definitions()
    end, 'Goto Definition')
    lsp_map('gr', function()
      Snacks.picker.lsp_references()
    end, 'Goto References')
    lsp_map('gi', function()
      Snacks.picker.lsp_implementations()
    end, 'Goto Implementation')
    lsp_map('gD', vim.lsp.buf.declaration, 'Goto Declaration')
    lsp_map('<leader>D', function()
      Snacks.picker.lsp_type_definitions()
    end, 'Type Definition')
    lsp_map('<leader>ds', function()
      Snacks.picker.lsp_symbols()
    end, 'Document Symbols')
    lsp_map('<leader>ws', function()
      Snacks.picker.lsp_workspace_symbols()
    end, 'Workspace Symbols')
    lsp_map('<leader>rn', vim.lsp.buf.rename, 'Rename')
    lsp_map('<leader>ca', function()
      vim.lsp.buf.code_action {
        filter = function(a)
          return a.disabled == nil
        end,
      }
    end, 'Code Action', { 'n', 'v' })
    lsp_map('<C-s>', vim.lsp.buf.signature_help, 'Signature Help')

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end

    if client:supports_method('textDocument/documentHighlight', event.buf) then
      local hl_group = augroup('lsp-highlight', { clear = false })
      autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = hl_group,
        callback = vim.lsp.buf.document_highlight,
      })
      autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
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

    if client:supports_method('textDocument/inlayHint', event.buf) then
      lsp_map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
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

    -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
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
