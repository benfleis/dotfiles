" probably should move elsewhere
function! AutoWrapToggle()
    if &formatoptions =~ 't'
        setlocal fo-=t
    else
        setlocal fo+=t
    endif
endfunction

function! WrapStyleToggle()
    if &wrapmargin == 0
        if &textwidth == 0
            setlocal textwidth=80
            setlocal wrapmargin=0
        else
            setlocal textwidth=0
            setlocal wrapmargin=1
        endif
    else
        " &textwidth = 0 && &wrapmargin == 1
        " also explicitly sets any unknown stats to this one.
        setlocal textwidth=0
        setlocal wrapmargin=0
    endif
endfunction

function! TrimTrailingSpace()
    silent! %s/\s\+$
endfunction
command! -bar -nargs=0 TrimTrailingSpace call TrimTrailingSpace()

function! EnableTrimTrailingSpace()
    autocmd FileWritePre * :TrimTrailingSpace
    autocmd FileAppendPre * :TrimTrailingSpace
    autocmd FilterWritePre * :TrimTrailingSpace
    autocmd BufWritePre * :TrimTrailingSpace
endfunction
