return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "none",

        ["<Tab>"] = {
          "select_next",
          "snippet_forward",
          "fallback",
        },
        ["<S-Tab>"] = {
          "select_prev",
          "snippet_backward",
          "fallback",
        },

        ["<C-j>"] = {
          "select_next",
          "fallback",
        },
        ["<C-k>"] = {
          "select_prev",
          "fallback",
        },

        ["<CR>"] = {
          "accept",
          "fallback",
        },
      },

      -- cmdline = {
      --   keymap = {
      --     preset = "none",
      --
      --     ["<Tab>"] = {
      --       "select_next",
      --       "fallback",
      --     },
      --     ["<S-Tab>"] = {
      --       "select_prev",
      --       "fallback",
      --     },
      --
      --     ["<C-j>"] = {
      --       "select_next",
      --       "fallback",
      --     },
      --     ["<C-k>"] = {
      --       "select_prev",
      --       "fallback",
      --     },
      --
      --     ["<CR>"] = {
      --       "accept",
      --       "fallback",
      --     },
      --   },
      -- },
    },
  },
}
