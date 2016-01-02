" Setting up Vundle - the vim plugin bundler
" https://github.com/arusahni/dotfiles/blob/45c6655d46d1f672cc36f4e81c2a674484739ebc/vimrc#L42
let vundle_installed=1
let vundle_readme=g:rtp0 . '/bundle/vundle/README.md'
if !filereadable(vundle_readme)
    echo "Installing Vundle..."
    call mkdir(g:rtp0 . '/bundle', "p")
    execute "!git clone https://github.com/gmarik/vundle " . g:rtp0 . "/bundle/vundle"
    let vundle_installed=0
endif
let &rtp = &rtp . ',' . g:rtp0 . '/bundle/vundle/'
call vundle#rc(g:rtp0 . '/bundle')
