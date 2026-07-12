-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here


vim.keymap.set("i", "jk", "<Esc>", { desc = "Return normal mode" })
vim.keymap.set("i", "jj", "<Esc>", { desc = "Return normal mode" })

vim.keymap.set("c", "w!!", "w !sudo tee % > /dev/null", { desc = "Sudo Write" })
