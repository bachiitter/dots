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
        lualine_b = { 'branch', 'diagnostics' },
        lualine_c = {
          { 'filename', path = 1 },
        },
        lualine_x = { 'filetype' },
        lualine_y = { 'encoding', { 'fileformat', icons_enabled = false } },
        lualine_z = { 'location' },
      },
    }
  end,
}
