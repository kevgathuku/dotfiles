-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.lazyvim_rust_diagnostics = "rust-analyzer"

-- Disable automatic clipboard sync - yanking in vim stays in vim only
vim.opt.clipboard = ""

-- Use light background for alabaster theme
vim.o.background = "light"
