" Vim filetype plugin file
" Language:	htmlphp
" Maintainer: Alexey Panteleiev (paav@inbox.ru)
" Last Changed: 12 Apr 2015

if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin = 1

let b:php = '<?php ; ?>'
let b:phpEcho = '<?php echo ; ?>'

let g:htmlphpDelims = [
    \ {'left': '<?php /*', 'right': '*/ ?>'},
    \ {'left': '//'}
\ ]
let b:htmlphpDelimIndex = 0

" File specific mappings
inoremap <buffer> <C-y>p <C-r>=b:php<CR><Esc>3hi
inoremap <buffer> <C-y>pe <C-r>=b:phpEcho<CR><Esc>3hi
noremap <buffer> <leader>cc :call HtmlphpComment()<CR>
noremap <buffer> <leader>cu :call HtmlphpUncomment()<CR>
noremap <buffer> <leader>ca :call HtmlphpNextDelim()<CR>

function! HtmlphpComment() range
    let delim = g:htmlphpDelims[b:htmlphpDelimIndex]
    let hasRight = has_key(delim, 'right')

    for linenum in range(a:firstline, a:lastline)
        let line = getline(linenum)
        let newline = delim.left . line

        if (hasRight)
            let newline .= delim.right
        endif

        call setline(linenum, newline)
    endfor
endfunction

function! HtmlphpUncomment() range
    let delimPattern = g:htmlphpDelimPatterns[b:htmlphpDelimIndex]
    let pattern = '\(' . delimPattern.left

    if (has_key(delimPattern, 'right'))
        let pattern .= '\|' . delimPattern.right
    endif

    let pattern .= '\)'

    for linenum in range(a:firstline, a:lastline)
        let line = getline(linenum)
        let newline = substitute(line, pattern, '', 'g')

        call setline(linenum, newline)
    endfor
endfunction

function! s:createDelimPatterns()
    let g:htmlphpDelimPatterns = []
    let chars = '/*'

    for delim in g:htmlphpDelims
        let patterns = {}

        if (has_key(delim, 'left'))
            let patterns.left= escape(delim.left, chars)
        endif

        if (has_key(delim, 'right'))
            let patterns.right = escape(delim.right, chars)
        endif

        call add(g:htmlphpDelimPatterns, patterns)
    endfor
endfunction

function! HtmlphpNextDelim()
    let size = len(b:htmlphpDelims) 

    if b:htmlphpDelimIndex >= size - 1
        let b:htmlphpDelimIndex = 0
    else
        let b:htmlphpDelimIndex += 1
    endif

    echo b:htmlphpDelims[b:htmlphpDelimIndex]
endfunction

call s:createDelimPatterns()

" Make sure the continuation lines below do not cause problems in
" compatibility mode.
let s:save_cpo = &cpo
set cpo-=C

setlocal textwidth=0
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
