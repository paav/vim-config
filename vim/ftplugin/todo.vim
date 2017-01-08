let s:dateFormat = "%Y-%m-%d"

nnoremap <C-y>d "=strftime(<SID>dateFormat)<CR>
inoremap <C-y>d <C-R>=strftime(s:dateFormat)<CR>
map <buffer> <leader>d :call <SID>moveToDone()<CR>
map <buffer> <leader>i :call <SID>toggleState("!")<CR>
map <buffer> <leader>n :call <SID>newItem()<CR>

function! s:toggleState(stateSign)
    let line = getline(".")

    if line == ""
       return
    endif

    let firstChar = line[0]
    let newline = a:stateSign . line

    echo newline

    if firstChar == a:stateSign
        let newline = substitute(line, a:stateSign, "", "") 
    endif

    call setline(".", newline)
endfunction

function! s:newItem()
    execute "silent 0,/DONE/g/^2015/"
    execute "normal o\<C-y>d "
    execute "startinsert!"
endfunction

function! s:moveToDone()
    let line = getline('.')
    let curpos = getcurpos()

    d | /+/-1

    let date = matchstr(line, '\d\{4}-\d\{2}-\d\{2}')
    let text = matchstr(line, '.*$', 11)
    let today = strftime('%Y-%m-%d') 

    call append('.', '+' . text . ' ' . date . ' => ' . today)

    call setpos('.', curpos)
endfunction
