return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup {
      options = {
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { { 'branch', icons_enabled = false }, 'diagnostics' },
        lualine_c = {
          { 'filename', path = 1 },
        },
        lualine_x = { 'filetype' },
        lualine_y = { 'progress', 'encoding', 'fileformat' },
        lualine_z = { 'location' },
      },
    }
  end,
}
