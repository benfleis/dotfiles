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

" useful "go" commands
map gd :call RunSdiff()
map gs :Gstatus

" tab settings
map <Leader>t2 :silent :setlocal ts=2 sts=2 sw=2<CR>
map <Leader>t3 :silent :setlocal ts=3 sts=3 sw=3<CR>
map <Leader>t4 :silent :setlocal ts=4 sts=4 sw=4<CR>
map <Leader>t8 :silent :setlocal ts=8 sts=8 sw=8<CR>
