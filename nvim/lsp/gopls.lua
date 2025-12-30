return {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl', 'gosum' },
  root_markers = { 'go.mod', 'go.work', '.git' },
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
