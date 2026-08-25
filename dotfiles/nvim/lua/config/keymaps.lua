-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("i", "jk", "<Esc>", { desc = "Return normal mode" })
vim.keymap.set("i", "jj", "<Esc>", { desc = "Return normal mode" })

vim.keymap.set("c", "w!!", "w !sudo tee % > /dev/null", { desc = "Sudo Write" })

vim.keymap.set("n", "<leader>sf", function()
  Snacks.picker.grep({
    cwd = vim.fn.expand("%:p:h"),
  })
end, { desc = "Grep (Current Buffer Dir)" })

vim.keymap.set("n", "<leader>sF", function()
  -- Gathers all directories within your current workspace root
  local workspace_path = vim.fn.getcwd()
  local directories = vim.fn.systemlist("fd -t d . " .. workspace_path)

  vim.ui.select(directories, {
    prompt = "Select folder to Grep:",
    format_item = function(item)
      return item:gsub(workspace_path .. "/", "")
    end,
  }, function(choice)
    if choice then
      Snacks.picker.grep({ dirs = { choice } })
    end
  end)
end, { desc = "Grep in Selected Folder..." })
