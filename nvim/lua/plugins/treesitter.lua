vim.pack.add { { src = 'https://github.com/nvim-treesitter/nvim-treesitter', branch = 'main' } }

require('nvim-treesitter').install {
  'astro',
  'bash',
  'css',
  'go',
  'gomod',
  'gosum',
  'gowork',
  'html',
  'javascript',
  'json',
  'lua',
  'luadoc',
  'markdown',
  'toml',
  'tsx',
  'typescript',
  'yaml',
}

-- Run TSUpdate if Treesitter is updated
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'nvim-treesitter' and kind == 'update' then
      if not ev.data.active then
        vim.cmd.packadd 'nvim-treesitter'
      end
      vim.cmd 'TSUpdate'
    end
  end,
})

-- Enable Treesitter
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local buf, filetype = args.buf, args.match

    local language = vim.treesitter.language.get_lang(filetype)
    if not language then
      return
    end

    -- check if parser exists and load it
    if not vim.treesitter.language.add(language) then
      return
    end
    -- enables syntax highlighting and other treesitter features
    vim.treesitter.start(buf, language)

    vim.opt.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
