" define leader char
let mapleader = ";"
let maplocalleader = " "

" euro!
imap <Esc>@ €

" write & stage (Git add). I should wrap this to be async.
command -bar WS :write % | :Git add %

" holy scheisse my life is complete. swap arrow / ctrl-[np] in cmdline editing.
cnoremap <Up> <C-p>
cnoremap <Down> <C-n>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

"" "double tap" super shortcuts
" for me ;;<X>. valuable, saved for most frequent.

" window movement with 1 hand;
nnoremap <Leader><Leader>h <C-w>h
nnoremap <Leader><Leader>j <C-w>j
nnoremap <Leader><Leader>k <C-w>k
nnoremap <Leader><Leader>l <C-w>l
nnoremap <Leader><Leader>s <C-w>s
nnoremap <Leader><Leader>v <C-w>v
nnoremap <Leader><Leader>q <C-w>q

" focus mode toggle -- tricky overlap with find?
nnoremap <Leader><Leader>f <cmd>Goyo<CR>

nnoremap <Leader><Leader>d <cmd>Bclose<CR>
nnoremap <Leader><Leader>n <cmd>bn<CR>
nnoremap <Leader><Leader>p <cmd>bp<CR>
nnoremap <Leader><Leader>l <cmd>ls<CR>
nnoremap <Leader><Leader>b <cmd>Telescope buffers<CR>
" nnoremap <Leader><Leader>e <cmd>Telescope file_browser<CR>

" open/find sibling files
nnoremap <Leader><Leader>e <cmd>lua require('telescope.builtin').find_files{cwd = require('benfleis').get_file_dir()}<CR>

" grepper: <Leader>gr? grr,gcc -- grep [cwd], grs: grep siblings, grp: grep from parent
nnoremap <Leader>grc <cmd>lua require('telescope.builtin').live_grep()<CR>
nnoremap <Leader>grs <cmd>lua require('telescope.builtin').live_grep{cwd = require('benfleis').get_file_dir()}<CR>
nnoremap <Leader>grp <cmd>lua require('telescope.builtin').live_grep{cwd = require('benfleis').get_file_dir() .. "/.."}<CR>
nnoremap <Leader>grr <cmd>lua require('telescope.builtin').live_grep()<CR>

" open telescope file finder in grandparent of current buf/file
" TODO: add <N> support before 'p' for multiple parents upward
" es: edit from siblings, ep: edit from parent dir
nnoremap <Leader>ec <cmd>lua require('telescope.builtin').find_files()<CR>
nnoremap <Leader>es <cmd>lua require('telescope.builtin').find_files{cwd = require('benfleis').get_file_dir()}<CR>
nnoremap <Leader>ep <cmd>lua require('telescope.builtin').find_files{cwd = require('benfleis').get_path_parentage(nil, vim.api.nvim_eval('v:count1') + 1)}<CR>
nnoremap <Leader>e2p <cmd>lua require('telescope.builtin').find_files{cwd = require('benfleis').get_path_parentage(nil, 3)}<CR>
nnoremap <Leader>e3p <cmd>lua require('telescope.builtin').find_files{cwd = require('benfleis').get_path_parentage(nil, 4)}<CR>
nnoremap <Leader>e4p <cmd>lua require('telescope.builtin').find_files{cwd = require('benfleis').get_path_parentage(nil, 5)}<CR>
nnoremap <Leader>er <cmd>lua require('telescope.builtin').find_files{cwd = require('benfleis').get_repo_root()}<CR>

" open telescope file finder in $XDG_CONFIG_HOME/nvim
" TODO fix this to use stdpath('config') in lua
nnoremap <Leader>eC <cmd>lua require('telescope.builtin').find_files{cwd = '~/.config/nvim'}<CR>

" [jump] journal today
nnoremap <Leader>gt <cmd>lua require('journal').edit_today()<CR>
nnoremap <Leader>ej <cmd>lua require('telescope.builtin').find_files{cwd = '~/Documents/logs', default_text = '2022/02'}<CR>

" [jump] transient: sql notes
nnoremap <Leader>gn <cmd>edit ~/Documents/notes/sql-exec-api.norg<CR>

" attach/detach gitsigns gutter for this buffer
" move detach to the attached state only
nnoremap <Leader>ha <cmd>lua require('gitsigns').attach()<CR>
nnoremap <Leader>hd <cmd>lua require('gitsigns').detach()<CR>

" toggle conceal/show // F: comments
syntax match Ignore '^.*// F:.*$' conceal transparent cchar=-
" nnoremap <Leader>FC <cmd>syntax match Ignore '^.*// F:.*$' conceal cchar=-<CR>
" nnoremap <Leader>FH <cmd>set conceallevel=2<CR>
" nnoremap <Leader>FS <cmd>set conceallevel=0<CR>

" toggles: paste, list display, wrap, search highlight
nmap <Leader>p <cmd>setlocal paste!<CR>
" nmap <Leader>S <cmd>setlocal list!<CR>
" nmap <Leader>S <cmd>setlocal spell!<CR>
nmap <Leader>w <cmd>setlocal wrap!<CR>
nmap <Leader>l <cmd>setlocal linebreak!<CR>
nmap <Leader>W <cmd>call WrapStyleToggle()<CR>
nmap <Leader>h <cmd>setlocal hlsearch!<CR>
map <Leader>y "*y

map gs :Git<CR>

"" Navigation
" Pane Movement: alt-[hjkl] ALWAYS work, esp. with :terminal goo
tnoremap <C-[><C-[> <C-\><C-n>
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l

nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" tabs (seldom used in current habits)
nnoremap <Leader>tn :tabNext<CR>
nnoremap <Leader>tp :tabNext<CR>

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



" this tab 2,3,4,8
map <Leader>t2 <cmd>setlocal ts=2 sts=2 sw=2<CR>
map <Leader>t3 <cmd>setlocal ts=3 sts=3 sw=3<CR>
map <Leader>t4 <cmd>setlocal ts=4 sts=4 sw=4<CR>
map <Leader>t8 <cmd>setlocal ts=8 sts=8 sw=8<CR>

