return {
  'folke/trouble.nvim',
  opts = {
  },
  cmd = { 'Trouble' },
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",          desc = "Diagnostics (Trouble)" },
    { '<leader>xX', '<cmd>TroubleToggle workspace_diagnostics<cr>', desc = 'Workspace Diagnostics (Trouble)' },
    { '<leader>xL', '<cmd>TroubleToggle loclist<cr>',               desc = 'Location List (Trouble)' },
    { '<leader>xQ', '<cmd>TroubleToggle quickfix<cr>',              desc = 'Quickfix List (Trouble)' },
  },
}
