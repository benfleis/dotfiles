set sts=0
set sw=0
set noet
set ts=8
set nolist

nnoremap <C-]> :GoDef<CR>
nnoremap <C-t> <C-o>

nnoremap <Leader>ee :GoBuild<CR>

" test this, file, compile
nnoremap <Leader>tt :GoTestFunc<CR>
nnoremap <Leader>tf :GoTest<CR>
nnoremap <Leader>tc :GoTestCompile<CR>
