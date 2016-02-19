" define leader char
let mapleader = ";"

" alt-[hjkl] ALWAYS work for window mvmt, esp. with :terminal goo
:tnoremap <C-[><C-[> <C-\><C-n>
:tnoremap <A-h> <C-\><C-n><C-w>h
:tnoremap <A-j> <C-\><C-n><C-w>j
:tnoremap <A-k> <C-\><C-n><C-w>k
:tnoremap <A-l> <C-\><C-n><C-w>l

:nnoremap <A-h> <C-w>h
:nnoremap <A-j> <C-w>j
:nnoremap <A-k> <C-w>k
:nnoremap <A-l> <C-w>l

" buffer switches, identical to the :commands, 'cept bd -> Bclose
:nnoremap <Leader>bd :Bclose<CR>
:nnoremap <Leader>bn :bn<CR>
:nnoremap <Leader>bp :bp<CR>

" and list walkers too, like above, but also cf variants for file
:nnoremap <Leader>cc :cc<CR>
:nnoremap <Leader>cn :cn<CR>
:nnoremap <Leader>cp :cp<CR>
:nnoremap <Leader>cfn :cnf<CR>
:nnoremap <Leader>cfp :cpf<CR>
:nnoremap <Leader>cd :cclose<CR>
:nnoremap <Leader>co :copen<CR>

" "double click" shortcuts, for me ;;<X>. valuable, saved for most frequent.
" window movement with 1 hand; testing to see if I like.
:nnoremap <Leader><Leader>h <C-w>h
:nnoremap <Leader><Leader>j <C-w>j
:nnoremap <Leader><Leader>k <C-w>k
:nnoremap <Leader><Leader>l <C-w>l
:nnoremap <Leader><Leader>s <C-w>s
:nnoremap <Leader><Leader>v <C-w>v
:nnoremap <Leader><Leader>q <C-w>q

" REPLy stuff; broken
:nnoremap <Leader>er :TREPLSend<CR>
:vnoremap <Leader>er :TREPLSend<CR>
:nnoremap <Leader>ee :TREPLSendFile<CR>

" CTRL-a does paragraph reformat
map  gqap

"map - :bp
"map = :bn
"map _ :silent :call CloseIfOnlyWindow(0)<CR>

" useful "go" commands
map gd :Gdiff)
map gs :Gstatus

" euro!
imap <Esc>@ €

" ---------------------------------------------------------------------------
" leader based maps below
"

" toggles: paste, list display, wrap, search highlight
nmap <Leader>p :silent :setlocal paste!<CR>
nmap <Leader>l :silent :setlocal list!<CR>
nmap <Leader>w :silent :setlocal wrap!<CR>
nmap <Leader>h :silent :setlocal hlsearch!<CR>
nmap <Leader>y :silent "+y

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

" gitx
nmap <Leader>gx :silent :!open -a GitX .<CR><CR>
