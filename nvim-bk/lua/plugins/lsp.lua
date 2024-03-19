return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = {
          "lua_ls",
          "tsserver",
          "gopls",
          "tailwindcss",
        },
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        tag = "legacy",
        opts = {
          window = {
            blend = 0,
          },
        },
      },
      {
        "folke/neodev.nvim",
        config = function()
          require("neodev").setup {}
        end,
      },
    },
    config = function()
      local lspconfig = require "lspconfig"
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local on_attach = function(_, bufnr)
        local opts = { buffer = bufnr, remap = false }

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "e", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "D", vim.lsp.buf.type_definition, opts)
      end

      lspconfig.lua_ls.setup {
        Lua = {
          telemetry = { enable = false },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            -- make language server aware of runtime files
            library = {
              [vim.fn.expand "$VIMRUNTIME/lua"] = true,
              [vim.fn.stdpath "config" .. "/lua"] = true,
            },
          },
        },
        capabilities = capabilities,
        on_attach = on_attach,
      }

      lspconfig.tailwindcss.setup {
        capabilities = capabilities,
        on_attach = on_attach,
      }

      lspconfig.gopls.setup {
        capabilities = capabilities,
        on_attach = on_attach,
      }

      lspconfig.jsonls.setup {
        schemas = require("schemastore").json.schemas(),
        format = {
          enable = true,
        },
        validate = { enable = true },
        capabilities = capabilities,
        on_attach = on_attach,
      }

      lspconfig.tsserver.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        init_options = {
          preferences = {
            disableSuggestions = true,
          },
        },
      }
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    config = function()
      local null_ls = require "null-ls"
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

      null_ls.setup {
        sources = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.prettierd,
          null_ls.builtins.diagnostics.eslint,
          null_ls.builtins.code_actions.eslint,
          null_ls.builtins.formatting.gofumpt,
          null_ls.builtins.formatting.goimports,
        },
        on_attach = function(client, bufnr)
          if client.name == "tsserver" then
            client.resolved_capabilities.document_formatting = false
          end
          if client.supports_method "textDocument/formatting" then
            vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
            vim.api.nvim_create_autocmd("BufWritePre", {
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
  },
}
