function! swiftdocstring#docstring_current()
    let l:parsed = swiftdocstring#parser#parse(line('.'))
    let l:template = swiftdocstring#template#factory()
    let l:lines = swiftdocstring#generator#docstring(l:template, l:parsed)
    let l:prefixed = swiftdocstring#output#prefixed(l:lines, g:swiftdocstring#use_multi_line_delimiter, l:template) 
    let l:formatted = swiftdocstring#output#formatted(l:prefixed, line('.'))
    call swiftdocstring#output#output(l:formatted, line('.') - 1)
endfunction
