-- Config
local config = {
  options = {
    component_separators = { left = '·' },
    section_separators = '',
    theme = 'auto',
  },

  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      'branch',
      'diff',
      {
        'diagnostics',
        sources = { 'nvim_diagnostic', 'nvim_lsp' },
        sections = { 'error', 'warn', 'info', 'hint' },
        diagnostics_color = {
          -- Same values as the general color option can be used here.
          error = 'DiagnosticError', -- Changes diagnostics' error color.
          warn = 'DiagnosticWarn',   -- Changes diagnostics' warn color.
          info = 'DiagnosticInfo',   -- Changes diagnostics' info color.
          hint = 'DiagnosticHint',   -- Changes diagnostics' hint color.
        },
        symbols = { error = 'E', warn = 'W', info = 'I', hint = 'H' },
        colored = true,           -- Displays diagnostics status in color if set to true.
        update_in_insert = false, -- Update diagnostics in insert mode.
        always_visible = false,   -- Show diagnostics even if there are none.
      },
    },
    lualine_c = { 'filename' },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = {
      'location',
    },
  },
}

return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('lualine').setup(config)
  end,
}
