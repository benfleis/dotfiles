" simplified Mark() function from http://www.vim.org/scripts/script.php?script_id=72
function! Mark(...)
    let mark = line(".") . "G" . virtcol(".") . "|"
    normal! H
    let mark = "normal!" . line(".") . "Gzt" . mark
    execute mark
    return mark
endfunction

" remove all trailing whitespace
function! StripTrailingWS()
    let pos = Mark()
    exe '%s/\s\+$//ge'
    exe pos
endfunction

" from Zathrus on #vim
function! CloseIfOnlyWindow(force)
   " Performing :bd in a tab page will close the tab page, similar to
   " performing :bd in a split window
   if winnr('$') == 1 && (!exists('*tabpagenr') || tabpagenr('$') == 1)
      if a:force
         bd!
      else
         bd
      endif
   else
      if bufnr('#') == -1
         enew
      else
         if buflisted(bufnr('#'))
            b #
         else
            let bufnum = bufnr('$')
            while (bufnum == bufnr('%')) || ((bufnum > 0) && !buflisted(bufnum))
               let bufnum = bufnum-1
            endwhile

            if (bufnum == 0)
               enew
            else
               exec "b " . bufnum
            endif
         endif
      endif
      if a:force
         bd! #
      else
         bd #
      endif
   endif
endfunction

" if we're in $HOME/src/FOO/../../..., set a top level tag file of
" $HOME/src/FOO/tags
"let src = $HOME . "/src"
"let cwd = getcwd()
"if stridx(cwd, src) == 0
"  let sub = strpart(cwd, strlen(src) + 1)
"  if stridx(sub, "/") >= 0
"    let sub = strpart(sub, 0, stridx(sub, "/"))
"  endif
"  let &tags = "tags," . src . "/" . sub . "/tags"
"endif

