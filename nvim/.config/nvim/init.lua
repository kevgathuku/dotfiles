-- Import vim config
vim.cmd('set runtimepath^=~/.vim runtimepath+=~/.vim/after')
vim.o.packpath = vim.o.runtimepath
vim.cmd('source ~/.vimrc')

require("config.lazy")
-- set clipboard=unnamed,unnamedplus
-- vim.api.nvim_set_option("clipboard", "unnamed")

