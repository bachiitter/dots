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
            'wrangler.toml',
            '.dev.vars',
          },
          cloak_pattern = '=.+',
        },
        {
          file_pattern = '**/*.opencode.json',
          cloak_pattern = '("apiKey":) .+',
          replace = '%1 ',
        },
        {
          file_pattern = '**/config.toml',
          cloak_pattern = '(token =) .+',
          replace = '%1 ',
        },
      },
    }
  end,
}
