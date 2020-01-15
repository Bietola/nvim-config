"" pathogen (RIP)
" execute pathogen#infect()

" plug init
call plug#begin('~/.local/share/nvim/plugged')

" plugins
Plug 'calincru/flex-bison-syntax'
Plug 'ron-rs/ron.vim'
Plug 'ryanolsonx/vim-lsp-python'
Plug 'thomasfaingnaert/vim-lsp-snippets'
Plug 'thomasfaingnaert/vim-lsp-ultisnips'
Plug 'honza/vim-snippets'
Plug 'alx741/vim-hindent'
Plug 'AndrewRadev/dsf.vim'
Plug 'runoshun/vim-alloy'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'rbgrouleff/bclose.vim'
Plug 'francoiscabrol/ranger.vim'
Plug 'masukomi/vim-markdown-folding'
Plug 'rust-lang/rust.vim'
Plug 'tommcdo/vim-exchange'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'gyim/vim-boxdraw'
Plug 'kana/vim-tabpagecd'
Plug 'Raimondi/delimitMate'
Plug 'szw/vim-tags'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'jpalardy/vim-slime'
Plug 'vim-scripts/DrawIt'
Plug 'AndrewRadev/sideways.vim'
" Plug 'Valloric/YouCompleteMe'
Plug 'SirVer/ultisnips'
Plug 'majutsushi/tagbar'
Plug 'thaerkh/vim-workspace'
Plug 'godlygeek/tabular'
" Plug 'vim-pandoc/vim-pandoc'
" Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'plasticboy/vim-markdown'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'kien/ctrlp.vim'

" programming languages
Plug 'suoto/vim-hdl'
Plug 'vim-perl/vim-perl6'
Plug 'quabug/vim-gdscript'
Plug 'sheerun/vim-polyglot'
"TODO Plug 'vim-syntastic/syntastic'

" utilsnips snippets
Plug 'dawikur/algorithm-mnemonics.vim'

" colorschemes
Plug 'nightsense/carbonized'
Plug 'JarrodCTaylor/spartan'
Plug 'KKPMW/sacredforest-vim'
Plug 'cocopon/iceberg.vim'

" plug deinit
call plug#end()

" vimrc loading stuff
set exrc

" nvim :terminal suff
if has("nvim")
inoremap <ESC> <C-\><C-n>
"! tnoremap jk <C-\><C-n> " RIP (need caps lock for ranger)
endif

" window splitting shortcuuts
noremap <C-w>V <C-w>v<C-w><C-l>
noremap <C-w>S <C-w>s<C-w><C-j>
noremap <C-j> <C-w><C-j>
noremap <C-k> <C-w><C-k>
noremap <C-h> <C-w><C-h>
noremap <C-l> <C-w><C-l>

" window splitting options
set diffopt+=vertical

" file loading stuff
:set autowriteall

" operating system detection variables
if !exists("g:os")
if has("win64") || has("win32") || has("win16")
    let g:os = "Windows"
else
    let g:os = substitute(system('uname'), '\n', '', '')
endif
endif

" operating system make configuration
if g:os == "Windows"
set makeprg=mingw32-make
elseif g:os == "Linux"
set makeprg=make
endif

" operating system cmake configurations
if g:os == "Windows"
command -bar -nargs=1 CMake !cmake -G "MinGW Makefiles" <args>
elseif g:os == "Linux"
command -bar -nargs=1 CMake !cmake  <args>
end

" operating system cmake debug configurations
if g:os == "Windows"
command -bar -nargs=1 DMake !cmake -DCMAKE_BUILD_TYPE=Debug -G "MinGW Makefiles" <args>
elseif g:os == "Linux"
command -bar -nargs=1 DMake !cmake -DCMAKE_BUILD_TYPE=Debug <args>
end

" operating system cmake vcpkg configurations
if g:os == "Linux"
command -bar -nargs=1 VCMake !cmake -DCMAKE_TOOLCHAIN_FILE=/usr/pkg/vcpkg/scripts/buildsystems/vcpkg.cmake <args>
end

" autocomplete settings
set complete-=i
" suggested by mu complete
set completeopt+=menuone
set completeopt+=noselect
set shortmess+=c
set belloff+=ctrlg

" mucompolete-specific settings
let g:mucomplete#enable_auto_at_startup = 1

" leader
let mapleader = "ò"

" useful mappings
nnoremap <S-Enter> O<Esc>
nnoremap <CR> o<Esc>
" tabularize quick mapping
nnoremap <leader>tab :Tabularize 
vnoremap <leader>tab :Tabularize 
" sideways mappings
nnoremap <leader>h :SidewaysLeft<CR>
nnoremap <leader>l :SidewaysRight<CR>
" ultisnips mappings
nnoremap <leader>se :UltiSnipsEdit<CR>

" terminal looks
set background=dark
set termguicolors
colorscheme iceberg
set guifont=Consolas:h17

" tab (those akin to windows...) settings and custom commands
au TabEnter * if exists("t:wd") | exe "cd" t:wd | endif
let g:airline_powerline_fonts = 1

" whitespace (tab/backspace) things
set tabstop=4
set shiftwidth=4
set backspace=indent,eol,start

" default syntax
syntax on
set syntax=cpp
filetype plugin indent on

" ctags and vim-tags settings
let g:vim_tags_auto_generate = 1
let g:vim_tags_directories = [".git/..", ".hg", ".svn", ".bzr", "_darcs", "CVS"]
let g:vim_tags_ignore_files = ['.gitignore', '.svnignore', '.cvsignore']
let g:vim_tags_project_tags_command = "{CTAGS} -R --fields=+l {OPTIONS} {DIRECTORY} 2>/dev/null"

" default path
set path+=../**

" menu options
set wildmenu
set number

" no idea... (should research)
set timeoutlen=10000

" utility remappings
" imap jk <Esc> " RIP (need caps lock for ranger)

" utility commands
command W      set wrap!
command NoWar  set errorformat^=%-G%f:%l:\ warning:%m
command Tgen   cd .. | !ctags -R | cd build
command Comp   !g++ main.cpp -o Proj
command RCEdit edit $MYVIMRC

command Ex  !./Proj
command Tex !/usr/bin/time ./Proj 

"" netrw settings
" Allow netrw to remove non-empty local directories
let g:netrw_localrmdir='rm -r'
autocmd FileType netrw nnoremap ? :help netrw-quickmap<CR>

" TagBar settings
" TODO: nmap <leader><leader> :TagbarToggle<CR><c-w><c-w>

"" YCM things
" commands
command YCMToggleCompletionTrigger :let g:ycm_auto_trigger=!g:ycm_auto_trigger
" settings
let g:enable_ycm_at_startup = 0
let g:ycm_auto_trigger = 0
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_collect_identifiers_from_tags_files = 1

" ultisnips settings
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" TODO: find out better way to do this
" NB. Ultisnips is not compatible with neovim... so we need to use the .vim
" directory
set runtimepath^=~/.vim
let g:UltiSnipsSnippetsDirectories=[$HOME.'/.vim/UltiSnips']

" vim-slime options
let g:slime_target = "neovim"

" delimitMate options
let delimitMate_expand_cr = 1

" markdown mappings  
nnoremap <leader>ft :TableFormat<CR>

" surround mappings
nmap s ys

" markdown settings  
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
let g:markdown_enable_folding = 1

" vim-pandoc settings
"" let g:pandoc#syntax#codeblocks#embeds#langs = ["cpp"]
"let g:pandoc#folding#fold_fenced_codeblocks = 1

" gabrielelana markdown settings
" let g:markdown_enable_folding = 1

" mkdx configuration
" let g:mkdx#settings     = { 'highlight': { 'enable': 1 },
"                         \ 'enter': { 'shift': 1 },
"                         \ 'links': { 'external': { 'enable': 1 } },
"                         \ 'toc': { 'text': 'Table of Contents', 'update_on_write': 1 },
"                         \ 'fold': { 'enable': 1 } }
" let g:polyglot_disabled = ['markdown'] " for vim-polyglot users, it loads Plasticboy's markdown
"                                       " plugin which unfortunately interferes with mkdx list indentation.

" default formatting settings
set expandtab
set tabstop=4
set shiftwidth=4
set sts=4
set autoindent

" tagbar settings for perl6
let g:tagbar_type_perl6 = {
  \ 'ctagstype' : 'perl6',
  \ 'kinds' : [
    \ 'c:classes',
    \ 'g:grammar',
    \ 'm:methods',
    \ 'o:modules',
    \ 'p:packages',
    \ 'r:roles',
    \ 'u:rules',
    \ 'b:submethods',
    \ 's:subroutines',
    \ 't:tokens'
  \ ]
\ }

" c and cpp formatting settings
au FileType cpp,c set expandtab
au FileType cpp,c set tabstop=4
au FileType cpp,c set shiftwidth=4
au FileType cpp,c set sts=4
au FileType cpp,c set autoindent

" MIPS formatting settings
au FileType asm set expandtab
au FileType asm set tabstop=8
au FileType asm set shiftwidth=8
au FileType asm set sts=8
au FileType asm set autoindent

" basic formatting settings
au FileType basic let b:delimitMate_quotes = "\""

" lisp formatting settings
au FileType lisp let b:delimitMate_quotes = "\""
au FileType lisp set expandtab
au FileType lisp set tabstop=2
au FileType lisp set shiftwidth=2

" haskell formatting settings
au FileType haskell set expandtab
au FileType haskell set tabstop=2
au FileType haskell set shiftwidth=2

" racket formatting settings
au FileType racket let b:delimitMate_quotes = "\""

"asdf formatting settings
au BufRead,BufNewFile *.asd set filetype=lisp

" python3 formatting settings
au FileType python set expandtab
au FileType python set tabstop=4
au FileType python set shiftwidth=4
au FileType python set sts=4
au FileType python set autoindent

" LSP settings
if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd', '-background-index']},
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
        autocmd FileType c setlocal omnifunc=lsp#complete
        autocmd FileType cpp setlocal omnifunc=lsp#complete
endif

if executable('rls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
        \ 'workspace_config': {'rust': {'clippy_preference': 'on'}},
        \ 'whitelist': ['rust'],
        \ })
        autocmd FileType rust setlocal omnifunc=lsp#complete
endif

if executable('lua-lsp')
    au User lsp_setup call lsp#register_server({
                \ 'name': 'lua-lsp',
                \ 'cmd': {server_info->[&shell, &shellcmdflag, 'lua-lsp']},
                \ 'whitelist': ['lua'],
                \ })
endif

if executable('vhdl_ls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'vhdl_ls',
        \ 'cmd': {server_info->['vhdl_ls']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'vhdl_ls.toml'))},
        \ 'whitelist': ['vhdl'],
        \ })
endif

"" Haskell specific settings
" Hindent
au filetype haskell let g:hindent_on_save = 0

" utility leader commands
nnoremap <leader>tt :tabnew<cr>:term<cr>
nnoremap <leader>tn :tabnew<cr>

" quick vimgrep command
command -nargs=1 Vimgrep vimgrep <args> ##
" NB: this initialization is customized for different languages
nnoremap <leader>vi :args ./**<cr>
nnoremap <leader>vg :Vimgrep 
nnoremap <leader>v/ :Vimgrep ///g<cr>

" LSP general keybindings
nnoremap <leader>hv :LspHover<cr>
nnoremap <leader>rf :LspReference<cr>
noremap <leader>rn :LspRename<cr>
noremap <leader>fm :RustFmt<cr>
noremap <leader>er :LspDocumentDiagnostics<cr>
noremap <leader>gd :LspDefinition<cr>
noremap <leader>gr :LspReferences<cr>

"" Rust keybindings
" Cargo
au filetype rust nnoremap <leader><leader>r :!cargo run<cr>
au filetype rust nnoremap <leader><leader>t :!cargo test<cr>
" Boxes
au filetype rust vnoremap <leader>b :'<,'>!boxes<cr>
au filetype rust nnoremap <leader>bb V:'<,'>!boxes<cr>
" Other useful keybindings
au filetype rust nnoremap <leader>vi :args src/**<cr>

"" C keybindings
au filetype c inoremap <c-c> <esc>:!gcc main.c<cr>i

"" Racket keybindings
" Slime
au filetype racket nnoremap <leader>tt :vsp<cr>:term racket<cr>:echo b:terminal_job_id<cr><c-w><c-l>
au filetype racket nnoremap <leader>fm :LspDocumentFormat<cr>

"" Haskell keybindings
" Slime
au filetype haskell nnoremap <leader>trw :vsp<cr>:term ghci<cr>:echo b:terminal_job_id<cr><c-w><c-l>
au filetype haskell nnoremap <leader>trt :tabnew<cr>:term ghci<cr>:echo b:terminal_job_id<cr>gT
" Comments
au filetype haskell vnoremap <leader>b :'<,'>!boxes -d ada-box<cr>
au filetype haskell vnoremap <leader>bm V:'<,'>!boxes -m<cr>
au filetype haskell nnoremap <leader>bb V:'<,'>!boxes -d ada-box<cr>
" Automatic formatting
au filetype haskell nnoremap <leader>fm :Hindent<cr>
" Tabular
au filetype haskell nnoremap <leader>t= :Tabular /=<cr>

" Git fugitive custom commands
command GA Git A

" Ranger configuration
let g:ranger_replace_netrw = 1 "open ranger when vim open a directory

" Terminal stuff
tnoremap <Esc> <C-\><C-n>

" Scheme stuff
" Local leader.
autocmd FileType scheme let maplocalleader = "ò"
" TODO: try w/ localleader
nnoremap <leader>a mmggVG:SlimeSend<cr>'m

" Lance stuff
" NB. Lance is an educational language for the Formal Languages course at
" Polimi
autocmd FileType lance set syntax = lua
