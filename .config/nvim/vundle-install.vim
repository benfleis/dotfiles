" Setting up Vundle - the vim plugin bundler
" https://github.com/arusahni/dotfiles/blob/45c6655d46d1f672cc36f4e81c2a674484739ebc/vimrc#L42
let g:vundle_installed=1
let s:bundle_path=g:rtp0 . '/bundle'
let s:vundle_path=s:bundle_path . '/Vundle.vim'
let s:vundle_readme=s:vundle_path . '/README.md'
if !filereadable(s:vundle_readme)
    echo "Installing Vundle..."
    call mkdir(s:bundle_path, "p")
    execute "!git clone https://github.com/VundleVim/Vundle.vim.git " . s:vundle_path
    let g:vundle_installed=0
endif
let &rtp = &rtp . ',' . s:vundle_path
call vundle#rc(s:bundle_path)
