return {
  'folke/trouble.nvim',
  cmd = 'Trouble',
  keys = {
    { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
    { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
    { '<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols (Trouble)' },
    { '<leader>xl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP Definitions / References (Trouble)' },
    { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
    { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
    { '[d', function() require('trouble').prev { skip_groups = true, jump = true } end, desc = 'Previous Diagnostic' },
    { ']d', function() require('trouble').next { skip_groups = true, jump = true } end, desc = 'Next Diagnostic' },
  },
  opts = {
    focus = true,
    auto_close = true,
    auto_preview = true,
    modes = {
      symbols = {
        win = { position = 'right', size = 0.3 },
      },
    },
  },
}
