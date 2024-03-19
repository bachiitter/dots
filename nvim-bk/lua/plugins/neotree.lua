vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]
vim.keymap.set("n", "<leader>nt", "<cmd>:Neotree toggle<CR>", {})

return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup {
      filesystem = {
        filtered_items = {
          visible = true,
        },
      },
      window = {
        position = "right",
      },
    }
  end,
}
