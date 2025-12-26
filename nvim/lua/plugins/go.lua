return {
  {
    'ray-x/go.nvim',
    dependencies = {
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    ft = { 'go', 'gomod' },
    build = ':lua require("go.install").update_all_sync()',
    opts = {
      -- disable lsp setup, we handle it in lsp.lua
      lsp_cfg = false,
      lsp_keymaps = false,
      -- formatting handled by conform.nvim
      lsp_gofumpt = false,
      -- useful features
      tag_transform = 'camelcase',
      tag_options = 'json=omitempty',
      icons = false,
      diagnostic = false,
      -- test settings
      test_runner = 'go',
      run_in_floaterm = true,
      floaterm = {
        position = 'bottom',
        width = 0.9,
        height = 0.4,
      },
    },
    keys = {
      { '<leader>gt', '<cmd>GoTest<cr>', desc = '[G]o [T]est current package' },
      { '<leader>gT', '<cmd>GoTestFunc<cr>', desc = '[G]o [T]est function' },
      { '<leader>gc', '<cmd>GoCoverage<cr>', desc = '[G]o [C]overage toggle' },
      { '<leader>ga', '<cmd>GoAddTag<cr>', desc = '[G]o [A]dd struct tags' },
      { '<leader>gr', '<cmd>GoRmTag<cr>', desc = '[G]o [R]emove struct tags' },
      { '<leader>gi', '<cmd>GoImpl<cr>', desc = '[G]o [I]mplement interface' },
      { '<leader>ge', '<cmd>GoIfErr<cr>', desc = '[G]o if [E]rr snippet' },
      { '<leader>gf', '<cmd>GoFillStruct<cr>', desc = '[G]o [F]ill struct' },
    },
  },
}
