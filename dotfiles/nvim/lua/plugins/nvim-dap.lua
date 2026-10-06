return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<F5>", "<cmd>DapContinue<cr>", desc = "Debug: Continue" },
      { "<F9>", "<cmd>DapToggleBreakpoint<cr>", desc = "Debug: Toggle Breakpoint" },
      { "<F10>", "<cmd>DapStepOver<cr>", desc = "Debug: Step Over" },
      { "<F11>", "<cmd>DapStepInto<cr>", desc = "Debug: Step Into" },
      { "<C-F11>", "<cmd>DapStepOut<cr>", desc = "Debug: Step Out" },
      { "<S-F5>", "<cmd>DapTerminate<cr>", desc = "Debug: Terminate" },
      { "<C-F5>", "<cmd>DapContinue<cr>", desc = "Debug: Run Without Debug" },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    -- dependencies = { "nvim-neotest/nvim-nio" },
    -- stylua: ignore
    -- keys = {
    --   { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
    --   { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "x"} },
    -- },
    -- opts = {},
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      -- KTT -- leave out those events so that the UI stays open when the program finishes.
      -- dap.listeners.before.event_terminated["dapui_config"] = function()
      --   dapui.close({})
      -- end
      -- dap.listeners.before.event_exited["dapui_config"] = function()
      --   dapui.close({})
      -- end
    end,
  }
}
--
-- return {
--   {
--     "mfussenegger/nvim-dap",
--     dependencies = {
-- 	  "nvim-neotest/nvim-nio",
--       "rcarriga/nvim-dap-ui",
--       "mfussenegger/nvim-dap-python",
--       "theHamsta/nvim-dap-virtual-text",
--     },
--     config = function()
--       local dap = require("dap")
--       local dapui = require("dapui")
--       local dap_python = require("dap-python")
--
--       require("dapui").setup({})
--       require("nvim-dap-virtual-text").setup({
--         commented = true, -- Show virtual text alongside comment
--       })
--
--       dap_python.setup("python3")
--
--       vim.fn.sign_define("DapBreakpoint", {
--         text = "",
--         texthl = "DiagnosticSignError",
--         linehl = "",
--         numhl = "",
--       })
--
--       vim.fn.sign_define("DapBreakpointRejected", {
--         text = "", -- or "❌"
--         texthl = "DiagnosticSignError",
--         linehl = "",
--         numhl = "",
--       })
--
--       vim.fn.sign_define("DapStopped", {
--         text = "", -- or "→"
--         texthl = "DiagnosticSignWarn",
--         linehl = "Visual",
--         numhl = "DiagnosticSignWarn",
--       })
--   },
-- }
