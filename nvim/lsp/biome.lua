return {
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  cmd = function(dispatchers, config)
    local cmd = 'biome'
    local root = (config or {}).root_dir
    if root then
      local local_cmd = root .. '/node_modules/.bin/biome'
      if vim.uv.fs_stat(local_cmd) then
        cmd = local_cmd
      end
    end
    return vim.lsp.rpc.start({ cmd, 'lsp-proxy' }, dispatchers)
  end,
  filetypes = {
    'astro',
    'css',
    'graphql',
    'javascript',
    'javascriptreact',
    'json',
    'jsonc',
    'svelte',
    'typescript',
    'typescript.tsx',
    'typescriptreact',
    'vue',
  },
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    if vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc' }) then
      return
    end

    local biome_root = vim.fs.root(bufnr, { 'biome.json', 'biome.jsonc' })
    if not biome_root then
      return
    end

    on_dir(biome_root)
  end,
}
