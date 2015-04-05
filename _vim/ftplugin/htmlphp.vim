" Vim filetype plugin file
" Language:	htmlphp
" Maintainer: Alexey Panteleiev (paav@inbox.ru)
" Last Changed: 25 Mar 2015

let b:php = '<?php ; ?>'
let b:phpEcho = '<?php echo ;?>'
let b:phpComment1 = '// '
let b:phpComment2 = '/*  */'
let b:todo = '// TODO: '

" File specific mappings
inoremap <buffer> <C-y>p <C-r>=g:php<CR><Esc>3hi
inoremap <buffer> <C-y>e <C-r>=g:phpEcho<CR><Esc>2hi
nmap <buffer> <leader>p1 o<C-y>p<C-r>=g:phpComment1<CR>
nmap <buffer> <leader>pt o<C-y>p<C-r>=g:todo<CR>
noremap <buffer> <leader>c1 o<C-r>=g:phpComment1<CR>
noremap <buffer> <leader>c2 o<C-r>=g:phpComment2<CR><Esc>2hi
noremap <buffer> <leader>ct o<C-r>=g:todo<CR>
noremap <buffer> <leader>cc :call HtmlphpComment()<CR>
noremap <buffer> <leader>cu :call HtmlphpUncomment()<CR>

setlocal textwidth=0

function! HtmlphpComment()
    let delims = {'left': '<?php /*', 'right': '*/ ?>'}

    let line = getline('.')

    call setline('.', delims.left . line . delims.right)
endfunction

function! HtmlphpUncomment()
    let line = getline('.')

    let leftPat =  '<?php \/\*'
    let rightPat =  '\*\/ ?>'

    let pattern = '\(' . leftPat . '\|' . rightPat . '\)'

    let newline = substitute(line, pattern, '', 'g')

    call setline('.', newline)
endfunction

if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin = 1

" Make sure the continuation lines below do not cause problems in
" compatibility mode.
let s:save_cpo = &cpo
set cpo-=C

setlocal matchpairs+=<:>
setlocal commentstring=<!--%s-->
setlocal comments=s:<!--,m:\ \ \ \ ,e:-->

if exists("g:ft_html_autocomment") && (g:ft_html_autocomment == 1)
    setlocal formatoptions-=t formatoptions+=croql
endif

if exists('&omnifunc')
  setlocal omnifunc=htmlcomplete#CompleteTags
  call htmlcomplete#DetectOmniFlavor()
endif

" HTML:  thanks to Johannes Zellner and Benji Fisher.
if exists("loaded_matchit")
    let b:match_ignorecase = 1
    let b:match_words = '<:>,' .
    \ '<\@<=[ou]l\>[^>]*\%(>\|$\):<\@<=li\>:<\@<=/[ou]l>,' .
    \ '<\@<=dl\>[^>]*\%(>\|$\):<\@<=d[td]\>:<\@<=/dl>,' .
    \ '<\@<=\([^/][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>'
endif

" Change the :browse e filter to primarily show HTML-related files.
if has("gui_win32")
    let  b:browsefilter="HTML Files (*.html,*.htm)\t*.htm;*.html\n" .
		\	"JavaScript Files (*.js)\t*.js\n" .
		\	"Cascading StyleSheets (*.css)\t*.css\n" .
		\	"All Files (*.*)\t*.*\n"
endif

" Undo the stuff we changed.
let b:undo_ftplugin = "setlocal commentstring< matchpairs< omnifunc< comments< formatoptions<" .
    \	" | unlet! b:match_ignorecase b:match_skip b:match_words b:browsefilter"

" Restore the saved compatibility options.
let &cpo = s:save_cpo
unlet s:save_cpo
