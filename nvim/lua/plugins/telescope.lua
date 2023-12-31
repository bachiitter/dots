return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable "make" == 1
      end,
    },
  },
  config = function()
    pcall(require("telescope").load_extension, "fzf")

    local builtin = require "telescope.builtin"

    vim.keymap.set("n", "<leader><space>", builtin.buffers)
    vim.keymap.set("n", "<leader>gf", builtin.git_files)
    vim.keymap.set("n", "<leader>sf", builtin.find_files)
    vim.keymap.set("n", "<leader>sh", builtin.help_tags)
    vim.keymap.set("n", "<leader>sw", function()
      builtin.grep_string { search = vim.fn.input "Grep > " }
    end)
    vim.keymap.set("n", "<leader>sg", builtin.live_grep)
    vim.keymap.set("n", "gr", builtin.lsp_references)
  end,
}
