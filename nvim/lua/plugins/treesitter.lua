return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'astro', 'bash', 'css', 'go', 'gomod', 'gosum', 'gowork', 'html', 'javascript', 'json', 'lua', 'luadoc', 'markdown', 'tsx', 'typescript', 'vim', 'vimdoc' },
      auto_install = true,
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      max_lines = 1,
    },
  },
  {
    'windwp/nvim-ts-autotag',
    opts = {},
  },
}
