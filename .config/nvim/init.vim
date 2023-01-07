" always use utf8
set encoding=utf-8

" terminal Truecolor madness!
set termguicolors
" set Vim-specific sequences for RGB colors -- may be unnecessary in neovim
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" sanity. this ain't vi.
set nocompatible

" better searching
set ignorecase
set smartcase

" tabbing/indenting/formatting
set autoindent
set backspace=2
set cursorline
set expandtab
set formatoptions=croqln
set list

" set listchars=tab:·\ ,eol:¬,trail:»
set listchars=tab:·\ ,trail:»
set fillchars+=vert:\‖

set shortmess-=F

set nohlsearch
set shiftround
set shiftwidth=4
set smartindent
set smarttab
set softtabstop=4
set tabstop=8
set textwidth=80

" allows buffers to stick around w/o windows, even outside of files
set hidden

set diffopt=filler,vertical

syntax on

""
" useful path computations in neovim
" stdpath('config') = $HOME/.config/nvim + '/init.vim'
" stdpath('data') = $HOME/.local/share

" NOTE: if nvim -u BLAHBLAH, could/should grab sibling files from there?
let g:config_path = stdpath('config')	" typ. $HOME/.config/nvim
let g:data_path = stdpath('data')	" typ. $HOME/.local/share/nvim

" source a series of files with a helper
function s:SourceConfig(name, tail)
    let full_path = g:config_path . "/" . a:tail
    if filereadable(full_path)
        silent echo a:name . " @ " . full_path . ": loading"
        execute "source " . full_path
    else
        echom a:name . " @ " . full_path . ": nothing found?!?!"
    endif
endfunction

silent echo "Setting Plugin Config"
let g:indentLine_char = '⦙'

silent echo "Sourcing and Configuring"

let g:plug_home = g:data_path . "/site/pack"
call s:SourceConfig("plugins", "plug-defs.vim")
call s:SourceConfig("key maps", "map.vim")
call s:SourceConfig("focus mode", "focus.vim")

set background=dark
colorscheme PaperColor

"" Load lua, last for now
lua require('benfleis').init()
" lua require('benfleis').setup_coq()
lua require('benfleis').setup_metals()

" lua require('nvim-treesitter.configs').setup{highlight={enable=true}}  " At the bottom of your init.vim, keep all configs on one line
