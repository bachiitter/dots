vim.pack.add { 'https://github.com/stevearc/oil.nvim' }

_G.OilBar = function()
  return '  ' .. vim.fn.fnamemodify(vim.fn.expand('%'):gsub('oil://', ''), ':.')
end

require('oil').setup {
  columns = { 'icon' },
  keymaps = { ['<C-h>'] = false, ['<C-l>'] = false, ['<C-k>'] = false, ['<C-j>'] = false, ['<M-h>'] = 'actions.select_split', ['<C-r>'] = 'actions.refresh' },
  win_options = { winbar = '%{v:lua.OilBar()}' },
  view_options = { show_hidden = true },
}

vim.keymap.set('n', '<leader>-', function()
  require('oil').toggle_float()
end, { desc = 'Oil' })
