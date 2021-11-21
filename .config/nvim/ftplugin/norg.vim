" Edit Next/Previous Weekday (also if it doesn't exist)
nnoremap <LocalLeader>en <cmd>lua require('journal').edit_next_weekday_from_path()<CR>
nnoremap <LocalLeader>ep <cmd>lua require('journal').edit_previous_weekday_from_path()<CR>

" Find Next/Previous (existing) journal entry
nnoremap <LocalLeader>fp <cmd>lua require('journal').find_previous_entry()<CR>
nnoremap <LocalLeader>fn <cmd>lua require('journal').find_next_entry()<CR>
