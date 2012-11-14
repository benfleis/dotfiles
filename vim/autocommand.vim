filetype plugin indent on
syntax on

" on opening the file, clear search-highlighting
autocmd BufReadCmd set nohlsearch

augroup myfiletypes
    autocmd!
    autocmd BufNewFile,BufRead *.kml                    setf xml
    autocmd BufNewFile,BufRead *.*sql*,*.dump           setf sql
    autocmd BufNewFile,BufRead SCons*                   setf python
    autocmd BufNewFile,BufRead *.pyx,*.pxd              setf pyrex
    autocmd BufNewFile,BufRead *.stk,*.ys               setf scheme
    autocmd BufNewFile,BufRead mozex.textarea*          setf twiki
    autocmd BufNewFile,BufRead *.txt                    setf text
    autocmd BufNewFile,BufRead *.asm                    setf nasm
    autocmd BufNewFile,BufRead *.xdot                   setf dot
    autocmd BufNewFile,BufRead *.as                     setf actionscript
    autocmd BufNewFile,BufRead *.m                      setf objc
    autocmd BufNewFile,BufRead *.scala                  setf scala

    autocmd BufNewFile,BufRead .tmux*.conf*,tmux.conf*  setf tmux
augroup END


" When editing a file, always jump to the last known cursor position.
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
