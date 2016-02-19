" Vundle; see https://github.com/gmarik/vundle
filetype off
call vundle#begin()

" Plugins:
" let Vundle manage Vundle
Plugin 'VundleVim/Vundle.vim'

" visual
"Plugin 'nanotech/jellybeans.vim'
"Plugin 'altercation/vim-colors-solarized.git'
Plugin 'bling/vim-airline'
Plugin 'airblade/vim-gitgutter'
Plugin 'editorconfig/editorconfig-vim'

" language specific vundles
Plugin 'elzr/vim-json'
"Plugin 'vim-scripts/vim-json-bundle'
"Plugin 'derekwyatt/vim-scala'
"Plugin 'davidoc/taskpaper.vim'
"Plugin 'ktvoelker/sbt-vim.git'
"Plugin 'kchmck/vim-coffee-script'
Plugin 'jnwhiteh/vim-golang'
Plugin 'tpope/vim-markdown'
Plugin 'moll/vim-node'
Plugin 'ternjs/tern_for_vim'
Plugin 'rbgrouleff/bclose.vim'

" experimental -- really want smartparens, or some set of plugins that do the
" same.
Plugin 'jiangmiao/auto-pairs'

" clojure + repl + leiningen
"Plugin 'guns/vim-clojure-static'
"Plugin 'tpope/vim-fireplace'
"Plugin 'tpope/vim-leiningen'
"Plugin 'kien/rainbow_parentheses.vim'

" status line awesomeness
"Plugin 'Lokaltog/vim-powerline'
"Plugin 'Lokaltog/powerline'  - future version, beta?

Plugin 'benekastah/neomake'
Plugin 'kassio/neoterm'
Plugin 'rking/ag.vim'
Plugin 'Shougo/neocomplete.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'

"Plugin 'jgdavey/tslime.vim'
"Plugin 'tpope/vim-dispatch'
"Plugin 'tpope/vim-abolish'
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
"Plugin 'llvm-mirror/lldb', {'rtp': 'utils/vim-lldb'}

"Plugin 'tsaleh/vim-matchit'
"Plugin 'tComment'
"Plugin 'ervandew/supertab'
"Plugin 'tpope/vim-cucumber'
"Plugin 'tpope/vim-haml'
"Plugin 'godlygeek/tabular'
"Plugin 'jgdavey/tslime.vim'
"Plugin 'endwise.vim'
"Plugin 'rake.vim'

call vundle#end()
filetype plugin indent on
