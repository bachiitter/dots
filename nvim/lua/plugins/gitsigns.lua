vim.pack.add {
  'https://github.com/lewis6991/gitsigns.nvim',
}

require('gitsigns').setup {
  signs = { add = { text = '+' }, change = { text = '~' }, delete = { text = '_' }, topdelete = { text = '‾' }, changedelete = { text = '~' } },
  current_line_blame = true,
  current_line_blame_opts = { delay = 500 },
  current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
}
