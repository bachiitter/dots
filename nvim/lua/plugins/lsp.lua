return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'mason-org/mason.nvim',
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'saghen/blink.cmp',
    -- JSON schemas
    'b0o/schemastore.nvim',
  },
  config = function()
    vim.diagnostic.config {
      virtual_text = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        border = 'rounded',
        source = true,
        header = '',
        prefix = '',
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
        numhl = {
          [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
          [vim.diagnostic.severity.WARN] = 'WarningMsg',
        },
      },
    }

    -- local capabilities = require('blink.cmp').get_lsp_capabilities()

    local servers = {
      astro = {},
      biome = {},
      cssls = {},
      gopls = {
        settings = {
          gopls = {
            gofumpt = true,
            hints = {
              assignVariableTypes = false,
              compositeLiteralFields = false,
              compositeLiteralTypes = false,
              constantValues = false,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = false,
            },
          },
        },
      },
      jsonls = {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = false },
          },
        },
      },
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            -- disable noisy `missing-fields` warnings
            diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
      tailwindcss = {
        settings = {
          editor = {
            quickSuggestions = { strings = true },
            autoClosingQuotes = 'always',
          },
          tailwindCSS = {
            classFunctions = { 'cva', 'cx' },
            lint = {
              invalidApply = false,
            },
          },
        },
      },
      tsgo = {
        cmd = { 'tsgo', '--lsp', '--stdio' },
        filetypes = {
          'javascript',
          'javascriptreact',
          'javascript.jsx',
          'typescript',
          'typescriptreact',
          'typescript.tsx',
        },
        root_markers = {
          'tsconfig.json',
          'jsconfig.json',
          'package.json',
          '.git',
          'tsconfig.base.json',
        },
      },
      -- vtsls = {
      --   settings = {
      --     complete_function_calls = true,
      --     vtsls = {
      --       autoUseWorkspaceTsdk = true,
      --     },
      --     typescript = {
      --       updateImportsOnFileMove = { enabled = 'always' },
      --       suggest = {
      --         completeFunctionCalls = true,
      --       },
      --       preferences = {
      --         importModuleSpecifier = 'shortest',
      --         importModuleSpecifierEnding = 'minimal',
      --         includePackageJsonAutoImports = 'on',
      --       },
      --       inlayHints = {
      --         parameterNames = { enabled = 'literals' },
      --         parameterTypes = { enabled = true },
      --         variableTypes = { enabled = false },
      --         propertyDeclarationTypes = { enabled = true },
      --         functionLikeReturnTypes = { enabled = true },
      --         enumMemberValues = { enabled = true },
      --       },
      --     },
      --     javascript = {
      --       updateImportsOnFileMove = { enabled = 'always' },
      --       preferences = {
      --         importModuleSpecifier = 'shortest',
      --         importModuleSpecifierEnding = 'minimal',
      --         includePackageJsonAutoImports = 'on',
      --       },
      --     },
      --   },
      --     },
    }

    -- Now setup those configurations
    for name, config in pairs(servers) do
      -- config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, config.capabilities or {})
      vim.lsp.enable(name)
      vim.lsp.config(name, config)
    end

    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua',
    })

    require('mason').setup()
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      ensure_installed = {},
      automatic_installation = false,
    }
  end,
}
