call plug#begin()

" everything seems to use this.
Plug 'nvim-lua/plenary.nvim'

" dev core: telescope, find, git, etc
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
    " treesitter: We recommend updating the parsers on update
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim'
Plug 'TimUntersberger/neogit'

" Plugins:
" visual
Plug 'lifepillar/vim-solarized8'
Plug 'NLKNguyen/papercolor-theme'
Plug 'arcticicestudio/nord-vim'

"Plug 'nanotech/jellybeans.vim'
"Plug 'altercation/vim-colors-solarized.git'
"Plug 'bling/vim-airline'
"Plug 'airblade/vim-gitgutter'
"Plug 'chriskempson/base16-vim'
"Plug 'Yggdroot/indentLine'

" "correct" buffer close behavior, simple & essential
Plug 'rbgrouleff/bclose.vim'

" focus mode
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

" ----------------------------------------------------------

" Experiments
" Plug 'vimwiki/vimwiki'
Plug 'kristijanhusak/orgmode.nvim'

Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes'

" new focus
Plug 'folke/zen-mode.nvim'

" new org mode neorg
Plug 'nvim-neorg/neorg'
Plug 'nvim-neorg/neorg-telescope'

" treesitter playground
Plug 'nvim-treesitter/playground'


" ----------------------------------------------------------
" Everything below is old and awaiting a short try-or-prune.
"

" config
"Plug 'editorconfig/editorconfig-vim'
"Plug 'gerw/vim-HiLinkTrace'

" fzf
"Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
"Plug 'junegunn/fzf.vim'

" motion
"Plug 'easymotion/vim-easymotion'

" language specific vundles
"Plug 'avakhov/vim-yaml'
"Plug 'elzr/vim-json'
"Plug 'fatih/vim-go'
"Plug 'moll/vim-node'
"Plug 'ternjs/tern_for_vim'
" Plug 'jelera/vim-javascript-syntax'
"Plug 'pangloss/vim-javascript'
"Plug 'solarnz/thrift.vim'
"Plug 'gabrielelana/vim-markdown'
"Plug 'elubow/cql-vim'
"Plug 'artur-shaik/vim-javacomplete2'

" experimental -- really want smartparens, or some set of plugins that do the
" same.
" Plug 'jiangmiao/auto-pairs'
" Plug 'snoe/nvim-parinfer.js'


"Plug 'tpope/vim-vinegar'
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"Plug 'benekastah/neomake'
"Plug 'kassio/neoterm'
"Plug 'scrooloose/syntastic'
"Plug 'tpope/vim-fugitive'
"Plug 'tpope/vim-repeat'
"Plug 'tpope/vim-surround'
"Plug 'mhinz/vim-grepper'


"Plug 'reedes/vim-colors-pencil'
"Plug 'subnut/vim-iawriter'

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
