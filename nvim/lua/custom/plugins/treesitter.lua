return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  main = 'nvim-treesitter.configs',
  opts = {
    ensure_installed = {
      'astro',
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
  config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)
    vim.treesitter.language.register('markdown', 'mdx')
  end,
}
