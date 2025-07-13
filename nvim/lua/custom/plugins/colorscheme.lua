return {
  -- {
  --   'ellisonleao/gruvbox.nvim',
  --   priority = 1000, -- Make sure to load this before all the other start plugins.
  --   config = function()
  --     ---@diagnostic disable-next-line: missing-fields
  --     require('gruvbox').setup {
  --       contrast = 'soft',
  --       dim_inactive = true,
  --       --       transparent_mode = true,
  --     }
  --     vim.cmd.colorscheme 'gruvbox'
  --     vim.o.background = 'dark'

  --     -- vim.cmd([[
  --     --     highlight SignColumn guibg=NONE ctermbg=NONE
  --     --     highlight DiagnosticSignError guibg=NONE ctermbg=NONE
  --     --     highlight DiagnosticSignWarn guibg=NONE ctermbg=NONE
  --     --     highlight DiagnosticSignInfo guibg=NONE ctermbg=NONE
  --     --     highlight DiagnosticSignHint guibg=NONE ctermbg=NONE
  --     --
  --     --     " For git signs if you're using gitsigns.nvim or similar
  --     --     highlight GitSignsAdd guibg=NONE ctermbg=NONE
  --     --     highlight GitSignsChange guibg=NONE ctermbg=NONE
  --     --     highlight GitSignsDelete guibg=NONE ctermbg=NONE
  --     --
  --     --     " For older LSP diagnostic signs (pre Neovim 0.7)
  --     --     highlight LspDiagnosticsSignError guibg=NONE ctermbg=NONE
  --     --     highlight LspDiagnosticsSignWarning guibg=NONE ctermbg=NONE
  --     --     highlight LspDiagnosticsSignInformation guibg=NONE ctermbg=NONE
  --     --     highlight LspDiagnosticsSignHint guibg=NONE ctermbg=NONE
  --     --  ]])
  --     vim.cmd [[
  --         highlight Normal guibg=none
  --         highlight Normal ctermbg=none
  --       ]]
  --   end,
  -- },
  -- {
  --   'jasonlong/poimandres.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   opts = {
  --     transparent = true,
  --     style = "storm"
  --   },
  --   init = function()
  --     vim.cmd 'colorscheme poimandres'
  --   end,
  -- },
  {
    'stevedylandev/darkmatter-nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd 'colorscheme darkmatter'
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
