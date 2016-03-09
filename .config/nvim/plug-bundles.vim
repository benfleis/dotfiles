call plug#begin(g:rtp0 . '/bundles')

" Plugins:
" let Vundle manage Vundle
Plug 'VundleVim/Vundle.vim'

" visual
"Plug 'nanotech/jellybeans.vim'
"Plug 'altercation/vim-colors-solarized.git'
Plug 'bling/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'editorconfig/editorconfig-vim'

" language specific vundles
Plug 'elzr/vim-json'
Plug 'fatih/vim-go'
Plug 'tpope/vim-markdown'
Plug 'moll/vim-node'
Plug 'ternjs/tern_for_vim'
Plug 'rbgrouleff/bclose.vim'
Plug 'avakhov/vim-yaml'

" experimental -- really want smartparens, or some set of plugins that do the
" same.
Plug 'jiangmiao/auto-pairs'

Plug 'Shougo/neocomplete.vim'
Plug 'benekastah/neomake'
Plug 'kassio/neoterm'
Plug 'rking/ag.vim'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

"Plug 'tpope/vim-dispatch'
"Plug 'tpope/vim-abolish'

"Plug 'tsaleh/vim-matchit'
"Plug 'tComment'
"Plug 'ervandew/supertab'
"Plug 'tpope/vim-cucumber'
"Plug 'tpope/vim-haml'
"Plug 'godlygeek/tabular'
"Plug 'jgdavey/tslime.vim'
"Plug 'endwise.vim'
"Plug 'rake.vim'

call plug#end()
