set sts=0
set sw=0
set noet
set ts=4
set nolist

let g:go_fmt_command = "goimports"
let g:go_list_type = "quickfix"
let g:go_term_enabled = 1
let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
" let g:go_highlight_methods = 1
" let g:go_highlight_fields = 1
" let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_fmt_experimental = 1

" if file name ends in _test.go, call GoTest to test the file. Otherwise do
" GoBuild.
function! GoBuildOrTestFile()
    if expand("%t") =~ "_test\.go$"
		execute "GoTestCompile"
    else
		execute "GoBuild"
    endif
endfunction

nnoremap <Leader>cf :GoBuild<CR>

" test this, file, compile
nnoremap <Leader>tt :GoTestFunc<CR>
nnoremap <Leader>tf :GoTest<CR>
nnoremap <Leader>tc :GoTestCompile<CR>

" Go to Imports
nnoremap gi :1/^\<import\>/+1<CR>

" Insert breakpoint
" mark pos, insert bp cmd, gi (go imports), append "runtime", return to pos
" nnoremap <Leader>ib m`Oruntime.Breakpoint()<Esc>gio"runtime"<Esc>``
nmap <Leader>ib Oruntime.Breakpoint()<Esc>:GoImports<CR>

" Delete all breakpoints, remove runtime import
nmap <Leader>db m`:g/^\s*runtime.Breakpoint()\s*$/d<CR>:g/^\s*"runtime"\s*$/d<CR>``

" for funsies, more pedantic runtime deletion search only imports
" :/^import ($/,/^)$/g/"runtime"/d
