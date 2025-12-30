return {
  cmd = { 'vtsls', '--stdio' },
  init_options = {
    hostInfo = 'neovim',
  },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  root_dir = function(bufnr, on_dir)
    -- Exclude deno projects
    if vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc', 'deno.lock' }) then
      return
    end

    -- Priority: lock files first, then .git
    local root_markers = {
      { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' },
      { '.git' },
    }
    local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

    on_dir(project_root)
  end,
  settings = {
    complete_function_calls = true,
    vtsls = {
      autoUseWorkspaceTsdk = true,
    },
    typescript = {
      updateImportsOnFileMove = { enabled = 'always' },
      suggest = {
        completeFunctionCalls = true,
      },
      preferences = {
        importModuleSpecifier = 'shortest',
        importModuleSpecifierEnding = 'minimal',
        includePackageJsonAutoImports = 'on',
      },
      inlayHints = {
        parameterNames = { enabled = 'literals' },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = false },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
    },
    javascript = {
      updateImportsOnFileMove = { enabled = 'always' },
      preferences = {
        importModuleSpecifier = 'shortest',
        importModuleSpecifierEnding = 'minimal',
        includePackageJsonAutoImports = 'on',
      },
    },
  },
}
