" sanity. this ain't vi.
set nocompatible

" always use utf8
set encoding=utf-8

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

colorscheme desert
hi SpecialKey ctermfg=red ctermbg=yellow

syntax on

let g:rtp0=split(&rtp,",")[0]

" install/load vundle, then the bundles themselves
silent echom "Loading bundles"
execute "source " . g:rtp0 . "/vundle-install.vim"
execute "source " . g:rtp0 . "/vundle-bundles.vim"

silent echom "Loading keyboard mappings"
execute "source " . g:rtp0 . "/map.vim"

" install $RTP/local.vim
if filereadable(g:rtp0 . "/local.vim")
    silent echom "Loading nvim/local"
    execute "source " . g:rtp0 . "/local.vim"
endif

