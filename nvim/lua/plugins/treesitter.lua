return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').install { 'astro', 'bash', 'css', 'go', 'gomod', 'gosum', 'gowork', 'html', 'javascript', 'json', 'lua', 'markdown', 'tsx', 'typescript' }
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      max_lines = 1,
    },
  },
}
