" 
"   regex.vim
"   witekbobrowski/vim-swiftdocstring 
"
"   Created by Witek Bobrowski (witek@bobrowski.co).
"   Published under MIT license.
"

function! g:swiftdocstring#regex#function_parameters(context)
    let l:pattern = '\v\(@<=(.|\s)*\)@='
    return matchstr(a:context, l:pattern)
endfunction

function! g:swiftdocstring#regex#function_throws(context)
    let l:pattern = '\v\(@<=(.|\s)*\)@=(.|\s)*[\<throws\>]+'
    return match(a:context, l:pattern)
endfunction

function! g:swiftdocstring#regex#function_returns(context)
    let l:pattern = '\v\(@<=(.|\s)*\)@=(.|\s)*[->]+'
    return match(a:context, l:pattern)
endfunction
