hi diffFile ctermfg=black ctermbg=yellow
"hi diffAdded ctermfg=green ctermbg=black
hi diffAdded ctermfg=2
hi diffRemoved ctermfg=1
"hi diffRemoved ctermfg=red ctermbg=black
"
"hi diffAdded ctermfg=black ctermbg=green
"hi diffRemoved ctermfg=white ctermbg=red
map <buffer> <F9> /^Index: zt
map <buffer> <S-F9> /^@@
map <buffer> <F10> l?^Index: zt

" deprecate gz in favor of gl
map gz :call DiffToSource()
map gl :call DiffToSource()
