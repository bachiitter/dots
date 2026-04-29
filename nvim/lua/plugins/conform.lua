vim.pack.add { 'https://github.com/stevearc/conform.nvim' }

require('conform').setup {
  notify_on_error = false,
  format_on_save = { timeout_ms = 500, lsp_format = 'never' },
  formatters_by_ft = {
    astro = { 'biome' },
    css = { 'biome' },
    go = { 'goimports', 'gofumpt' },
    html = { 'biome' },
    javascript = { 'biome' },
    json = { 'biome' },
    lua = { 'stylua' },
    typescript = { 'biome' },
    typescriptreact = { 'biome' },
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
  require('conform').format { async = true, lsp_format = 'never', stop_after_first = true }
end, { desc = 'Format buffer' })
