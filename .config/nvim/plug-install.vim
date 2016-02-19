let s:plug_vim = g:rtp0 . '/autoload/plug.vim'
if empty(glob(s:plug_vim))
  execute '!curl -fLo ' . s:plug_vim . ' --create-dirs' .
    \ ' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall | source g:rtp0 . '/init.vim'
endif
