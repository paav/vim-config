inoremap <buffer> <C-y>f <C-r>=PhpInsertFunc(0)<CR>| " public
inoremap <buffer> <C-y>fs <C-r>=PhpInsertFunc(0, 0)<CR>| " public static
inoremap <buffer> <C-y>fp <C-r>=PhpInsertFunc(1)<CR>| " protected

function! PhpInsertFunc(visIndex, ...)
    let visibilities = [
        \ 'public',
        \ 'protected',
        \ 'private'
    \ ]
    let types = ['static']

    let prefix = visibilities[a:visIndex]

    if (a:0 > 0)
        let prefix .= ' ' . types[a:1]
    endif

    let prefixLen = strlen(prefix)

    let lineNum = line('.') - 1
    let indentWidth = indent('.')
    let indent = repeat(' ', indentWidth)

    let indentCounts = [1, 1, 2, 1]
    let lines = [
        \ prefix . ' function ()',
        \ '{',
        \ '',
        \ '}'
    \ ]

    call map(lines, "repeat(indent, indentCounts[v:key]) . v:val")

    call append(lineNum, lines)

    call cursor(lineNum + 1, indentWidth + prefixLen + 11)

    return ''
endfunction
