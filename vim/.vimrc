scriptencoding utf-8
set encoding=utf-8
set t_Co=256
set nocompatible      " We're running Vim, not Vi!
syntax on             " Enable syntax highlighting

set showcmd               " display incomplete commands
set ruler                 " show the cursor position all the time
set laststatus=2          " Always display the status line
set autoread              " Read changes immediately if file changed outside vim
set clipboard=unnamed    " Use system clipboard
set mouse=a               " Enable mouse in all modes
set backspace=2           " make backspace work like most other apps
set shell=zsh
let mapleader = "\<Space>"

" Use relative line numbers
set rnu
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber

set splitbelow
set splitright

" replace add mark key
nnoremap gm m

" Tabs
nnoremap <Tab> gt
nnoremap <S-Tab> gT
" shift-t to create a new empty tab
nnoremap <silent> <S-t> :tabnew<CR>"

" Fzf
nnoremap <C-p> :Files<CR>

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

" Search related settings
set hlsearch
set incsearch
set ignorecase
set smartcase

syntax enable
set termguicolors

" Reduce delay when leaving insert mode
set ttimeoutlen=10

" Vim markdown
let g:vim_markdown_folding_disabled = 1

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR>

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile .{jshint,eslint}rc set filetype=json

  " Automatically wrap at 80 characters for Markdown
  autocmd BufRead,BufNewFile *.md setlocal textwidth=80

  " Automatically wrap at 72 characters and spell check git commit messages
  autocmd FileType gitcommit setlocal textwidth=72
  autocmd FileType gitcommit setlocal spell

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-
augroup END

" When the type of shell script is /bin/sh, assume a POSIX-compatible
" shell for syntax highlighting purposes.
let g:is_posix = 1

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Use one space, not two, after punctuation.
set nojoinspaces

" Make it obvious where 80 characters is
set textwidth=100
set colorcolumn=+1
highlight ColorColumn ctermbg=235 guibg=#262626

" Numbers
set number
set numberwidth=5


" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Autoformat settings
nmap <Leader>f :Autoformat<CR>

" Remap leader to Space
let mapleader = "\<Space>"

" Use leader + q for :Bdelete
:nnoremap <Leader>q :Bdelete<CR>

" Gundo config
nnoremap <F5> :GundoToggle<CR>
let g:gundo_preview_height = 20
let g:gundo_preview_bottom = 1
let g:gundo_close_on_revert = 1

" Rainbow parentheses
" au VimEnter * RainbowParenthesesToggle
" au Syntax * RainbowParenthesesLoadRound
" au Syntax * RainbowParenthesesLoadSquare
" au Syntax * RainbowParenthesesLoadBraces

" ctags
set tags=tags;/

" show trailing whitespace
set listchars=trail:-

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint'],
\   'rust': ['rustfmt'],
\}
let g:ale_linters = {'rust': ['analyzer']}

" abbreviations
iabbr clg console.log("Value: ", value);

" remove trailing whitespace from Ruby files
autocmd FileType ruby autocmd BufWritePre <buffer> %s/\s\+$//e

