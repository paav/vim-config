" Vim syntax file
" Language: todo file
" Maintainer: Alexey Panteleiev (paav@inbox.ru)
" Last Change: 24 March 2015

if exists("b:current_syntax")
  finish
endif

syn match todoDate "\d\{4}-\d\{2}-\d\{2}"
syn match todoImpDate contained "\d\{4}-\d\{2}-\d\{2}"
"syn match todoText "[a-zA-Z]*"

"syn match todoItem "^\d\{4}-.*" contains=todoText

syn match todoComment "#.*$"
syn match todoDone "^+.*$"
syn match todoImportant "^!.*$" contains=todoImpDate
syn match helpHeadline "^[-A-Z .]\{2,}"

hi def link todoComment     Comment
hi def link todoDate        PreProc 
hi def link todoImpDate       PreProc 
hi def link todoDone        Comment
hi def link todoImportant   Special
hi def link helpHeadline	Statement
