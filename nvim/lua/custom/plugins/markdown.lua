return {
  'MeanderingProgrammer/markdown.nvim',
  main = 'render-markdown',
  opts = {},
  name = 'render-markdown',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },

  config = function()
    require('render-markdown').setup {
      enable = true,
      file_types = { 'markdown', 'mdx' },
    }
  end,
}
