" alt-[hjkl] ALWAYS work for window mvmt
:tnoremap <A-h> <C-\><C-n><C-w>h
:tnoremap <A-j> <C-\><C-n><C-w>j
:tnoremap <A-k> <C-\><C-n><C-w>k
:tnoremap <A-l> <C-\><C-n><C-w>l
:nnoremap <A-h> <C-w>h
:nnoremap <A-j> <C-w>j
:nnoremap <A-k> <C-w>k
:nnoremap <A-l> <C-w>l

" REPLy stuff
map <Leader>er TREPLSend
map <Leader>ee TREPLSendFile

" CTRL-a does paragraph reformat
map  gqap

"map - :bp
"map = :bn
"map _ :silent :call CloseIfOnlyWindow(0)<CR>

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

" toggles: paste, list display, wrap, search highlight
nmap <Leader>p :silent :setlocal paste!<CR>
nmap <Leader>l :silent :setlocal list!<CR>
nmap <Leader>w :silent :setlocal wrap!<CR>
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

" delete matching parenthesis/brackets
map <Leader>d% :silent %x``x

" tslime bindings
vmap <Leader>y <Plug>SendSelectionToTmux
nmap <Leader>y <Plug>NormalModeSendToTmux
nmap <Leader>R <Plug>SetTmuxVars

