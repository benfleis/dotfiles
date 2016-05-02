" define leader char
let mapleader = ";"

" alt-[hjkl] ALWAYS work for window mvmt, esp. with :terminal goo
tnoremap <C-[><C-[> <C-\><C-n>
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l

nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" CTRL-a does paragraph reformat
map  gqap

"map - :bp
"map = :bn
"map _ :silent :call CloseIfOnlyWindow(0)<CR>

" useful "go" commands
map gd :Gdiff
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
nmap <Leader>W :silent :call WrapStyleToggle()<CR>
nmap <Leader>h :silent :setlocal hlsearch!<CR>
map <Leader>y "*y

" strip whitespace
nmap <Leader>s :silent :call StripTrailingWS()<CR>

" Insert b:debugger_line
nmap <Leader>d O<C-R>=b:debugger_line<C-[><C-[>

" special searches:
" under_scores:
nmap <Leader>fu :silent /\v<_*\l[a-z0-9_]*_[a-z0-9_]*><CR>
" CamelCase:
nmap <Leader>fc :silent /\v<_*\u\k*\l\k*\u\k*><CR>

" delete matching parenthesis/brackets
map <Leader>d% :silent %x``x

" gitx
nnoremap <Leader>gx :silent :!open -a GitX .<CR><CR>

"
nnoremap <Leader>gn :GitGutterNextHunk<CR>
nnoremap <Leader>gp :GitGutterPrevHunk<CR>
nnoremap <Leader>gh :GitGutterLineHighlightsToggle<CR>
nnoremap <Leader>gP :GitGutterPreviewHunk<CR>
nnoremap <Leader>gR :GitGutterRevertHunk<CR>
nnoremap <Leader>gS :GitGutterStageHunk<CR>

" buffer switches, identical to the :commands, 'cept bd -> Bclose
nnoremap <Leader>bd :Bclose<CR>
nnoremap <Leader>bn :bn<CR>
nnoremap <Leader>bp :bp<CR>
nnoremap <Leader>bl :ls<CR>
nnoremap <Leader>bb :buffer<Space>

" and list walkers too, like above, but also cf variants for file
nnoremap <Leader>cc :cc<CR>
nnoremap <Leader>cn :cn<CR>
nnoremap <Leader>cp :cp<CR>
nnoremap <Leader>cfn :cnf<CR>
nnoremap <Leader>cfp :cpf<CR>
nnoremap <Leader>cd :cclose<CR>
nnoremap <Leader>co :copen<CR>

nnoremap <Leader>ll :ll<CR>
nnoremap <Leader>ln :lnext<CR>
nnoremap <Leader>lp :lprevious<CR>
nnoremap <Leader>lfn :lnf<CR>
nnoremap <Leader>lfp :lpf<CR>
nnoremap <Leader>ld :lclose<CR>
nnoremap <Leader>lo :lopen<CR>

nnoremap <Leader>tt :tabedit %<CR>
nnoremap <Leader>tn gt
nnoremap <Leader>tp gT

" "double tap" shortcuts, for me ;;<X>. valuable, saved for most frequent.
" window movement with 1 hand; testing to see if I like.
nnoremap <Leader><Leader>h <C-w>h
nnoremap <Leader><Leader>j <C-w>j
nnoremap <Leader><Leader>k <C-w>k
nnoremap <Leader><Leader>l <C-w>l
nnoremap <Leader><Leader>s <C-w>s
nnoremap <Leader><Leader>v <C-w>v
nnoremap <Leader><Leader>q <C-w>q

nnoremap <Leader><Leader>d :Bclose<CR>
nnoremap <Leader><Leader>n :bn<CR>
nnoremap <Leader><Leader>p :bp<CR>
nnoremap <Leader><Leader>l :ls<CR>
nnoremap <Leader><Leader>b :buffer<Space>

" open sibling, cmd line
nmap <Leader><Leader>e :silent :e <C-R>=expand("%:p:h") . "/"<CR>
" open sibling, netrw explorer
nmap <Leader><Leader>E :silent :E <C-R>=expand("%:p:h") . "/"<CR>

" THIS shortcuts being with ;t
nnoremap <Leader>tc :SyntasticCheck<CR> " this check

" THIS N-step tab settings
map <Leader>t2 :silent :setlocal ts=2 sts=2 sw=2<CR>
map <Leader>t3 :silent :setlocal ts=3 sts=3 sw=3<CR>
map <Leader>t4 :silent :setlocal ts=4 sts=4 sw=4<CR>
map <Leader>t8 :silent :setlocal ts=8 sts=8 sw=8<CR>

" REPLy stuff; broken, should be per lang
"nnoremap <Leader>er :TREPLSend<CR>
"vnoremap <Leader>er :TREPLSend<CR>
"nnoremap <Leader>ee :TREPLSendFile<CR>
