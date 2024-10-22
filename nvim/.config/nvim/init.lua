-- Import vim config
vim.cmd('set runtimepath^=~/.vim runtimepath+=~/.vim/after')
vim.o.packpath = vim.o.runtimepath
vim.cmd('source ~/.vimrc')

vim.api.nvim_set_keymap('n', '<leader>gt', ':tab tag <C-R><C-W><CR>', { noremap = true, silent = true })

require("config.lazy")
