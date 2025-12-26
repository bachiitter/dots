return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate astro bash css go html javascript json lua markdown tsx typescript',
    branch = 'main',
    config = function()
      local parsers = { 'astro', 'bash', 'css', 'go', 'html', 'javascript', 'json', 'lua', 'markdown', 'tsx', 'typescript' }

      vim.api.nvim_create_autocmd('FileType', {
        pattern = parsers,
        callback = function()
          vim.treesitter.start()
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      max_lines = 1,
    },
  },
}
