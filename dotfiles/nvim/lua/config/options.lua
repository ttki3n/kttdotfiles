-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--

local opt = vim.opt

opt.shiftwidth = 4 -- Size of an indent
opt.tabstop = 4 -- Number of spaces tabs count for
opt.softtabstop = 4 -- Number of spaces that a Tab counts for while editing
opt.expandtab = true -- Use spaces instead of tabs

opt.wrap = true
opt.foldmethod = "manual"

vim.g.codeium_os = "Darwin"
vim.g.codeium_arch = "arm64"
