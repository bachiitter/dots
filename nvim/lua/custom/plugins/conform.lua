return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback', stop_after_first = true }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return {
          timeout_ms = 500,
          lsp_format = 'fallback',
        }
      end
    end,
    formatters_by_ft = {
      astro = { 'biome', 'biome-organize-imports' },
      css = { 'biome', 'biome-organize-imports' },
      go = { 'goimports', 'gofumpt' },
      html = { 'biome', 'biome-organize-imports' },
      javascript = { 'biome', 'biome-organize-imports' },
      json = { 'biome', 'biome-organize-imports' },
      lua = { 'stylua' },
      typescript = { 'biome', 'biome-organize-imports' },
      typescriptreact = { 'biome', 'biome-organize-imports' },
    },
  },
}
