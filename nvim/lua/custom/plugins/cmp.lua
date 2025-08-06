return {
  'saghen/blink.cmp',
  event = 'VimEnter',
  version = '1.*',
  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      version = '2.*',
      build = (function()
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      dependencies = {},
      opts = {},
    },
    'folke/lazydev.nvim',
  },
  --- @module 'blink.cmp'
  --- @type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'enter',
    },
    appearance = {
      nerd_font_variant = 'mono',
    },
    accept = {
      auto_brackets = {
        enabled = true,
      },
    },
    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 250,
        treesitter_highlighting = true,
        window = {
          border = 'none',
        },
      },
      menu = {
        border = 'none',
        -- Equivalent to 'menuone,noinsert'
        auto_show = true,
        draw = {
          columns = { { 'label', 'label_description', gap = 1 }, { 'kind_icon', 'kind', gap = 1 } },
        },
      },
      ghost_text = {
        enabled = true,
      },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'lazydev' },
      providers = {
        lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
      },
    },
    snippets = { preset = 'luasnip' },
    fuzzy = { implementation = 'lua' },
    signature = {
      enabled = false,
      window = {
        show_documentation = false,
      },
    },
  },
}
