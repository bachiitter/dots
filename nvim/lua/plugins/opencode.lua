return {
  'NickvanDyke/opencode.nvim',
  dependencies = {
    {
      'folke/snacks.nvim',
      opts = {
        input = {},
        picker = {},
        terminal = {},
        explorer = {
          win = {
            position = 'right',
          },
        },
      },
      keys = {
        { '<leader>sf', function() Snacks.picker.git_files() end, desc = '[S]earch [F]iles (git)' },
        { '<leader>sa', function() Snacks.picker.files() end, desc = '[S]earch [A]ll Files' },
        { '<leader>sg', function() Snacks.picker.grep() end, desc = '[S]earch by [G]rep' },
        { '<leader>sw', function() Snacks.picker.grep_word() end, desc = '[S]earch [W]ord' },
        { '<leader>sd', function() Snacks.picker.diagnostics() end, desc = '[S]earch [D]iagnostics' },
        { '<leader>sr', function() Snacks.picker.resume() end, desc = '[S]earch [R]esume' },
        { '<leader><leader>', function() Snacks.picker.buffers() end, desc = 'Buffers' },
        { '<leader>-', function() Snacks.explorer() end, desc = 'File Explorer' },
      },
    },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {}

    vim.o.autoread = true

    vim.keymap.set({ 'n', 'x' }, '<C-a>', function()
      require('opencode').ask('@this: ', { submit = true })
    end, { desc = 'Ask opencode' })
    vim.keymap.set({ 'n', 'x' }, '<C-x>', function()
      require('opencode').select()
    end, { desc = 'Execute opencode action…' })
    vim.keymap.set({ 'n', 'x' }, 'ga', function()
      require('opencode').prompt '@this'
    end, { desc = 'Add to opencode' })
    vim.keymap.set({ 'n', 't' }, '<C-.>', function()
      require('opencode').toggle()
    end, { desc = 'Toggle opencode' })
    vim.keymap.set('n', '<S-C-u>', function()
      require('opencode').command 'session.half.page.up'
    end, { desc = 'opencode half page up' })
    vim.keymap.set('n', '<S-C-d>', function()
      require('opencode').command 'session.half.page.down'
    end, { desc = 'opencode half page down' })
    vim.keymap.set('n', '+', '<C-a>', { desc = 'Increment', noremap = true })
    vim.keymap.set('n', '-', '<C-x>', { desc = 'Decrement', noremap = true })
  end,
}
