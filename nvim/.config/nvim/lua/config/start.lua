vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

vim.g.mapleader = " "

-- vim.cmd("set runtimepath^=~/.vim runtimepath+=~/.vim/after")
-- vim.cmd("let &packpath = &runtimepath")
-- source ~/.vimrc

require("config.lazy")
