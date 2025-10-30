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
    'isak102/telescope-git-file-history.nvim',
  },
  config = function()
    require('telescope').setup {
      pickers = {
        find_files = {
          theme = 'ivy',
          hidden = true,
        },
        git_files = {
          hidden = true,
        },
      },
      defaults = {
        file_ignore_patterns = {
          'node_modules/*',
        },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
        fzf = {},
      },
    }

    pcall(require('telescope').load_extension 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
    pcall(require('telescope').load_extension, 'git_file_history')

    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>sf', builtin.git_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sa', builtin.find_files, { desc = '[S]earch [A]ll Files' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })

    vim.keymap.set('n', '<leader>/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })
  end,
}
