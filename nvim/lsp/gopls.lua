return {
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl', 'gosum' },
  settings = {
    gopls = {
      gofumpt = true,
      staticcheck = true,
      usePlaceholders = true,
      directoryFilters = { '-.git', '-.vscode', '-.idea', '-.venv', '-node_modules' },
      semanticTokens = true,
      analyses = {
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
        shadow = true,
      },
      hints = {
        functionTypeParameters = true,
        parameterNames = true,
      },
    },
  },
}
