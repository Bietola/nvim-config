""""""""""""""""""""""""""""""""""""""
" Things related to tabs and windows "
""""""""""""""""""""""""""""""""""""""

" TODO: Find out wtf this is
" set switchbuf=usetab,newtab
" au TabEnter * if exists("t:wd") | exe "cd" t:wd | endif

" Conveniently create new tabs
nnoremap <leader>gt :tabnew<cr>

" Toggle line wrap
nnoremap <leader>W :set wrap!<cr>
