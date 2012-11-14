" define leader char
let mapleader = ","

" CTRL-a does paragraph reformat
map  gqap

map <F1> :set list!

map <F7> :!ctags -R *
map <F8> :make
map <F9> :cn
map <F10> :cc

map - :bp
map = :bn
map _ :call <SID>CloseIfOnlyWindow(0)<CR>

" toggle search highlighting via <Leader>h/H
nmap <Leader>h :silent :set hlsearch!<CR>
nmap <Leader>w :silent StripTrailingWS()<CR>
