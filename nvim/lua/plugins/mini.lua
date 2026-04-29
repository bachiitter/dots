vim.pack.add { 'https://github.com/nvim-mini/mini.nvim' }

-- Mini (immediate - lightweight)
require('mini.pairs').setup {
  modes = { command = true },
}
require('mini.statusline').setup()
require('mini.icons').setup()
