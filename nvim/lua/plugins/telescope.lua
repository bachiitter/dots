return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    local actions = require 'telescope.actions'

    require('telescope').setup {
      defaults = {
        layout_strategy = 'horizontal',
        layout_config = {
          horizontal = {
            prompt_position = 'top',
            preview_width = 0.5,
          },
          width = 0.9,
          height = 0.85,
        },
        sorting_strategy = 'ascending',
        prompt_prefix = '   ',
        selection_caret = '  ',
        path_display = { 'truncate' },
        file_ignore_patterns = { 'node_modules/', '.git/', 'dist/', 'build/', '.next/' },
        mappings = {
          i = {
            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,
            ['<C-c>'] = actions.close,
          },
          n = {
            ['q'] = actions.close,
          },
        },
      },
      pickers = {
        find_files = { hidden = true },
        git_files = { hidden = true, show_untracked = true },
        buffers = {
          sort_mru = true,
          mappings = {
            i = { ['<C-x>'] = actions.delete_buffer },
          },
        },
        live_grep = {
          additional_args = function()
            return { '--hidden', '--glob', '!.git/' }
          end,
        },
      },
      extensions = {
        ['ui-select'] = { require('telescope.themes').get_dropdown() },
        fzf = { fuzzy = true, case_mode = 'smart_case' },
      },
    }

    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>sf', builtin.git_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sa', builtin.find_files, { desc = '[S]earch [A]ll Files' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch [W]ord' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Buffers' })
  end,
}
