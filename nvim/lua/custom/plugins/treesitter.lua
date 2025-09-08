return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  main = 'nvim-treesitter.configs',
  opts = {
    ensure_installed = {
      'astro',
      'bash',
      'css',
      'go',
      'html',
      'javascript',
      'json',
      'lua',
      'tsx',
      'typescript',
    },
    highlight = {
      enable = true,
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      max_lines = 1,
    },
  },
}
