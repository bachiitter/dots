vim.pack.add {
  'https://github.com/saghen/blink.cmp',
  'https://github.com/saghen/blink.lib',
}

local cmp = require 'blink.cmp'
cmp.build():wait(60000)
cmp.setup {
  appearance = { use_nvim_cmp_as_default = false, nerd_font_variant = 'normal' },
  snippets = { preset = 'default' },
  sources = {
    default = { 'lsp', 'path', 'buffer', 'snippets' },
  },
  signature = {
    enabled = true,
    trigger = { show_on_trigger_character = false },
    window = { border = 'rounded', show_documentation = true },
  },
  cmdline = {
    enabled = false,
    completion = { menu = { auto_show = true } },
    keymap = {
      ['<CR>'] = { 'accept_and_enter', 'fallback' },
    },
  },
  completion = {
    trigger = { show_on_trigger_character = true },
    menu = {
      border = 'rounded',
      auto_show = true,
      scrolloff = 1,
      scrollbar = false,
      draw = {
        padding = 1,
        gap = 1,
        columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'kind' }, { 'source_name' } },
      },
    },
    documentation = { auto_show = true, window = { border = 'rounded' } },
    ghost_text = { enabled = true },
    list = { selection = { preselect = true } },
  },
  fuzzy = { implementation = 'prefer_rust_with_warning' },
}
