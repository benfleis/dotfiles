set textwidth=100
set tabstop=8
set softtabstop=4
set shiftwidth=4
set expandtab

" clear out trailing whitespace before writing
" autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``

set keywordprg=pydoc

" python specific helpers
let b:debugger_line='import ipdb; ipdb.set_trace()'
