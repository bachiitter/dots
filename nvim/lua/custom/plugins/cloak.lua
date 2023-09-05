return {
  'laytan/cloak.nvim',
  version = '*',
  config = function()
    require('cloak').setup {
      enabled = true,
      cloak_character = '*',
      highlight_group = 'Comment',
      patterns = {
        {
          file_pattern = {
            '.env*',
            '.dev.vars',
          },
          cloak_pattern = '=.+',
        },
      },
    }
  end,
}
