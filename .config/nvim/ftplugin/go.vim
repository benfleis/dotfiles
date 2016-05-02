set sts=0
set sw=0
set noet
set ts=8
set nolist

let g:go_fmt_command = "goimports"

" if file name ends in _test.go, call GoTest to test the file. Otherwise do
" GoBuild.
function! GoBuildOrTestFile()
    if expand("%t") =~ "_test\.go$"
	GoTest()
    else
	GoBuild()
    endif
endfunction

nnoremap <Leader>ee :silent :call GoBuildOrTest()<CR>

" test this, file, compile
nnoremap <Leader>tt :GoTestFunc<CR>
nnoremap <Leader>tf :GoTest<CR>
nnoremap <Leader>tc :GoTestCompile<CR>
