-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local opt = vim.opt

opt.wrap = true
opt.foldmethod = "manual"

vim.g.codeium_os = "Darwin"
vim.g.codeium_arch = "arm64"
vim.g.autoformat = false

-- Default: 4 spaces
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- 2 spaces cho web & scripting
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    -- Web
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "jsx",
    "tsx",
    "vue",
    "html",
    "css",
    "scss",
    "less",
    "json",
    "jsonc",
    "yaml",
    "graphql",
    -- Scripting
    "ruby",
    "php",
    "shell",
    "bash",
    "lua",
    "markdown",
  },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})
