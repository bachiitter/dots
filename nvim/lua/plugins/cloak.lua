vim.pack.add { 'https://github.com/laytan/cloak.nvim' }

require('cloak').setup {
  enabled = true,
  cloak_character = '*',
  cloak_telescope = true,
  patterns = {
    {
      file_pattern = '**/*.vars*',
      cloak_pattern = '=.+',
    },
    {
      file_pattern = '**/*.env*',
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
