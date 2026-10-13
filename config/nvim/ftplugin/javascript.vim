" REPLy bindings for JS
map <Leader>rs !Tnew node

" specific helpers
let b:debugger_line='debugger;'
let g:syntastic_javascript_checkers = ['standard']

" fake tag stack with terndef
nnoremap <C-]> :TernDef<CR>
nnoremap <C-t> <C-o>

" experimental
let g:javascript_conceal_function       = "ƒ"
let g:javascript_conceal_null           = "ø"
let g:javascript_conceal_this           = "@"
" let g:javascript_conceal_return         = "⇚"
let g:javascript_conceal_undefined      = "¿"
let g:javascript_conceal_NaN            = "ℕ"
let g:javascript_conceal_prototype      = "¶"
let g:javascript_conceal_static         = "•"
" let g:javascript_conceal_super          = "Ω"
" let g:javascript_conceal_arrow_function = "⇒"
