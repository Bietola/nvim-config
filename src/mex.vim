" Shitty script to emulate some excel action

" TODO: Make this work
" `~/bin/yexp` script required
" if !exists("~/bin/yexp")
"     echom "Error: ~/bin/yexp script required"
" endif

source ./funutils.vim

"""""""""
" Utils "
"""""""""

" Search and jump to first element
fun! MexGrep(pattern)
    cclose

    " TODO: Uncomment this when solving `TODO/SU/neovim/0`
    " exe 'grep -B 1' a:pattern '##'

    exe 'grep' a:pattern '##'

    cope

    " Jump to first entry
    if !empty(getqflist())
        cfirst
    endif

    " TODO: Make this work
    " vim_addon_qf_layout#Quickfix()
endfun
command! -nargs=* MexGrep call MexGrep(<f-args>)

""""""""""""""""""""""""""""
" Open Important Max Paths "
""""""""""""""""""""""""""""

fun! OpenMexMain()
    cd ~/life/mex/main

    " NB. for `vimgrep PAT ##` to work properly
    args **
endfun
command! OpenMexMain call OpenMexMain()

nnoremap <leader>oM :call OpenMexMain()<cr>

"""""""""""""""""""""""""""""""""""""""""""""""
" Interoperability w/ Mex Expression Language "
"""""""""""""""""""""""""""""""""""""""""""""""

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

fun! MexRcloneSyncFetch()
    !rclone sync -P -L
        \ rem:main/life/mex/ ~/sync/life/mex/
endfun

au filetype mex nnoremap <localleader>rs :call MexRcloneSyncAll()<cr>

" fast

fun! MexRcloneSyncMain()
    !rclone sync --create-empty-src-dirs -P -L
        \ ~/sync/life/mex/main rem:main/life/mex/main
endfun

au filetype mex nnoremap <localleader>rf :call MexRcloneSyncMain()<cr>

" Quickly sync main folder everywhere with single mapping

fun! MexQuickSync(commit_msg, do_amend = v:false)
    call GitQuickCommitAll(a:commit_msg, a:do_amend)

    if a:do_amend
        G p -f
    else
        G p
    endif

    call MexRcloneSyncMain()
endfun

au filetype mex nnoremap <localleader>s1 :call MexQuickSync('Initial')<cr>
au filetype mex nnoremap <localleader>s2 :call MexQuickSync('Update')<cr>
au filetype mex nnoremap <localleader>s3 :call MexQuickSync('Final')<cr>
au filetype mex nnoremap <localleader>sa :call MexQuickSync('', v:true)<cr>
au filetype mex nnoremap <localleader>sf :!rclone sync -P -L rem:main/life/mex/main/ ~/sync/life/mex/main/<cr>
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
au filetype mex nnoremap <localleader>x :.s/\[.\{-}\]/\= CycleCross(submatch(0))/<cr>

"""""""""
" Lists "
"""""""""

" Sort Quickfix List according to scheduled dates
fun! SortSchedQFList()
    let l:date_re = 'sched:\s*\(.\{-}\)\(;\|\s\|\n\|$\)'

    fun! Comp(lhs, rhs) closure

        let lhs_d = get(matchlist(a:lhs.text, l:date_re), 1, 'NOSCHED')
        let rhs_d = get(matchlist(a:rhs.text, l:date_re), 1, 'NOSCHED')

        if lhs_d ==# rhs_d
            return 0
        else
            return lhs_d > rhs_d ? 1 : -1
        endif
        
    endfun

    " fun! FmtListEntry(entry) closure
    "     let l:dummy_lst = [get(matchlist(a:entry, l:date_re), 1, 'NODATE') . ':' . 'TEST DESCRIPTION']
    "     call tabular#TabularizeStrings(l:dummy_lst, ':', 'l0')
    "     return l:dummy_lst[0]
    " endfun

    " call setqflist(Map(
    "     \ { d -> DictModField(d, 'text',
    "         \ funcref('FmtListEntry')
    "     \ )},
    "     \ sort(copy(getqflist()), funcref('Comp'))
    " \ ))

    let l:qfl = copy(getqflist())

    let l:qfl = Filter(
        \ { v -> v['valid'] && match(v['text'], l:date_re) >= 0 },
        \ l:qfl
    \ )

    " echom 'fqfl:' l:qfl

    let l:qfl = sort(copy(l:qfl), funcref('Comp'))

    let l:txt_entries = Map({ d -> d['text'] }, l:qfl)

    " echom 'txt' l:txt_entries

    let l:txt_entries = Map(
        \ { v -> get(matchlist(v, l:date_re), 1, 'NODATE') . '|' . 'WIP' },
        \ l:txt_entries
    \ )

    " echom 'ptxt:' l:txt_entries

    call tabular#TabularizeStrings(l:txt_entries, '|', 'l1')

    " echom 'ftxt:' l:txt_entries

    let l:qfl = Map(
        \ { tpl -> DictSetField(tpl[0], 'text', tpl[1]) },
        \ Zip(l:qfl, l:txt_entries)
    \ )

    " echom Map({ v -> get(v, 'text') }, l:qfl)
    
    call setqflist(l:qfl)
endfun

" List any pattern
fun! MexListPatterns(pattern)
    exe 'MexGrep' a:pattern
endfun
command! -nargs=1 MexListPatterns call MexListPatterns(<f-args>)
au filetype mex nnoremap <localleader>lp :MexListPatterns<space>

" List scheduled events
fun! MexListScheduledEvents()
    MexGrep sched:
    call SortSchedQFList()

    " Hack needed to refresh the qf list so that `vim_addon_qf_layout` formats
    " the list again after `SortSchedQFList`
    "
    " See: https://github.com/MarcWeber/vim-addon-qf-layout/issues/8
    "
    " TODO: Find a non-hacky way
    cclose | cope | cfirst
endfun
command! MexListScheduledEvents call MexListScheduledEvents()
au filetype mex nnoremap <localleader>ls :MexListScheduledEvents<cr>

" List headers
fun! MexListHeaders(pattern)
    exe 'MexGrep' '\s*' . a:pattern . '.*:$'
endfun
command! -nargs=* MexListHeaders call MexListHeaders(<f-args>)
au filetype mex nnoremap <localleader>lh :MexListHeaders<space>
