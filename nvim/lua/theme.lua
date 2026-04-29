vim.pack.add { 'https://github.com/bachiitter/orng.nvim' }

-- Colorscheme (immediate)
require('orng').setup {
  transparent = true, -- Enable transparent background
}

vim.cmd.colorscheme 'orng'
