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


""
" function that, tries to translate current position w/in a context diff
" into a location/search expr in the referenced file.
"
" only called by 'gz' key in ftplugins/diff.vim
"
function! DiffToSource()
    " get current position, then search backward to relevant location
    " marker ("^@@ -orig_off,orig_len +new_off,new_len @@")
    let s:sec_line = search('^@@ -\d\+,\d\+ +\d\+,\d\+ @@', 'bnW')
    let s:sec_text = getline(s:sec_line)
    let s:parts = split(s:sec_text, "[ ,+-]")
    let s:open_line = str2nr(s:parts[5])   " new file starting offset

    " get file to open
    let s:index_text = getline(search('^Index: ', 'bnW'))
    let s:open_file = s:index_text[7:-1]

    " now count the # of lines to skip forward
    " starting at s:line + 1, get each line
    let s:cur_line = line(".")
    let s:open_offset = 0
    for i in range(s:sec_line + 1, s:cur_line - 1)
        let s:l = getline(i)[0]
        if s:l == " " || s:l == "+"
            let s:open_offset += 1
        endif
    endfor

    " and snag expression to match
    "let s:open_pat = getline(".")[0:-1]
    " could search for "\V" . s:open_pat

    " do it!  split windows and open up
    if winwidth(winnr()) > 150
        vsplit
    else
        split
    endif

    exec "find " . s:open_file
    exec string(s:open_line + s:open_offset)
endfunction

" run the external command 'sdiff'
function! RunSdiff()
    !sdiff
    e .s.diff
endfunction

" run sdiff
command Sdv call RunSdiff()
command Sdiff call RunSdiff()

