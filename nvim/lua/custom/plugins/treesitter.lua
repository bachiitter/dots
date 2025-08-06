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
    auto_install = true,
    highlight = {
      enable = true,
    },
    indent = { enable = true },
  },
}
