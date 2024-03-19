return {
  'nvimtools/none-ls.nvim',
  config = function()
    local null_ls = require 'null-ls'
    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

    null_ls.setup {
      sources = {
        null_ls.builtins.formatting.stylua,
        --     null_ls.builtins.formatting.prettierd,
        --   null_ls.builtins.diagnostics.eslint,
        --   null_ls.builtins.code_actions.eslint,
        null_ls.builtins.formatting.gofumpt,
        null_ls.builtins.formatting.goimports,
      },
      on_attach = function(client, bufnr)
        if client.name == 'tsserver' then
          client.resolved_capabilities.document_formatting = false
        end
        if client.supports_method 'textDocument/formatting' then
          vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format { async = false, { timeout_ms = 2000 } }
            end,
          })
        end
      end,
    }
  end,
}

