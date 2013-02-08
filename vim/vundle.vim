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
Bundle 'repos-scala/scala-vundle'

" Colorschemes
Bundle 'nanotech/jellybeans.vim'

" status line awesomeness
Bundle 'Lokaltog/vim-powerline'
"Bundle 'Lokaltog/powerline'  - future version, beta?

Bundle 'tpope/vim-fugitive'
Bundle 'tsaleh/vim-matchit'
Bundle 'jgdavey/tslime.vim'

"Bundle 'ack.vim'
"Bundle 'tsaleh/vim-matchit'
"Bundle 'tComment'
"Bundle 'Lokaltog/vim-powerline'
"Bundle 'ervandew/supertab'
"Bundle 'tpope/vim-cucumber'
"Bundle 'tpope/vim-haml'
"Bundle 'tpope/vim-rails'
"Bundle 'vim-ruby/vim-ruby'
"Bundle 'godlygeek/tabular'
"Bundle 'jgdavey/tslime.vim'
"Bundle 'endwise.vim'
"Bundle 'rake.vim'
"Bundle 'kien/ctrlp.vim'
