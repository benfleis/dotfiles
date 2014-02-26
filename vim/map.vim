" CTRL-a does paragraph reformat
map  gqap

map <F7> :!ctags -R *
map <F8> :make
map <F9> :cn
map <F10> :cc

map - :bp
map = :bn
map _ :silent :call CloseIfOnlyWindow(0)<CR>

" useful "go" commands
map gd :call RunSdiff()
map gs :Gstatus

" euro!
imap <Esc>@ €

" ---------------------------------------------------------------------------
" leader based maps below
"

" define leader char
let mapleader = ";"

" toggle paste mode
nmap <Leader>p :silent :setlocal paste!<CR>

" toggle list display
nmap <Leader>l :silent :setlocal list!<CR>

" toggle wrap mode
nmap <Leader>w :silent :setlocal wrap!<CR>

" toggle search highlighting via <Leader>h/H
nmap <Leader>h :silent :setlocal hlsearch!<CR>

" strip whitespace
nmap <Leader>s :silent :call StripTrailingWS()<CR>

" Insert b:debugger_line
nmap <Leader>d O<C-R>=b:debugger_line<C-[><C-[>

" special searches:
" under_scores:
nmap <Leader>fu :silent /\v<_*\l[a-z0-9_]*_[a-z0-9_]*><CR>
" CamelCase:
nmap <Leader>fc :silent /\v<_*\u\k*\l\k*\u\k*><CR>

" tab settings
map <Leader>t2 :silent :setlocal ts=2 sts=2 sw=2<CR>
map <Leader>t3 :silent :setlocal ts=3 sts=3 sw=3<CR>
map <Leader>t4 :silent :setlocal ts=4 sts=4 sw=4<CR>
map <Leader>t8 :silent :setlocal ts=8 sts=8 sw=8<CR>

" tslime bindings
vmap <Leader>y <Plug>SendSelectionToTmux
nmap <Leader>y <Plug>NormalModeSendToTmux
nmap <Leader>R <Plug>SetTmuxVars

