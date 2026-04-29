vim.pack.add { 'https://github.com/folke/snacks.nvim' }

-- Snacks (immediate - needed for keybinds)
local Snacks = require 'snacks'

-- Guard against double-setup when re-sourcing init.lua
if not vim.g.snacks_setup_done then
  Snacks.setup {
    input = { enabled = true },
    picker = {
      enabled = true,
      previewers = {
        diff = { style = 'fancy' },
      },
      layout = {
        -- preset = 'sidebar', -- or "ivy", "vertical", "sidebar", "vscode", etc.
      },
    },
  }
  vim.g.snacks_setup_done = true
end

-- Search (Snacks picker)
vim.keymap.set('n', '<leader>sf', function()
  Snacks.picker.git_files()
end, { desc = 'Search Files (git)' })
vim.keymap.set('n', '<leader>sa', function()
  Snacks.picker.files()
end, { desc = 'Search All Files' })
vim.keymap.set('n', '<leader>sg', function()
  Snacks.picker.grep()
end, { desc = 'Search Grep' })
vim.keymap.set('n', '<leader>sd', function()
  Snacks.picker.diagnostics()
end, { desc = 'Search Diagnostics' })
vim.keymap.set('n', '<leader><leader>', function()
  Snacks.picker.buffers()
end, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>sp', function()
  Snacks.picker.projects()
end, { desc = 'Search Projects' })
vim.keymap.set('n', '<leader>s/', function()
  Snacks.picker.lines()
end, { desc = 'Search Projects' })
