nnoremap <leader>bn :bnext<cr>
nnoremap <leader>bp :bprev<cr>
nnoremap <leader>bN :enew<cr>
nnoremap <leader>bV :vnew<cr>
nnoremap <leader>bS :new<cr>

" Like `:o` but for buffers
command! BufOnly exe '%bdelete|edit #|normal `"'
nnoremap <leader>bo :BufOnly<cr>
 
nnoremap <leader>, :b<space>
