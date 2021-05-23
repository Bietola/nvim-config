" Shitty script to emulate some excel action

" TODO: Make this work
" `~/bin/yexp` script required
" if !exists("~/bin/yexp")
"     echom "Error: ~/bin/yexp script required"
" endif

" Process file with mex
function MexStep()
  normal mm
  execute join(["%!mex 2>", expand("%:p:h"), "/mex-err"], "")
  normal 'mf>w
  normal zz
endfunction
command! MexStep call MexStep()

" Change control character
function MexSetCC(cc)
  execute join([".!awk 'match($0, /^(.*):.>(.*)/, m) { print m[1] \":", a:cc, ">\" m[2] }'"], "")
endfunction

" Set .mex files to be mex files
au BufNewFile,BufRead *.mex :set filetype=mex

" Indentation
au filetype mex set foldmethod=indent

" Local leader
au filetype mex let maplocalleader = 'ò'

" Mappings
" TODO: Make <localleader> work here
au filetype mex nnoremap <localleader>u :call MexStep()<cr>
au filetype mex nnoremap <localleader>ce :call MexSetCC('E')<cr>f>w
au filetype mex nnoremap <localleader>cE :%s/:.*>/:E>/g<cr>:nohlsearch<cr>
au filetype mex nnoremap <localleader>cc :call MexSetCC('E')<cr>f>w:MexStep<cr>
au filetype mex nnoremap <localleader>cC :%s/:.*>/:E>/g<cr>:nohlsearch<cr>:MexStep<cr>
au filetype mex nnoremap <localleader>cv :call MexSetCC('$')<cr>f>w
au filetype mex nnoremap <localleader>cs :call MexSetCC('S')<cr>f>w

" Tabular mappings
func! TabularizeMexSchedule()
    " TODO: Make this ignore the first header line with a colon at the end.
    " TODO: This doesn't seem to work:
    " Tabularize /^.*\zs:\n\@!/l1c1l0
    "                    ^^^^^

    " Last colon (first is for timestamps)
    Tabularize /^.*\zs:/l1c1l0

    " First comma (why first? no reason...)
    Tabularize /^[^,]*\zs,/l1c1l0
endfunc

" TODO: Make this ignore the first header line with a colon at the end...
au filetype mex nnoremap <localleader>t :call TabularizeMexSchedule()<cr>

"""""""""""""""""""
" Synchronization "
"""""""""""""""""""

" Git mappings
" TODO: Might have problems/ambiguities with symlinks
fun! GitQuickCommitAll(msg, do_amend = v:false)
    Git add -A
    if a:do_amend
        exe 'Git commit --amend --no-edit'
    else
        exe 'Git commit -m' a:msg
    endif
endfun

au filetype mex nnoremap <localleader>g1 :call GitQuickCommitAll('Initial')<cr>
au filetype mex nnoremap <localleader>g2 :call GitQuickCommitAll('Update')<cr>
au filetype mex nnoremap <localleader>g3 :call GitQuickCommitAll('Final')<cr>
au filetype mex nnoremap <localleader>ga :Git commit --amend --no-edit<cr>

"" rclone mappings

" slow

fun! MexRcloneSyncAll()
    !rclone sync --create-empty-src-dirs -P -L
        \ ~/sync/life/mex/ rem:main/life/mex/
endfun

au filetype mex nnoremap <localleader>rs :call MexRcloneSyncAll()<cr>

" fast

fun! MexRcloneSyncPlan()
    !rclone sync --create-empty-src-dirs -P -L
        \ ~/sync/life/mex/plan.mex rem:main/life/mex/
endfun

au filetype mex nnoremap <localleader>rf :call MexRcloneSyncPlan()<cr>

" Quickly sync plan file everywhere with single mapping

fun! MexQuickSync(commit_msg, do_amend = v:false)
    call GitQuickCommitAll(a:commit_msg, a:do_amend)

    if a:do_amend
        G p -f
    else
        G p
    endif

    call MexRcloneSyncPlan()
endfun

au filetype mex nnoremap <localleader>s1 :call MexQuickSync('Initial')<cr>
au filetype mex nnoremap <localleader>s2 :call MexQuickSync('Update')<cr>
au filetype mex nnoremap <localleader>s3 :call MexQuickSync('Final')<cr>
au filetype mex nnoremap <localleader>sa :call MexQuickSync('', v:true)<cr>
" TODO: Implement the mapping below using a vim prompt thingy life in
" vim-surround's `s**f`
" au filetype mex nnoremap <localleader>sm :call MexQuickSync('...')<cr>

""""""""""""""
" Todo Lists "
""""""""""""""

" Cross things out
fun! CycleCross(cross_box)
    if a:cross_box ==# '[X]'
        return '[ ]'
    elseif a:cross_box ==# '[ ]'
        return '[X]'
    else
        return '[ ]'
    endif
endfun
au filetype mex nnoremap <localleader>x :.s/\[.\{-}\]/\= CycleCross(submatch(0))/g<cr>
