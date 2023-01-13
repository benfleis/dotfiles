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
Plug 'nvim-treesitter/playground'
" Plug 'TimUntersberger/neogit'
" neogit requires
" Plug 'sindrets/diffview.nvim'


" Plugins:
" visual
Plug 'Yggdroot/indentLine'
Plug 'NLKNguyen/papercolor-theme'
Plug 'arcticicestudio/nord-vim'

" completion: nvim-cmp
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'


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

" lang ++
Plug 'google/vim-jsonnet'

" lang: scala
Plug 'scalameta/nvim-metals'

" lang thrift
Plug 'solarnz/thrift.vim'

" lang clojure
Plug 'clojure-vim/clojure.vim'
Plug 'tpope/vim-dispatch' " required for vim-dispatch-neovim
Plug 'radenling/vim-dispatch-neovim' " required for vim-jack-in
Plug 'clojure-vim/vim-jack-in'
Plug 'Olical/conjure'

" lang fennel -- only for tweaking conjure
Plug 'jaawerth/fennel.vim'
Plug 'Olical/aniseed'

" ----------------------------------------------------------

" Experiments
" Plug 'vimwiki/vimwiki'
" Plug 'kristijanhusak/orgmode.nvim'

" Plug 'xolox/vim-misc'
" Plug 'xolox/vim-notes'

Plug 'sindrets/diffview.nvim'

" new focus
Plug 'folke/zen-mode.nvim'

" new org mode neorg
" Plug 'nvim-neorg/neorg'
" Plug 'nvim-neorg/neorg-telescope'
Plug 'tjdevries/vlog.nvim'

" experiment: coq-nvim
Plug 'neovim/nvim-lspconfig'

" still unhappy w git opts
Plug 'tpope/vim-fugitive' " still blocks/waits
Plug 'lambdalisue/gina.vim'

Plug 'lewis6991/gitsigns.nvim'

" github/gh integrations
Plug 'pwntester/octo.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'skanehira/gh.vim'

" bean-count experiment
Plug 'nathangrigg/vim-beancount'


" beancount
Plug 'nathangrigg/vim-beancount'

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
