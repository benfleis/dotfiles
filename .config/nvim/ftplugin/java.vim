setlocal omnifunc=javacomplete#Complete
let g:indentLine_enabled = 1

let g:neomake_java_gradle_maker_args = ['assemble', '-x', 'distZip', '-x', 'distTar', '--daemon']
let g:neomake_gradle_maker_args = ['assemble', '-x', 'distZip', '-x', 'distTar', '--daemon']
let g:neomake_java_enabled_makers = ['gradle']

nnoremap <Leader>cm :Neomake! gradle<CR>
