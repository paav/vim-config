ia <buffer> fpu  <Esc> :call <SID>PhpInsertFunc('public')<CR>
ia <buffer> fpus <Esc> :call <SID>PhpInsertFunc('public static')<CR>
ia <buffer> fpr  <Esc> :call <SID>PhpInsertFunc('protected')<CR>
ia <buffer> fprs <Esc> :call <SID>PhpInsertFunc('protected static')<CR>

function! <SID>PhpInsertFunc(prefix)
    set fo-=r 

    let doc = "/**\<cr> *\<cr>* @return\<cr>*/"
    let func = "function()\<cr>{\<cr>\<cr>}"
    let curpos = "?()\<cr>"

    execute 'normal! i' . doc . "\<cr>" . a:prefix . ' ' . func
                      \ . "\<cr>\<esc>" . curpos
 
    startinsert

    set fo+=r 
endfunction
