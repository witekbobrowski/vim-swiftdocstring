function! swiftdocstring#output#output(text, line_number)
    call append(a:line_number, a:text)
endfunction

function! swiftdocstring#output#indented(text, n_spaces)
    let l:prefix = repeat(' ', a:n_spaces)
    return l:prefix . a:text
endfunction

function! swiftdocstring#output#formatted(lines, line_n)
    let formatted = []
    for line in a:lines
        let l:indented = swiftdocstring#output#indented(line, indent(a:line_n))
        call add(formatted, l:indented)
    endfor
    return formatted
endfunction

function! swiftdocstring#output#prefixed(lines, use_multiline_delimiter, template) 
    let l:prefixed = []
    let l:prefix = ''
    if a:use_multiline_delimiter
        call add(l:prefixed, a:template.multi_line_begin())
        let l:prefix = ' '
    else
        let l:prefix = a:template.single_line()
    endif
    for line in a:lines
        call add(l:prefixed, l:prefix . line)
    endfor
    if a:use_multiline_delimiter
        call add(l:prefixed, a:template.multi_line_end())
    endif
    return prefixed
endfunction

