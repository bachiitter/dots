return {
  {
    'jasonlong/poimandres.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      style = 'storm',
    },
    init = function()
      vim.cmd 'colorscheme poimandres'
    end,
  },
  -- {
  --   'datsfilipe/vesper.nvim',
  --   config = function()
  --     require('vesper').setup {
  --       transparent = true
  --     }
  --   end,
  --   init = function()
  --     vim.cmd 'colorscheme vesper'
  --   end,
  -- }
}
