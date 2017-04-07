" define leader char
let mapleader = ";"
" double up leader
map <space> ;

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

" useful "go" commands, also duplicated w/ <Leader>
map gd :Gdiff
map gs :Gstatus

" euro!
imap <Esc>@ €

" holy scheisse my life is complete. swap arrow / ctrl-[np] in cmdline editing.
cnoremap <Up> <C-p>
cnoremap <Down> <C-n>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" ---------------------------------------------------------------------------
" leader based maps below
"

" toggles: paste, list display, wrap, search highlight
nmap <Leader>p :silent :setlocal paste!<CR>
" nmap <Leader>S :silent :setlocal list!<CR>
nmap <Leader>S :silent :setlocal spell!<CR>
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

" g/re/p -- ;g
nnoremap <Leader><Leader>g :Grepper -noprompt -cword<CR>
nnoremap <Leader>gr :Grepper<CR>
nnoremap <Leader>gw :Grepper -noprompt -cword<CR>
nnoremap <Leader># :Grepper -tool git -open -switch -cword -noprompt<CR>
nnoremap <Leader>* :Grepper -tool git -open -switch -cword -noprompt<CR>

" git gutter -- ;G
nnoremap <Leader>Gn :GitGutterNextHunk<CR>
nnoremap <Leader>Gp :GitGutterPrevHunk<CR>
nnoremap <Leader>Gh :GitGutterLineHighlightsToggle<CR>
nnoremap <Leader>GP :GitGutterPreviewHunk<CR>	
nnoremap <Leader>GU :GitGutterUndoHunk<CR>
nnoremap <Leader>GS :GitGutterStageHunk<CR>

" buffers -- ;b -- identical to the :commands, 'cept bd -> Bclose
nnoremap <Leader>bd :Bclose<CR>
nnoremap <Leader>bn :bn<CR>
nnoremap <Leader>bp :bp<CR>
nnoremap <Leader>bl :ls<CR>
" nnoremap <Leader>bb :buffer<Space>
function! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! s:bufopen(e)
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction

nnoremap <silent> <Leader>bb :call fzf#run({
\   'source':  reverse(<sid>buflist()),
\   'sink':    function('<sid>bufopen'),
\   'options': '+m',
\   'down':    len(<sid>buflist()) + 2
\ })<CR>

" and list walkers too, like above, but also cf variants for file
nnoremap <Leader>ct :cc<CR> " t=this
nnoremap <Leader>cn :cn<CR>
nnoremap <Leader>cp :cp<CR>
nnoremap <Leader>cfn :cnf<CR>
nnoremap <Leader>cfp :cpf<CR>
nnoremap <Leader>cc :cclose<CR>
nnoremap <Leader>co :copen<CR>

nnoremap <Leader>lt :ll<CR> " t=this
nnoremap <Leader>ln :lnext<CR>
nnoremap <Leader>lp :lprevious<CR>
nnoremap <Leader>lfn :lnf<CR>
nnoremap <Leader>lfp :lpf<CR>
nnoremap <Leader>lc :lclose<CR>
nnoremap <Leader>lo :lopen<CR>

" different mnemonic: compile <X>
nnoremap <Leader>cm :Neomake<CR>
nnoremap <Leader>mm :Neomake<CR>

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

" THIS shortcuts begin with ;t
" nnoremap <Leader>tc :SyntasticCheck<CR> " this check

" THIS N-step tab settings
map <Leader>t2 :silent :setlocal ts=2 sts=2 sw=2<CR>
map <Leader>t3 :silent :setlocal ts=3 sts=3 sw=3<CR>
map <Leader>t4 :silent :setlocal ts=4 sts=4 sw=4<CR>
map <Leader>t8 :silent :setlocal ts=8 sts=8 sw=8<CR>

" FZF shorties
map <Leader>ff :Files<CR>
