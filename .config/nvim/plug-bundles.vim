call plug#begin(g:rtp0 . '/bundles')

" Plugins:
" let Vundle manage Vundle
Plug 'VundleVim/Vundle.vim'

" visual
"Plug 'nanotech/jellybeans.vim'
"Plug 'altercation/vim-colors-solarized.git'
Plug 'bling/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'chriskempson/base16-vim'
Plug 'Yggdroot/indentLine'

" config
Plug 'editorconfig/editorconfig-vim'
Plug 'rbgrouleff/bclose.vim'
Plug 'gerw/vim-HiLinkTrace'
" fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" motion
Plug 'easymotion/vim-easymotion'

" language specific vundles
Plug 'elzr/vim-json'
Plug 'fatih/vim-go'
Plug 'moll/vim-node'
Plug 'ternjs/tern_for_vim'
Plug 'avakhov/vim-yaml'
" Plug 'jelera/vim-javascript-syntax'
Plug 'pangloss/vim-javascript'
Plug 'solarnz/thrift.vim'
Plug 'gabrielelana/vim-markdown'
Plug 'elubow/cql-vim'
Plug 'artur-shaik/vim-javacomplete2'

" experimental -- really want smartparens, or some set of plugins that do the
" same.
" Plug 'jiangmiao/auto-pairs'
Plug 'snoe/nvim-parinfer.js'

Plug 'tpope/vim-vinegar'
Plug 'Shougo/deoplete.vim', { 'do': ':UpdateRemotePlugins' }
Plug 'benekastah/neomake'
Plug 'kassio/neoterm'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'mhinz/vim-grepper'

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
