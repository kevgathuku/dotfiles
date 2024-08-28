vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set encoding=utf-8")
vim.cmd("set showcmd")
vim.cmd("set ruler")
vim.cmd("set laststatus=2")
vim.cmd("set cursorline")
vim.cmd("set autoread")
vim.cmd("set mouse=a")
vim.cmd("set backspace=2")
vim.cmd("set shell=zsh")
vim.cmd("set rnu")
vim.cmd("")
vim.cmd("")
vim.cmd("")
vim.cmd("")
vim.cmd("")
vim.cmd("")


vim.g.mapleader = " "

-- vim.cmd("set runtimepath^=~/.vim runtimepath+=~/.vim/after")
-- vim.cmd("let &packpath = &runtimepath")
-- source ~/.vimrc

require("config.lazy")
