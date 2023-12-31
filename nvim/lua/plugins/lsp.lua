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
          require("neodev").setup()
        end,
      },
    },
    config = function()
      local lspconfig = require "lspconfig"
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.keymap.set("n", "gd", vim.lsp.buf.definition)
      vim.keymap.set("n", "K", vim.lsp.buf.hover)
      vim.keymap.set("n", "ca", vim.lsp.buf.code_action)
      vim.keymap.set("n", "gI", vim.lsp.buf.implementation)
      vim.keymap.set("n", "D", vim.lsp.buf.type_definition)

      lspconfig.lua_ls.setup {
        capabilities = capabilities,
      }

      lspconfig.tailwindcss.setup {
        capabilities = capabilities,
      }

      lspconfig.gopls.setup {
        capabilities = capabilities,
      }

      lspconfig.jsonls.setup {
        json = {
          schemas = require("schemastore").json.schemas(),
          format = {
            enable = true,
          },
          validate = { enable = true },
          capabilities = capabilities,
        },
      }

      lspconfig.tsserver.setup {
        capabilities = capabilities,
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
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.diagnostics.eslint_d,
          null_ls.builtins.code_actions.eslint_d,
          null_ls.builtins.formatting.gofumpt,
          null_ls.builtins.formatting.goimports,
        },
        on_attach = function(client, bufnr)
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
