-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_user_command("FormatDisable", function()
  vim.b.autoformat = false
  vim.notify("Autoformatting disabled", vim.log.levels.INFO)
end, {})

vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.autoformat = true
  vim.notify("Autoformatting enabled", vim.log.levels.INFO)
end, {})

-- Manual formatting
vim.api.nvim_create_user_command("Format", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, {})
