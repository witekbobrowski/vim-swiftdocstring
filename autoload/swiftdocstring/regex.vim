" 
"   regex.vim
"   witekbobrowski/vim-swiftdocstring 
"
"   Created by Witek Bobrowski (witek@bobrowski.co).
"   Published under MIT license.
"

" Function matching

" Check if given string contains full function context
function! g:swiftdocstring#regex#is_full_function_context(context)
    let l:pattern = '\v(func)@<=(.|\s)*\(@<=(.|\s)*\)@=(.|\s)*(\{)+'
    return match(a:context, l:pattern)
endfunction

" Retrive functions parameters from declaration
function! g:swiftdocstring#regex#function_parameters(context)
    let l:pattern = '\v\(@<=(.|\s)*\)@='
    return matchstr(a:context, l:pattern)
endfunction

" Check if function throws
function! g:swiftdocstring#regex#function_throws(context)
    let l:pattern = '\v\(@<=(.|\s)*\)@=(.|\s)*(throws)+'
    return match(a:context, l:pattern)
endfunction

" Check if function returns
function! g:swiftdocstring#regex#function_returns(context)
    let l:pattern = '\v\(@<=(.|\s)*\)@=(.|\s)*[->]+'
    return match(a:context, l:pattern)
endfunction
