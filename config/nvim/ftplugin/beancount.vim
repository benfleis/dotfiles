set iskeyword+=:

" let b:beancount_root=$LEDGERS_HOME/main.bean

" find next singleton lines (thus, unallocated)
nnoremap <LocalLeader>e1 /^20.*\n  [^ ].*\n\n<CR>

" find next line with triple allocation and 2x assets (pattern from
" smart_importer mistakes)
nnoremap <LocalLeader>e3 /^20.*\n.*Assets.*\n.*\n.*Assets<CR>

" find entry no-payee
nnoremap <LocalLeader>enp /^20.*\s\+[*a-zA-Z!]\s\+"[^"]*"\s*[^"]*$<CR>

" find entry with payee
nnoremap <LocalLeader>ewp /^20.*\s\+[*a-zA-Z!]\s\+"[^"]*"\s\+"[^"]*"<CR>

" copy category into $LEDGERS_HOME/accounts.beancount
nnoremap <LocalLeader>pI yiw1G}o1970-01-01 open p EUR,USD
