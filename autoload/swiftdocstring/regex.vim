" 
"   regex.vim
"   witekbobrowski/vim-swiftdocstring 
"
"   Created by Witek Bobrowski (witek@bobrowski.co).
"   Published under MIT license.
"

" Keyword matching

" Retrive keyword if present in string
function! g:swiftdocstring#regex#match_keyword(context)
    let l:pattern = '\v(let|var|case|func|init|protocol|class|struct|enum)'
    return matchstr(a:context, l:pattern)
endfunction

" Enum matching

" Check if given string contains full function context
function! g:swiftdocstring#regex#is_full_enum_context(context)
    let l:pattern = '\v(enum)@<=(.|\s)*'
    return g:swiftdocstring#utils#match(a:context, l:pattern)
endfunction

" Retrive functions parameters from declaration
function! g:swiftdocstring#regex#match_enum_cases(context)
    let l:pattern = ''
    return matchstr(a:context, l:pattern)
endfunction

" Function matching

" Check if given string contains full function context
function! g:swiftdocstring#regex#is_full_function_context(context)
    let l:pattern = '\v(func|init)@<=(.|\s)*\(@<=(.|\s)*\)@=(.|\s)*(\{|\})+'
    return g:swiftdocstring#utils#match(a:context, l:pattern)
endfunction

" Retrive functions parameters from declaration
function! g:swiftdocstring#regex#match_function_parameters(context)
    let l:pattern = '\v\(@<=(.|\s)*\)@='
    return matchstr(a:context, l:pattern)
endfunction

" Check if function throws
function! g:swiftdocstring#regex#function_throws(context)
    let l:pattern = '\v\(@<=(.|\s)*\)@=(.|\s)*(throws)+'
    return g:swiftdocstring#utils#match(a:context, l:pattern)
endfunction

" Check if function returns
function! g:swiftdocstring#regex#function_returns(context)
    let l:pattern = '\v\(@<=(.|\s)*\)@=(.|\s)*[->]+'
    return g:swiftdocstring#utils#match(a:context, l:pattern)
endfunction

" Comment/Docstring matching

" Check in context is begins with Swift comment delimiters
function! g:swiftdocstring#regex#is_comment(context)
    let l:pattern = '\v^(\s)*(/{2}|\*/|/\*)'
    return g:swiftdocstring#utils#match(a:context, l:pattern)
endfunction

" Check in context is begins with Swift comment delimiters
function! g:swiftdocstring#regex#is_docstring(context)
    let l:pattern = '\v^(\s)*(/{3}|\*/|/\*\*)'
    return g:swiftdocstring#utils#match(a:context, l:pattern)
endfunction
