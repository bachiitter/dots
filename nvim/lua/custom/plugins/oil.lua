return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    CustomOilBar = function()
      local path = vim.fn.expand "%"
      path = path:gsub("oil://", "")

      return "  " .. vim.fn.fnamemodify(path, ":.")
    end

    require("oil").setup {
      columns = { "icon",
        "permissions",
        -- "size",
        -- "mtime"
      },
      keymaps = {
        ["g?"] = { "actions.show_help", mode = "n" },
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["<C-k>"] = false,
        ["<C-j>"] = false,
        ["<CR>"] = "actions.select_split",
      },
      win_options = {
        winbar = "%{v:lua.CustomOilBar()}",
      },
      view_options = {
        show_hidden = true,
      },
    }

    -- Open parent directory in current window
    -- vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

    -- Open parent directory in floating window
    vim.keymap.set("n", "<space>-", require("oil").toggle_float, { desc = "Open parent directory in floating window" })
  end,
}
