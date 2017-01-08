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
Plugin 'michaeljsmith/vim-indent-object'
" Plugin 'vim-todo', {'pinned': 1}
Plugin 'plasticboy/vim-markdown'
Plugin 'raymond-w-ko/vim-lua-indent'
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

function! MakeList() range
    let i = 0

    for linenum in range(a:firstline, a:lastline)
        let line = getline(linenum)

        if line != ''
            let i += 1
            let num = printf('%d. ', i)
            call setline(linenum, num . line)
        endif

    endfor
endfunction

function! NextTabOrBuf()
    if (tabpagenr('$') == 1)
        bn
    else
        tabn
    endif
endfunction

function! PrevTabOrBuf()
    if (tabpagenr('$') == 1)
        bp
    else
        tabp
    endif
endfunction

function! s:InsertDate() abort
    let l:LNUM = 2
    let l:oldline = getline(l:LNUM)

    let l:saved_lang = v:lc_time 
    language time en_US.UTF-8
    let l:timestr = strftime('%Y %b %d')

    if l:oldline !~# l:timestr
        let l:regexp = '\vLast Change:\s+\zs.*'

        let l:newline = substitute(l:oldline, l:regexp, l:timestr, '')
        call setline(l:LNUM, l:newline)
    endif

    exe 'language time ' . l:saved_lang
endfunction

function! s:GotoBufOrWinNum(num) abort
    let notabs = tabpagenr('$') == 1

    if (a:num == '$')
        if (notabs)
            blast
        else
            tablast
        endif

        return
    endif

    if (notabs)
        let bufnrs = []

        for i in range(bufnr('$'))
            let bufnr = i + 1

            if bufexists(bufnr) && buflisted(bufnr) 
                call add(bufnrs, bufnr)
            endif
        endfor

        let buf = get(bufnrs, a:num - 1) 

        try
            exe 'buffer ' . buf 
        catch /^Vim(buffer)/
            echom 'Info: there are only ' . len(bufnrs) . ' listed buffers.'
        endtry
    else
        exe 'tabn ' . a:num
    endif
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
    autocmd Filetype json,html,htmlphp,css,less
        \ setlocal ts=2 sts=2 sw=2
    autocmd Filetype vim,php,python setlocal ts=4 sts=4 sw=4
    autocmd Filetype text setlocal textwidth=80

    au BufWritePre,FileWritePre *.vim call s:InsertDate() 
    " Don't insert comment after hitting 'o'
    autocmd Filetype * setlocal formatoptions-=o

    " Highlight line number
    " autocmd ColorScheme * hi clear CursorLine
    autocmd BufEnter * silent! lcd %:p:h
    autocmd BufRead,BufNewFile *_notes.txt
        \ setlocal keymap=russian-jcukenwin |
        \ setlocal spell spelllang=ru_ru,en_us
        " \ setlocal iminsert=0 |
        " \ setlocal imsearch=0 |
        \ highlight lCursor guifg=NONE guibg=Red

    autocmd CmdwinEnter * nnoremap <buffer> <CR> <CR>
    " autocmd BufReadPost quickfix nnoremap <CR> <CR>
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
set pastetoggle=<F6>
set background=dark
set mouse=a
set ttymouse=xterm
set splitright
set listchars=eol:$,tab:>-
" set cursorline
"#options

colorscheme solarized

" }}}


" Key Mappings {{{
" ============

" Misc
" ----

noremap ; :

nnoremap <leader>v :tabe ~/projects/vim-config/_vimrc<CR>
nnoremap <leader>mj :tabe ~/docs/mastery-job.txt<CR>
nnoremap <leader>m :tabe ~/docs/mastery.txt<CR>
nnoremap <leader>t :tabe ~/docs/pleasure.txt<CR>
nnoremap <leader>n :tabe ~/projects/vim-config/_vim/doc/notes.txt<CR>

nnoremap <leader>s :so %<CR>

nmap <leader>l :set list!<CR>
nnoremap <silent> ,/ :nohlsearch<CR>

nmap <leader>cd :lcd %:h \| pw<CR> 

" nnoremap <C-s> :w<CR>

nnoremap v <C-v>
command! W :execute ':silent w !sudo tee % > /dev/null' | :edit!
nnoremap <Return> :w<CR>

" Editing
" ----------------------

nnoremap <silent> <F5> :call <SID>StripTrailingWhitespaces()<CR>

" Insert empty line above or below
nnoremap k O<Esc>j
nnoremap j o<Esc>k

" Duplicate line
nnoremap d yyp

" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e
" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv
nnoremap L J

nnoremap <leader>r :Replace<Space>
vnoremap <leader>r :Replace<Space>

nnoremap gm m

"cnoremap $t <CR>:t''<CR>
"cnoremap $T <CR>:T''<CR>
"cnoremap $m <CR>:m''<CR>
"cnoremap $M <CR>:M''<CR>
"cnoremap $d <CR>:d<CR>``

" Copy, cut, paste with Ctrl-v
" @TODO: Optimize this
vnoremap <C-v> "_dP
nnoremap <C-v> p
inoremap <C-v> +
vnoremap <C-x> d
vnoremap <C-c> y
nnoremap <C-c> y


" Moving around
"-------------------

" nnoremap ; ;
" nnoremap , ,
" vnoremap ; ;
" vnoremap , ,

nnoremap <Space> ;
vnoremap <Space> ;
nnoremap <NUL> ,
vnoremap <NUL> ,

" Buffers, windows, tabs
" ----------------------

nnoremap w :bd<CR> 
nnoremap <leader>x <C-w>n<C-w>w:bd #<CR>
" Nex/prev buffer
"nnoremap K :bnext<CR>
"nnoremap J :bprevious<CR>
noremap <silent> <C-W>m :call MaximizeWin()<CR>

" Moving between windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Tabs
nnoremap K :call NextTabOrBuf()<CR>
nnoremap J :call PrevTabOrBuf()<CR>
nnoremap f :call NextTabOrBuf()<CR>
nnoremap a :call PrevTabOrBuf()<CR>
nnoremap 1 :call <SID>GotoBufOrWinNum(1)<CR>
nnoremap 2 :call <SID>GotoBufOrWinNum(2)<CR>
nnoremap 3 :call <SID>GotoBufOrWinNum(3)<CR>
nnoremap 4 :call <SID>GotoBufOrWinNum(4)<CR>
nnoremap 5 :call <SID>GotoBufOrWinNum(5)<CR>
nnoremap 6 :call <SID>GotoBufOrWinNum(6)<CR>
nnoremap 7 :call <SID>GotoBufOrWinNum(7)<CR>
nnoremap 8 :call <SID>GotoBufOrWinNum(8)<CR>
nnoremap 8 :call <SID>GotoBufOrWinNum(9)<CR>
nnoremap 0 :call <SID>GotoBufOrWinNum('$')<CR> 
" switch to recent the buffer
nnoremap q <C-^> 


" Plugin mappings
" ---------------

" Sneak
nmap <Space> <Plug>SneakNext
nmap <NUL> <Plug>SneakPrevious
nmap s <Plug>Sneak_S
xmap s <Plug>Sneak_S

" Gundo
nnoremap <F5> :GundoToggle<CR>

" CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_prompt_mappings = { 'ToggleMRURelative()': ['<F3>'] }

" easyclip
nmap <F6> <Plug>PasteToggle
imap <F6> <Plug>PasteToggle

" Todo
nmap <F8> :TodoToggle<cr>
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

let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_by_filename = 1
let g:ctrlp_mruf_relative = 0
let g:ctrlp_user_command = {
    \ 'types': {
        \ 1: ['.git', 'cd %s && git ls-files . -co --exclude-standard'],
    \ },
    \ 'fallback': 'find %s -type f'
\ }


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

let NERDSpaceDelims = 1


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


" vim-todo
"

let g:todo_dbfile = '/home/alex/.vim/bundle/vim-todo/data/todo.dev.db'


" vim-markdown
"

let g:vim_markdown_folding_disabled=1


" Man
"

runtime ftplugin/man.vim

"Swap-parameters
"---------------
map gs gb
map gS gB

" }}}
