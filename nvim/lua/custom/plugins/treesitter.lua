return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    'nvim-treesitter/nvim-treesitter-context',
  },
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup {
      ensure_installed = {
        'astro',
        'css',
        'go',
        'html',
        'javascript',
        'json',
        'lua',
        'python',
        'tsx',
        'typescript',
      },

      auto_install = true,
      sync_install = false,
      highlight = { enable = true, additional_vim_regex_highlighting = false },
      indent = { enable = true },
    }
  end,
}
