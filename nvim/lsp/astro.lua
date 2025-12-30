return {
  cmd = { 'astro-ls', '--stdio' },
  filetypes = { 'astro' },
  root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
  init_options = {
    typescript = {},
  },
  before_init = function(_, config)
    if not config.init_options then
      config.init_options = {}
    end
    if not config.init_options.typescript then
      config.init_options.typescript = {}
    end
    if not config.init_options.typescript.tsdk then
      -- Find typescript lib path from node_modules
      local ts_path = vim.fs.find('node_modules/typescript/lib', {
        path = config.root_dir,
        upward = true,
        type = 'directory',
      })[1]
      if ts_path then
        config.init_options.typescript.tsdk = ts_path
      end
    end
  end,
}
