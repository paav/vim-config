" vim:sw=4 sts=4 fdm=marker fdl=1 

" SECTION: Vundle {{{
"==============================================================================

set nocompatible

filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
"Plugin 'Valloric/YouCompleteMe'
"Plugin 'Shougo/neocomplcache.vim'
"Plugin 'flazz/vim-colorschemes'
"Plugin 'itchyny/lightline.vim'
"Plugin 'skammer/vim-css-color'
"Plugin 'othree/vim-autocomplpop'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'othree/javascript-libraries-syntax.vim'
Plugin 'groenewege/vim-less'
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/syntastic'
Plugin 'gregsexton/MatchTag'
Plugin 'vim-scripts/matchit.zip'
Plugin 'vim-scripts/AutoComplPop'
Plugin 'othree/html5.vim'
Plugin 'Lokaltog/vim-distinguished'
Plugin 'tpope/vim-surround'
Plugin 'mattn/emmet-vim'
Plugin 'tpope/vim-fugitive'
Plugin 'eparreno/vim-l9'
Plugin 'danro/rename.vim'
Plugin 'tpope/vim-unimpaired'
Plugin 'bling/vim-airline'
Plugin 'nanotech/jellybeans.vim'
Plugin 'godlygeek/tabular'
"Plugin 'amiorin/vim-project'
"Plugin 'Lokaltog/vim-easymotion'
Plugin 'justinmk/vim-sneak'
"Plugin 'vim-scripts/guicolorscheme.vim'
Plugin 'vim-scripts/swap-parameters'
Plugin 'vim-scripts/Gundo'
Plugin 'tpope/vim-repeat'
Plugin 'svermeulen/vim-easyclip'
Plugin 'altercation/vim-colors-solarized' "Apply solarized term colors before

"Plugin 'vim-todo', {'pinned': 1}
"#plugins

call vundle#end()

filetype plugin indent on

" }}}


" SECTION: Functions {{{
"==============================================================================

function! NerdTreeToggle()
    if nerdtree#isTreeOpen()
        NERDTreeClose
    else
        NERDTree
    endif
endfunction

let g:isLeavedBufNerd = 0

function! NerdTreeCWD()
    if g:isLeavedBufNerd == 1
        let g:isLeavedBufNerd = 0
        return
    endif

    if nerdtree#isTreeOpen()
        NERDTreeCWD
        wincmd p 
    endif
endfunction

function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

" Miximizes current window height and restores previous value
function! MaximizeWin()
    if !exists('g:winIsMaximized')
        let g:restoreWinCmd = winrestcmd()
        wincmd _
        wincmd |
        let g:winIsMaximized = 1

    else
        exe g:restoreWinCmd
        unlet g:winIsMaximized g:restoreWinCmd

    endif

endfunction    

function! <SID>Replace(search, ...) range
    let replace = a:0 > 0 ? a:1 : '' 
    let range = a:firstline . ',' . a:lastline 
    let command = 's/\V' . a:search .'/' . replace .'/g'

    silent! exe range . command 
endfunction

"#functions
" }}}

filetype plugin on
syntax on

" change the mapleader from \ to ,
let mapleader = ","


" SECTION: Autocommands {{{
"==============================================================================

augroup common
    "Remove all autocommands
    autocmd!

    autocmd BufRead,BufNewFile *.jshintrc set filetype=json
    autocmd Filetype json,html,htmlphp,javascript,css,less
        \ setlocal ts=2 sts=2 sw=2
    autocmd Filetype vim,php setlocal ts=4 sts=4 sw=4
    autocmd Filetype text setlocal textwidth=80

    " Don't insert comment after hitting 'o'
    autocmd Filetype * setlocal formatoptions-=o
    "autocmds
augroup END

" }}}

command! -range -nargs=* Replace <line1>,<line2>call <SID>Replace(<f-args>) 


" SECTION: Options {{{
"=============================================================================

set colorcolumn=81
set ts=4 sts=4 sw=4
set expandtab
set omnifunc=syntaxcomplete#Complete
set number
set foldcolumn=1
set smartindent
set wildmode=longest,list,full
set wildmenu
set nobackup
set nowritebackup
set hidden
" ignore case if search pattern is all lowercase, case-sensitive otherwise
set ignorecase
set smartcase
"set hlsearch      " highlight search terms
set incsearch     " show search matches as you type
set title         " change the terminal's title
set showcmd       " e.g. to show number of chars in selection
set clipboard=unnamed,unnamedplus
set pastetoggle=<F2>
set background=dark

colorscheme solarized

" }}}


" SECTION: Mappings {{{
"==============================================================================

" Misc
" ----------------------

noremap ; :

nnoremap <leader>v :tabe $MYVIMRC<CR>
nnoremap <leader>t :tabe ~/docs/mastery-job.txt<CR>
nnoremap <leader>n :tabe ~/projects/vim-config/_vim/doc/notes.txt<CR>

nnoremap <leader>s :so %<CR>

nmap <leader>l :set list!<CR>
nnoremap <silent> ,/ :nohlsearch<CR>


" Editings
" ----------------------

nnoremap <silent> <F5> :call <SID>StripTrailingWhitespaces()<CR>

" Insert empty line above or below
nnoremap j o<Esc>k
nnoremap k O<Esc>j

" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e
" " Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv
nnoremap L J

nnoremap <leader>r :Replace<Space>
vnoremap <leader>r :Replace<Space>

"cnoremap $t <CR>:t''<CR>
"cnoremap $T <CR>:T''<CR>
"cnoremap $m <CR>:m''<CR>
"cnoremap $M <CR>:M''<CR>
"cnoremap $d <CR>:d<CR>``


" Moving around
"-------------------

nnoremap l ;
nnoremap h ,

" Scroll n lines up/down
nnoremap _ H5k
nnoremap - L5j
"#mappings


" Buffers, windows, tabs
" ---------------------------------

nnoremap w :bd<CR> 
nnoremap <leader>x <C-w>n<C-w>w:bd #<CR>
" Nex/prev buffer
nnoremap K :bnext<CR>
nnoremap J :bprevious<CR>
noremap <silent> <C-W>m :call MaximizeWin()<CR>

" Moving between windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Tabs
nnoremap <Tab> gt
nnoremap <S-Tab> gT
nnoremap g1 1gt
nnoremap g2 2gt
nnoremap g3 3gt
nnoremap g4 4gt
nnoremap g5 5gt
nnoremap g6 6gt
nnoremap g0 :tablast<CR>


" Plugin mappings
" ---------------------

" Sneak
nmap <Space> <Plug>Sneak_s
nmap H <Plug>Sneak_S
xmap <Space> <Plug>Sneak_s
xmap H <Plug>Sneak_S

" Gundo
nnoremap <F5> :GundoToggle<CR>

" easyclip
nmap <F6> <Plug>PasteToggle
imap <F6> <Plug>PasteToggle

" }}}


" SECTION: Plugins {{{
"==============================================================================

" NerdTree
"

let g:NERDTreeWinPos = "right"
" Toggle NerdTree with Ctrl-n
"noremap <C-n> :call NerdTreeToggle()<CR>
nnoremap <silent> <C-n> :NERDTreeToggle<CR>


" YouCompleteMe
"
let g:ycm_collect_identifiers_from_comments_and_strings = 1
"let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_semantic_triggers =  {
\   'c' : ['->', '.'],
\   'objc' : ['->', '.'],
\   'ocaml' : ['.', '#'],
\   'cpp,objcpp' : ['->', '.', '::'],
\   'perl' : ['->'],
\   'php' : ['->', '::'],
\   'cs,java,javascript,d,python,perl6,scala,vb,elixir,go' : ['.'],
\   'vim' : ['re![_a-zA-Z]+[_\w]*\.'],
\   'ruby' : ['.', '::'],
\   'lua' : ['.', ':'],
\   'erlang' : [':'],
\   'htmlphp' : ['<', 're!<[^>]+ '],
\   'less' : [': ', '!'],
\ }


" CtrlP
"

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_by_filename = 1


" Vim-airline
"

let g:airline_powerline_fonts = 1
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
"let g:airline_theme='jellybeans'


" Vim-lightline
"
"let g:lightline = {
      "\ 'colorscheme': 'wombat',
      "\ 'component': {
      "\   'readonly': '%{&readonly?"":""}',
      "\ },
      "\ 'separator': { 'left': '', 'right': '' },
      "\ 'subseparator': { 'left': '', 'right': '' }
      "\ }


" Syntastic
"

" Html5 syntax checker
let g:syntastic_html_tidy_exec = '/usr/bin/tidy'
"let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_lisd = 1
let g:syntastic_loc_list_height = 5


" NerdCommenter
"

let g:NERDCustomDelimiters = {
    \'htmlphp': {
        \'leftAlt': '/*',
        \'rightAlt': '*/',
        \'left': '<?php /*',
        \'right': '*/ ?>'
    \},
\} 


" Vim-fugitive
"

set diffopt+=vertical


" Vim-project
"

"let g:project_use_nerdtree = 1
"set rtp+=~/.vim/bundle/vim-project/
"call project#rc('~/www')

"Project 'image-upload'
"Project 'calendar'
"Project 'expenses'
"Project '~/www/expenses/protected/extensions/paavtable'
"Project '~/www/expenses/protected/extensions/paavtable/vendor/paavpager'
"Project '~/www/expenses/protected/extensions/paavpager'

" Vim-easymotion
"

"let g:EasyMotion_do_mapping = 0

"nmap s <Plug>(easymotion-s)
"nmap s <Plug>(easymotion-s2)

"let g:EasyMotion_smartcase = 1

"map <Leader>j <Plug>(easymotion-j)
"map <Leader>k <Plug>(easymotion-k)


" vim-sneak
"

let g:sneak#s_next = 1
let g:sneak#use_ic_scs = 1


" easyclip
"

let g:EasyClipAlwaysMoveCursorToEndOfPaste = 1

" }}}

