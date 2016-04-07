" -lalways use utf8
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
" according to smartindent help, this makes comments align as i wish
inoremap # X#

" visual/window
set cursorline                          " experimental
set fillchars+=stlnc:-,stl:\>
set highlight=su,Su
set laststatus=2
set list listchars=tab:»·,trail:·
set modeline
"set mouse=a
set ruler
set scrolloff=2
set shortmess=aoOtTI
set showcmd
set showmode
set visualbell
set textwidth=79
set nowrap

set noshowmatch
set notitle

set t_Co=256
set background=dark
colorscheme desert
hi SpecialKey ctermfg=red ctermbg=yellow


" disable search highlighting, enable incremental searching
set incsearch

" wild opts
set wildignore=*.o,*.obj,.svn,CVS,.git,*.a,*.so,*.obj,*.class,*.swp
"set wildmode=list:full
set wildmenu

" configure backups to all go into /tmp/ben/.backup
set backup
set backupdir=/tmp/.backup,~/.backup,./.backup,.
set writebackup

" set grep/make progs.  this could be smarter, but sufficient for now
set grepprg=scgrep\ -n

if $TMUX == ''
    set clipboard=unnamed
endif
set hidden

" Persistent undo
if version >= 730
    set undofile " Create FILE.un~ files for persistent undo
    silent !mkdir ~/.vim/undodir > /dev/null 2>&1
    set undodir=~/.vim/undodir
endif

set splitbelow splitright
set tags=tags;/


" extend matching?  still trying
runtime macros/matchit.vim

"------------------------------------------------------------------------------

" XXX temporary, move me to .vim/status.vim
"python from powerline.vim import setup as powerline_setup
"python powerline_setup()
"python del powerline_setup
"set rtp+=~/Library/Python/2.7/lib/python/site-packages/powerline/bindings/vim

" load order not accidental here -- functions first, maps last
source $HOME/.vim/pre.vim
source $HOME/.vim/vundle.vim
source $HOME/.vim/functions.vim
source $HOME/.vim/autocommand.vim
source $HOME/.vim/map.vim
source $HOME/.vim/post.vim

" load bundle opts here.  always wrap them in conditionals.
if exists('g:Powerline_loaded') && g:Powerline_loaded
    let g:Powerline_symbols = 'unicode'
    let g:Powerline_colorscheme = 'solarized256'
    let g:Powerline_theme = 'solarized256'
endif

" load .vimrc-local if it can be found
if filereadable($HOME . "/.vim/local")
    echo "Loading .vim/local"
    execute "source " . $HOME . "/.vim/local"
endif
