return {
  "stevearc/oil.nvim",
  opts = {
    default_file_explorer = true,
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,

    view_options = {
      show_hidden = true,
    },
    keymaps = {
      ["q"] = { "actions.close", mode = "n" },
      ["H"] = { "actions.parent", mode = "n" }, -- Shift + H goes up to parent directory
      ["L"] = { "actions.select", mode = "n" }, -- Shift + L opens file or child directory
    },
    float = {
      max_width = 0.8,
      max_height = 0.8,
      border = "rounded",
    },
  },

  keys = {
    {
      "-",
      "<CMD>Oil --float<CR>",
      desc = "Open Oil",
    },
    {
      "<leader>on",
      function()
        require("oil").open_float(vim.fn.stdpath("config"))
      end,
      desc = "Oil Open Nvim Config",
    },
  },
}
