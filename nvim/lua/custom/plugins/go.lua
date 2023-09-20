return {
  'ray-x/go.nvim',
  config = function()
    require('go').setup {
      trouble = true,
      luasnip = true,
      lsp_inlay_hints = {
        enable = true,
      },
    }
  end,
  event = { 'CmdlineEnter' },
  ft = { 'go', 'gomod' },
  build = ':lua require("go.install").update_all_sync()',
}
