" always use utf8
set encoding=utf-8

" sanity. this ain't vi.
set nocompatible

" better searching
set ignorecase
set smartcase

" tabbing/indenting/formatting
set autoindent
set backspace=2
set cursorline
set expandtab
set formatoptions=croqln
set list
" set listchars=tab:·\ ,eol:¬,trail:»
set listchars=tab:·\ ,trail:»
set nohlsearch
set shiftround
set shiftwidth=4
set smartindent
set smarttab
set softtabstop=4
set tabstop=8
set textwidth=80

set background=light

" allows buffers to stick around w/o windows, even outside of files
set hidden

set diffopt=filler,vertical

let g:airline_powerline_fonts = 1

" cursorline only for active window
augroup CursorLineOnlyInActiveWindow
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

if executable('pt')
  set grepprg=pt\ --nogroup\ --nocolor\ --column\ --context=0\ --smart-case
  let g:ackprg = 'pt --nogroup --nocolor --column --context=0 --smart-case'
  let g:grepper = {
	\ 'tools': ['pt'],
	\ 'pt': {
	\   'grepprg':    'pt --nocolor --column --context=0 --smart-case',
	\   'grepformat': '%f:%l:%m',
	\   'escape':     '\+*^$()[]',
	\ }}
endif

colorscheme desert
hi SpecialKey ctermfg=red ctermbg=yellow

syntax on

" assume that first entry is "home config". we could iterate through and take
" the first one that includes $HOME.
let g:rtp0=split(&g:rtp, ",")[0]

" install/load vundle, then the bundles themselves
silent echom "Loading bundles"
execute "source " . g:rtp0 . "/plug-install.vim"
execute "source " . g:rtp0 . "/plug-bundles.vim"
"execute "source " . g:rtp0 . "/vundle-install.vim"
"execute "source " . g:rtp0 . "/vundle-bundles.vim"

silent echom "Loading custom functions"
execute "source " . g:rtp0 . "/functions.vim"

silent echom "Loading keyboard mappings"
execute "source " . g:rtp0 . "/map.vim"

" plugin opts that should follow?
let g:neoterm_position = 'vertical'

" install $RTP/local.vim
if filereadable(g:rtp0 . "/local.vim")
    silent echom "Loading nvim/local"
    execute "source " . g:rtp0 . "/local.vim"
endif

" experimental, needs to move
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':.'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

" indentline is installed, but disabled by default; enabled in java
let g:indentLine_color_term = 234 " (black, on dark grey in current colorscheme)
let g:indentLine_enabled = 0

" from vim-go guide
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }

let g:syntastic_javascript_checkers = ["standard"]
let g:syntastic_sh_checkers = ['bashate']

" search terms are unreadable in my default colorscheme
highlight Search ctermfg=0 ctermbg=12
" darker grey, in seoul-256
highlight CursorLine cterm=none ctermbg=235
" cursorline "highlights" to true black w/ my base16 term setup
"highlight CursorLine cterm=none ctermbg=16

" if list mode enabled, use this instead of default
" NonText: eol, extends, precedes
" SpecialKey: nbsp, tab, trail
highlight NonText cterm=none ctermfg=darkgray
highlight SpecialKey cterm=none ctermfg=darkgray
