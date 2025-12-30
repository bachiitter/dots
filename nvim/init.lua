--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------
vim.g.mapleader = ' '
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.have_nerd_font = true

local o = vim.o
o.termguicolors = true
o.number = true
o.relativenumber = true
o.mouse = ''
o.breakindent = true
o.showmode = false
o.cmdheight = 1
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
o.hlsearch = true
o.expandtab = true
o.tabstop = 2
o.softtabstop = 2
o.shiftwidth = 2

vim.opt.clipboard = 'unnamedplus'
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.fillchars = { eob = ' ' }
vim.opt.title = true
vim.opt.winborder = 'single'

--------------------------------------------------------------------------------
-- Keymaps
--------------------------------------------------------------------------------
local map = vim.keymap.set

-- General
map('n', '<Esc>', '<cmd>nohlsearch<CR>') -- Clear search highlight
map('n', '<leader>e', function() vim.diagnostic.open_float { scope = 'line' } end, { desc = 'Diagnostic float' }) -- Show line diagnostics
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostic quickfix' }) -- Send diagnostics to quickfix

-- Better movement on wrapped lines
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Paste without yanking selection
map('v', 'p', '"_dP', { silent = true })

-- Window navigation
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Focus left' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Focus right' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Focus down' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Focus up' })

--------------------------------------------------------------------------------
-- Autocmds
--------------------------------------------------------------------------------
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd('BufEnter', { command = 'set formatoptions-=cro' }) -- Disable auto-comment on new line

autocmd('TextYankPost', {
  group = augroup('highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end, -- Highlight yanked text
})

autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.txt', '*.md', '*.tex' },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = 'en'
  end,
})

--------------------------------------------------------------------------------
-- Diagnostics
--------------------------------------------------------------------------------
vim.diagnostic.config {
  virtual_text = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
      [vim.diagnostic.severity.WARN] = 'WarningMsg',
    },
  },
}

--------------------------------------------------------------------------------
-- LSP
--------------------------------------------------------------------------------
vim.lsp.enable { 'astro', 'biome', 'cssls', 'emmet_ls', 'gopls', 'jsonls', 'lua_ls', 'tailwindcss', 'vtsls' }

autocmd('LspAttach', {
  group = augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local function lsp_map(keys, func, desc, mode)
      map(mode or 'n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- Navigation
    lsp_map('gd', function() Snacks.picker.lsp_definitions() end, 'Goto Definition')
    lsp_map('gr', function() Snacks.picker.lsp_references() end, 'Goto References')
    lsp_map('gi', function() Snacks.picker.lsp_implementations() end, 'Goto Implementation')
    lsp_map('gD', vim.lsp.buf.declaration, 'Goto Declaration')
    lsp_map('<leader>D', function() Snacks.picker.lsp_type_definitions() end, 'Type Definition')

    -- Search symbols
    lsp_map('<leader>ds', function() Snacks.picker.lsp_symbols() end, 'Document Symbols')
    lsp_map('<leader>ws', function() Snacks.picker.lsp_workspace_symbols() end, 'Workspace Symbols')

    -- Actions
    lsp_map('<leader>rn', vim.lsp.buf.rename, 'Rename')
    lsp_map('<leader>ca', function()
      vim.lsp.buf.code_action { filter = function(a) return a.disabled == nil end }
    end, 'Code Action', { 'n', 'v' })

    -- Help
    lsp_map('<C-s>', vim.lsp.buf.signature_help, 'Signature Help')

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then return end

    -- Highlight references under cursor
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

    -- Inlay hints toggle
    if client:supports_method('textDocument/inlayHint', event.buf) then
      lsp_map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, 'Toggle Inlay Hints')
    end
  end,
})

--------------------------------------------------------------------------------
-- Plugins
--------------------------------------------------------------------------------
vim.pack.add {
  { src = 'https://github.com/bachiitter/orng.nvim' },
  { src = 'https://github.com/folke/snacks.nvim' },
  { src = 'https://github.com/folke/which-key.nvim' },
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/nvim-mini/mini.nvim' },
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },
  { src = 'https://github.com/saghen/blink.cmp' },
  { src = 'https://github.com/stevearc/conform.nvim' },
  { src = 'https://github.com/stevearc/oil.nvim' },
  { src = 'https://github.com/windwp/nvim-ts-autotag' },
}

-- Colorscheme
require('orng').setup { style = 'dark', transparent = true }

-- Treesitter
require('nvim-treesitter').setup {
  ensure_installed = {
    'astro', 'bash', 'css', 'go', 'gomod', 'gosum', 'gowork', 'html',
    'javascript', 'json', 'lua', 'luadoc', 'markdown', 'tsx', 'typescript', 'vim', 'vimdoc',
  },
  auto_install = true,
}
require('treesitter-context').setup { max_lines = 1 }
require('nvim-ts-autotag').setup {}

-- Mini
require('mini.ai').setup { n_lines = 500 }
require('mini.surround').setup()
require('mini.pairs').setup()
require('mini.comment').setup()
require('mini.statusline').setup()

-- Gitsigns
require('gitsigns').setup {
  signs = { add = { text = '+' }, change = { text = '~' }, delete = { text = '_' }, topdelete = { text = '‾' }, changedelete = { text = '~' } },
  current_line_blame = true,
  current_line_blame_opts = { delay = 500 },
  current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
}

-- Which-key
require('which-key').setup {
  delay = 0,
  spec = {
    { '<leader>c', group = 'Code', mode = { 'n', 'x' } },
    { '<leader>d', group = 'Document' },
    { '<leader>r', group = 'Rename' },
    { '<leader>s', group = 'Search' },
    { '<leader>w', group = 'Workspace' },
    { '<leader>t', group = 'Toggle' },
  },
}

-- Snacks (fuzzy finder, input, terminal)
require('snacks').setup { input = {}, picker = {}, terminal = {} }

map('n', '<leader>sf', function() Snacks.picker.git_files() end, { desc = 'Search Files (git)' })
map('n', '<leader>sa', function() Snacks.picker.files() end, { desc = 'Search All Files' })
map('n', '<leader>sg', function() Snacks.picker.grep() end, { desc = 'Search Grep' })
map('n', '<leader>sw', function() Snacks.picker.grep_word() end, { desc = 'Search Word' })
map('n', '<leader>sd', function() Snacks.picker.diagnostics() end, { desc = 'Search Diagnostics' })
map('n', '<leader>sr', function() Snacks.picker.resume() end, { desc = 'Search Resume' })
map('n', '<leader><leader>', function() Snacks.picker.buffers() end, { desc = 'Buffers' })

-- Conform (formatting)
require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    if vim.tbl_contains({ 'c', 'cpp' }, vim.bo[bufnr].filetype) then return nil end
    return { timeout_ms = 500, lsp_format = 'never' }
  end,
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

map({ 'n', 'v' }, '<leader>f', function()
  require('conform').format { async = true, lsp_format = 'never', stop_after_first = true }
end, { desc = 'Format buffer' })

-- Oil (file explorer)
function _G.OilBar()
  return '  ' .. vim.fn.fnamemodify(vim.fn.expand('%'):gsub('oil://', ''), ':.')
end

require('oil').setup {
  columns = { 'icon' },
  keymaps = { ['<C-h>'] = false, ['<C-l>'] = false, ['<C-k>'] = false, ['<C-j>'] = false, ['<M-h>'] = 'actions.select_split', ['<C-r>'] = 'actions.refresh' },
  win_options = { winbar = '%{v:lua.OilBar()}' },
  view_options = { show_hidden = true },
}

map('n', '<leader>-', require('oil').toggle_float, { desc = 'Oil' })

-- Blink.cmp (completion)
require('blink.cmp').setup {
  keymap = {
    ['<C-p>'] = { 'select_prev', 'fallback' },
    ['<C-n>'] = { 'select_next', 'fallback' },
    ['<C-c>'] = { 'cancel', 'fallback' },
    ['<CR>'] = { 'select_and_accept', 'fallback' },
    ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
    ['<C-Space>'] = { 'show', 'fallback' },
    ['<Tab>'] = { function(cmp) return cmp.snippet_active() and cmp.snippet_forward() or cmp.select_next() end, 'fallback' },
    ['<S-Tab>'] = { function(cmp) return cmp.snippet_active() and cmp.snippet_backward() or cmp.select_prev() end, 'fallback' },
  },
  appearance = { use_nvim_cmp_as_default = false, nerd_font_variant = 'mono' },
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
