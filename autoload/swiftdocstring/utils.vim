" Merge all lines from list of string to a single string
function! swiftdocstring#utils#merge(lines)
    let l:text = ''
    for line in a:lines
        let l:text .= line
    endfor
    return l:text
endfunction
