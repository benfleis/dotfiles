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
map _ :silent :call CloseIfOnlyWindow(0)<CR>

" Insert b:debugger_line
nmap <Leader>D O<C-R>=b:debugger_line<C-[><C-[>

" toggle search highlighting via <Leader>h/H
nmap <Leader>h :silent :set hlsearch!<CR>
nmap <Leader>w :silent :call StripTrailingWS()<CR>

" tslime bindings
vmap <Leader>y <Plug>SendSelectionToTmux
nmap <Leader>y <Plug>NormalModeSendToTmux
nmap <Leader>R <Plug>SetTmuxVars
