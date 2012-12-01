" better searching
set ignorecase
set smartcase

" tabbing/indenting/formatting
set autoindent
set backspace=2
set expandtab
set shiftwidth=4
set shiftround
set smartindent
set smarttab
set softtabstop=4
set tabstop=8
set textwidth=79

set nohlsearch

set formatoptions=croqln
" according to smartindent help, this makes comments align as i wish
inoremap # X#

" visual/window
set cursorline                          " experimental
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

set noshowmatch
set notitle

set t_Co=256
colorscheme grb4
set bg=dark
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
set grepprg=scgrep.zsh\ -n

set clipboard=unnamed
set hidden

" Persistent undo
set undofile " Create FILE.un~ files for persistent undo
silent !mkdir ~/.vim/undodir > /dev/null 2>&1
set undodir=~/.vim/undodir

set splitbelow splitright
set tags=tags;/


" extend matching?  still trying
runtime macros/matchit.vim

"------------------------------------------------------------------------------

" load order not accidental here -- functions first, maps last
source $HOME/.vim/vundle.vim
source $HOME/.vim/functions.vim
source $HOME/.vim/autocommand.vim
source $HOME/.vim/map.vim


" load .vimrc-local if it can be found
if filereadable($HOME . "/.vim/local")
    echo "Loading .vim/local"
    execute "source " . $HOME . "/.vim/local"
endif
