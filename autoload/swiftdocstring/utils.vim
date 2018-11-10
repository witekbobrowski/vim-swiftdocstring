" Merge all lines from list of string to a single string
function! swiftdocstring#utils#merge(lines)
    let l:text = ''
    for line in a:lines
        let l:text .= line
    endfor
    return l:text
endfunction

" Simple wrapper funciton that outputs text to line in current file
function! swiftdocstring#utils#output(text, line_number)
    call append(a:line_number, a:text)
endfunction

" Concatenate string with a prefix
function! swiftdocstring#utils#prefixed(string, prefix) 
    return a:prefix . a:string
endfunction

" Contatenate a list of strings with a prefix
function! swiftdocstring#utils#prefixed_strings(strings, prefix) 
    let l:prefixed = []
    for string in a:strings
        call add(l:prefixed, a:prefix . string)
    endfor
    return prefixed
endfunction

" Contatenate string with given number of spaces
function! swiftdocstring#utils#indented(string, n_spaces)
    let l:prefix = repeat(' ', a:n_spaces)
    return swiftdocstring#utils#prefixed(a:string, l:prefix) 
endfunction

" Contatenate a list of strings with given number of spaces
function! swiftdocstring#utils#indented_strings(strings, n_spaces)
    let l:prefix = repeat(' ', a:n_spaces)
    return swiftdocstring#utils#prefixed_strings(a:strings, l:prefix) 
endfunction

