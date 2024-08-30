" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
" vim +PluginInstall +qall - install from command line
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"
" Plugin Config
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/syntastic'
Plugin 'mattn/emmet-vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-fugitive'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'mhinz/vim-signify'
Plugin 'christoomey/vim-tmux-navigator'
Bundle 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-rails'
Plugin 'flazz/vim-colorschemes'
Plugin 'vim-test/vim-test'
Plugin 'rakr/vim-one'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-rhubarb'
Plugin 'NLKNguyen/papercolor-theme'

" All of your Plugins must be added before the following line
call vundle#end()            " required

set background=dark
colorscheme PaperColor
syntax on

" System Default
set t_Co=256   " This is may or may not needed.
set nocompatible
set splitbelow
set splitright
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set autoindent
set ignorecase
set smartcase
set noeb vb t_vb=
au GUIEnter * set vb t_vb=
set incsearch
set laststatus=2
set backspace=2
set number
set title " change the terminal's title
set colorcolumn=120

if (has('termguicolors'))
  set termguicolors
endif

filetype plugin indent on

" :help new-omni-completion :help compl-omni
set omnifunc=syntaxcomplete#Complete
" Mapping
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>


" NERDtree
map <C-n> :NERDTreeToggle<CR>

" Autoremove whitespaces
autocmd BufWritePre * %s/\s\+$//e

" Airline
let g:airline_theme='badwolf'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" Vim ruby - :help ft-ruby-syntax
let ruby_space_errors = 1
let ruby_operators = 1
let ruby_foldable_groups = 'if case %'
" imap <S-CR>    <CR><CR>end<Esc>-cc

" RSpec.vim mappings
let test#ruby#rspec#executable = 'docker exec -it kantox-flow-app-1 bundle exec rspec'
let test#ruby#rspec#options = {
  \'file': '--format documentation',
\}
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>
