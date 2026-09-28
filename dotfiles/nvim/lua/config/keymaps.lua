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

vim.keymap.set("n", "<leader><leader>", function()
  local bufname = vim.api.nvim_buf_get_name(0)

  if bufname ~= "" then
    local dir = vim.fn.fnamemodify(bufname, ":h")
    Snacks.picker.files({ cwd = dir, hidden = true })
  else
    Snacks.picker.files()
  end
end, { desc = "Find Files (Buffer Dir)" })

-- Make * search for the word under cursor WITHOUT jumping forward
-- vim.keymap.set("n", "*", "*N", { desc = "Search word under cursor without jumping" })
-- Directly set the search register to the word under the cursor without moving
vim.keymap.set("n", "*", function()
  local word = vim.fn.expand("<cword>") -- Get word under cursor
  vim.fn.setreg("/", "\\<" .. word .. "\\>") -- Put it in the search register with boundaries
  vim.cmd("set hlsearch") -- Turn on highlighting
end, { desc = "Search word under cursor without jumping" })

-- In VISUAL mode: Pressing * searches for exactly what you highlighted
-- without adding word boundaries and without jumping away!
vim.keymap.set("v", "*", function()
  -- Save current selection to a temporary variable
  local old_reg = vim.fn.getreg('"')
  local old_regtype = vim.fn.getregtype('"')

  -- Copy selection, update search register with literal text, restore clipboard
  vim.cmd('normal! ""y')
  local text = vim.fn.escape(vim.fn.getreg('"'), [[\/]])
  vim.fn.setreg("/", text)
  vim.fn.setreg('"', old_reg, old_regtype)

  -- Turn on highlighting
  vim.cmd("set hlsearch")
end, { desc = "Search selection without jumping" })
