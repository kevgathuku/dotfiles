vim.g.mapleader = " "

-- Import vim config
vim.cmd('set runtimepath^=~/.vim runtimepath+=~/.vim/after')
vim.o.packpath = vim.o.runtimepath
vim.cmd('source ~/.vimrc')

-- vim.cmd.colorscheme "sorbet"
require("config.lazy")

