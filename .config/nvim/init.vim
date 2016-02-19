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
set expandtab
set hlsearch
set shiftwidth=4
set shiftround
set smartindent
set smarttab
set softtabstop=4
set tabstop=8
set formatoptions=croqln

set background=light

" allows buffers to stick around w/o windows, even outside of files
set hidden

colorscheme desert
hi SpecialKey ctermfg=red ctermbg=yellow

syntax on

let g:rtp0=split(&rtp,",")[0]

" install/load vundle, then the bundles themselves
silent echom "Loading bundles"
execute "source " . g:rtp0 . "/plug-install.vim"
execute "source " . g:rtp0 . "/plug-bundles.vim"
"execute "source " . g:rtp0 . "/vundle-install.vim"
"execute "source " . g:rtp0 . "/vundle-bundles.vim"

silent echom "Loading keyboard mappings"
execute "source " . g:rtp0 . "/map.vim"

" plugin opts that should follow?
let g:neoterm_position = 'vertical'

" install $RTP/local.vim
if filereadable(g:rtp0 . "/local.vim")
    silent echom "Loading nvim/local"
    execute "source " . g:rtp0 . "/local.vim"
endif
