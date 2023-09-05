return {
  'nvim-tree/nvim-web-devicons',
  config = function()
    local devicons = require 'nvim-web-devicons'

    devicons.setup {
      color_icons = false,
    }
  end,
}
