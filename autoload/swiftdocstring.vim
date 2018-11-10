function! swiftdocstring#docstring_current()
    let l:intermediate_representation = swiftdocstring#parser#parse(line('.'))
    let l:template = swiftdocstring#template#factory()
    let l:lines = swiftdocstring#docstring#build(l:template, l:intermediate_representation)
    let l:prefixed = swiftdocstring#output#prefixed(l:lines, g:swiftdocstring#use_multi_line_delimiter, l:template) 
    let l:formatted = swiftdocstring#output#formatted(l:prefixed, line('.'))
    call swiftdocstring#output#output(l:formatted, line('.') - 1)
endfunction
