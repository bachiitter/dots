vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install Lazy package manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    -- Theme
    'RRethy/nvim-base16',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'base16-grayscale-dark'
    end,
  },
  {
    -- LSP
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      {
        'j-hui/fidget.nvim',
        event = 'LspAttach',
        tag = 'legacy',
        opts = {
          window = {
            blend = 0,
          },
        },
      },
      'folke/neodev.nvim',
    },
  },

  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  { 'tpope/vim-sleuth' },
  { 'numToStr/Comment.nvim',        opts = {} },
  { 'folke/which-key.nvim',         opts = {} },

  -- Markdown preview
  { 'ellisonleao/glow.nvim',        config = true,          cmd = 'Glow' },
  { 'simrat39/symbols-outline.nvim' },
  { 'iamcco/markdown-preview.nvim', cmd = 'MarkdownPreview' },

  { 'b0o/SchemaStore.nvim' },

  { import = 'custom.plugins' },
}, {

  install = {
    missing = true,
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
  ui = {
    icons = {
      ft = '',
      lazy = '󰂠 ',
      loaded = '',
      not_loaded = '',
    },
  },

  performance = {
    rtp = {
      disabled_plugins = {
        '2html_plugin',
        'tohtml',
        'getscript',
        'getscriptPlugin',
        'gzip',
        'logipat',
        'netrw',
        'netrwPlugin',
        'netrwSettings',
        'netrwFileHandlers',
        'matchit',
        'tar',
        'tarPlugin',
        'rrhelper',
        'spellfile_plugin',
        'vimball',
        'vimballPlugin',
        'zip',
        'zipPlugin',
        'tutor',
        'rplugin',
        'syntax',
        'synmenu',
        'optwin',
        'compiler',
        'bugreport',
        'ftplugin',
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

opts.mouse = ''

opts.clipboard = 'unnamedplus'

opts.breakindent = true

opts.undofile = true
opts.swapfile = false
opts.backup = false

opts.ignorecase = true
opts.smartcase = true

opts.scrolloff = 8
opts.signcolumn = 'yes'

opts.updatetime = 250
opts.timeout = true
opts.timeoutlen = 300

opts.completeopt = 'menuone,noselect'

opts.termguicolors = true
opts.background = 'dark'

opts.cursorline = true

vim.opt.fillchars:append { eob = ' ' }

-- [[ Create autocmd ]]
local autocmd = vim.api.nvim_create_autocmd

local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

--- [[ Remove all trailing whitespace on save ]]
local TrimWhiteSpaceGrp =
    vim.api.nvim_create_augroup('TrimWhiteSpaceGrp', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
  command = [[:%s/\s\+$//e]],
  group = TrimWhiteSpaceGrp,
})

-- [[ Disable Auto Commenting ]]
vim.cmd [[au BufEnter * set fo-=c fo-=r fo-=o]]

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group =
    vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Wrap and spell check text files ]]
autocmd('FileType', {
  group = augroup 'wrap_spell',
  pattern = { 'gitcommit', 'markdown', 'norg' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- [[ Keymaps ]]

local map = vim.keymap.set

-- See `:help vim.keymap.set()`
map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Move selected line / block of text in visual mode
map('v', 'J', ":m '>+1<CR>gv=gv")
map('v', 'K', ":m '<-2<CR>gv=gv")

-- Keep cursor centered when scrolling
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')

-- Move line up/down
map('n', '<leader>j', 'ddp', {})
map('n', '<leader>k', 'ddkP', {})

-- Better paste
map('v', 'p', [["_dP]])

-- Copy line
map('n', '<leader>l', 'yyp', {})
map('n', '<leader>Y', [["+Y]])

-- New empty line
map('n', '<leader>o', 'o<Esc>', {})
map('n', '<leader>O', 'O<Esc>', {})

-- [[ Telescope ]]
require('telescope').setup {
  defaults = {
    prompt_prefix = ' ',
    selection_caret = ' ',
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

vim.keymap.set(
  'n',
  '<leader><space>',
  require('telescope.builtin').buffers,
  { desc = '[ ] Find existing buffers' }
)
vim.keymap.set(
  'n',
  '<leader>gf',
  require('telescope.builtin').git_files,
  { desc = 'Search [G]it [F]iles' }
)
vim.keymap.set(
  'n',
  '<leader>sf',
  require('telescope.builtin').find_files,
  { desc = '[S]earch [F]iles' }
)
vim.keymap.set(
  'n',
  '<leader>sh',
  require('telescope.builtin').help_tags,
  { desc = '[S]earch [H]elp' }
)
vim.keymap.set('n', '<leader>sw', function()
  require('telescope.builtin').grep_string { search = vim.fn.input 'Grep > ' }
end, { desc = '[S]earch current [W]ord' })
vim.keymap.set(
  'n',
  '<leader>sg',
  require('telescope.builtin').live_grep,
  { desc = '[S]earch by [G]rep' }
)

-- [[ LSP Config ]]

-- Diagnostic keymaps
vim.keymap.set(
  'n',
  '[d',
  vim.diagnostic.goto_prev,
  { desc = 'Go to previous diagnostic message' }
)
vim.keymap.set(
  'n',
  ']d',
  vim.diagnostic.goto_next,
  { desc = 'Go to next diagnostic message' }
)
vim.keymap.set(
  'n',
  '<leader>e',
  vim.diagnostic.open_float,
  { desc = 'Open floating diagnostic message' }
)

-- LSP
local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set(
      'n',
      keys,
      func,
      { buffer = bufnr, remap = false, desc = desc }
    )
  end

  local imap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set(
      'i',
      keys,
      func,
      { buffer = bufnr, remap = false, desc = desc }
    )
  end

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')

  imap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

local util = require 'lspconfig/util'

local cfg = require('go.lsp').config()
require('lspconfig').gopls.setup(cfg)

local servers = {
  jsonls = {
    json = {
      schemas = require('schemastore').json.schemas(),
      format = {
        enable = true,
      },
      validate = { enable = true },
    },
  },
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = {
        globals = { 'vim' },
      },
    },
  },

  gopls = {
    lsp_cfg = false,
  },
  astro = {},
  pyright = {},
  tailwindcss = {},
  tsserver = {
    init_options = {
      preferences = {
        disableSuggestions = true,
      },
    },
  },
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
  'eslint_d',
  'gofumpt',
  'prettier',
  'stylua',
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = 'if_many',
          prefix = '●',
        },
        severity_sort = true,
      },
    }
  end,
}

require('neodev').setup()
