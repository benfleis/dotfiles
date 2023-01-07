" see :help 43.2 for this filetype strategy

if exists("custom_filetypes_loaded")
    finish
endif

augroup filetypedetect
    autocmd! BufRead,BufNewFile *.jsonnet.TEMPLATE  setfiletype jsonnet
augroup END

