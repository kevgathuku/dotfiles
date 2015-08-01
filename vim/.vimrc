execute pathogen#infect()

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

syntax enable
filetype plugin indent on
set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans = 1
colorscheme solarized
call togglebg#map("<F5>")
