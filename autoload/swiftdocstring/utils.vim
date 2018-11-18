" 
"   utils.vim
"   witekbobrowski/vim-swiftdocstring 
"
"   Created by Witek Bobrowski (witek@bobrowski.co).
"   Published under MIT license.
"

" Merge all lines from list of string to a single string
function! g:swiftdocstring#utils#merge(lines)
    let l:text = ''
    for line in a:lines
        let l:text .= line
    endfor
    return l:text
endfunction

" Simple wrapper funciton that outputs text to line in current file
function! g:swiftdocstring#utils#output(text, line)
    call append(a:line, a:text)
endfunction

" Concatenate string with a prefix
function! g:swiftdocstring#utils#prefixed(string, prefix) 
    return a:prefix . a:string
endfunction

" Contatenate a list of strings with a prefix
function! g:swiftdocstring#utils#prefixed_strings(strings, prefix) 
    let l:prefixed = []
    for string in a:strings
        call add(l:prefixed, swiftdocstring#utils#prefixed(string, a:prefix))
    endfor
    return prefixed
endfunction

" Contatenate string with given number of spaces
function! g:swiftdocstring#utils#indented(string, n_spaces)
    let l:prefix = repeat(' ', a:n_spaces)
    return swiftdocstring#utils#prefixed(a:string, l:prefix) 
endfunction

" Contatenate a list of strings with given number of spaces
function! g:swiftdocstring#utils#indented_strings(strings, n_spaces)
    let l:prefix = repeat(' ', a:n_spaces)
    return swiftdocstring#utils#prefixed_strings(a:strings, l:prefix) 
endfunction

" Warpper funciton for mapping result from match function to 0 or 1
function! g:swiftdocstring#utils#match(text, pattern)
    return match(a:text, a:pattern) != -1
endfunction
