return {
  -- {
  --   'rose-pine/neovim',
  --   name = 'rose-pine',
  --   config = function() end,
  -- },
  -- {
  --   'wtfox/jellybeans.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.cmd 'colorscheme jellybeans-mono'
  --   end,
  -- },
  -- {
  --   'stevedylandev/darkmatter-nvim',
  --   lazy = false,
  --   priority = 1000,
  -- },
  {
    'bachiitter/orng.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('orng').setup { style = 'dark', transparent = true }
    end,
  },
}
