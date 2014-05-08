" Vundle; see https://github.com/gmarik/vundle
" To install, run :BundleInstall
" To update, run :BundleInstall!
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Bundles:
" let Vundle manage Vundle
Bundle 'gmarik/vundle'

" language specific vundles
Bundle 'vim-scripts/vim-json-bundle'
"Bundle 'repos-scala/scala-vundle'
Bundle 'derekwyatt/vim-scala'
Bundle 'davidoc/taskpaper.vim'
Bundle 'ktvoelker/sbt-vim.git'
Bundle 'kchmck/vim-coffee-script'
Bundle 'plasticboy/vim-markdown'
Bundle 'jnwhiteh/vim-golang'

" Colorschemes
Bundle 'nanotech/jellybeans.vim'
Bundle 'altercation/vim-colors-solarized.git'

" status line awesomeness
Bundle 'Lokaltog/vim-powerline'
"Bundle 'Lokaltog/powerline'  - future version, beta?

"Bundle 'Shougo/neocomplete.vim'
Bundle 'tpope/vim-fugitive'
" rather not have vcscommand AND fugitive, but I want sth for svn
Bundle 'vim-scripts/vcscommand.vim'
Bundle 'tsaleh/vim-matchit'
Bundle 'jgdavey/tslime.vim'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-dispatch'
Bundle 'tpope/vim-abolish'
"Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
"Bundle 'llvm-mirror/lldb', {'rtp': 'utils/vim-lldb'}

"Bundle 'ack.vim'
"Bundle 'tsaleh/vim-matchit'
"Bundle 'tComment'
"Bundle 'Lokaltog/vim-powerline'
"Bundle 'ervandew/supertab'
"Bundle 'tpope/vim-cucumber'
"Bundle 'tpope/vim-haml'
"Bundle 'godlygeek/tabular'
"Bundle 'jgdavey/tslime.vim'
"Bundle 'endwise.vim'
"Bundle 'rake.vim'
"Bundle 'kien/ctrlp.vim'
