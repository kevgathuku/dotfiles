scriptencoding utf-8
set encoding=utf-8
set nocompatible      " We're running Vim, not Vi!
syntax on             " Enable syntax highlighting
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
filetype plugin indent on
set showcmd               " display incomplete commands
set ruler                 " show the cursor position all the time
set laststatus=2          " Always display the status line
set autoread              " Read changes immediately if file changed outside vim
" set clipboard=unnamed    " Use system clipboard
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

" Tabs
nnoremap <Tab> gt
nnoremap <S-Tab> gT
" shift-t to create a new empty tab
nnoremap <silent> <S-t> :tabnew<CR>"

" Fzf
command! -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --hidden --glob "!.git/*" --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>),
      \   1,
      \ fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}),
      \   <bang>0)

nnoremap <C-p> :Files<CR>
nnoremap <leader>fg :Rg<CR>
nnoremap <leader>b :Buffers<CR>

" mac settings
set rtp+=/opt/homebrew/opt/fzf

" Search related settings
set hlsearch
set incsearch
set ignorecase
set smartcase

" Faster windows navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" folding
" set foldmethod=syntax
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=4

syntax enable
set termguicolors

if !has('gui_running')
  set t_Co=256
endif
set noshowmode

" running in vim
if !has('nvim')
  colorscheme darkblue
  if filereadable(expand("~/.vimrc.bundles"))
    source ~/.vimrc.bundles
  endif
endif

" replace add mark key
nnoremap gm m

" copy to system clipboard
xnoremap <leader>y "+y
nnoremap <leader>y "+y

" Paste from system clipboard in normal and visual mode with leader + v
nnoremap <leader>v "+p
vnoremap <leader>v "+p

" replacement keybindings for cut
nnoremap m d
xnoremap m d

nnoremap mm dd
nnoremap M D

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

" less annoying highlight column color
highlight ColorColumn ctermbg=235 guibg=#262626

if !has('gui_running') && &term =~ '\%(screen\|tmux\)'
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
set termguicolors


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
