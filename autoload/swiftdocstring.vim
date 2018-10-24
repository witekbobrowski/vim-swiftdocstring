function! swiftdocstring#docstring_current()
    let l:line_n = line('.') - 1
    let l:template = swiftdocstring#template#factory()
    let l:sample = {'type': {'enum': {'cases': ['north', 'south', 'east', 'west']}}}
    let l:lines = swiftdocstring#generator#docstring(l:template, l:sample)
    let l:prefixed = swiftdocstring#output#prefixed(l:lines, g:swiftdocstring#use_multi_line_delimiter, l:template) 
    let l:formatted = swiftdocstring#output#formatted(l:prefixed, line('.'))
    call swiftdocstring#output#output(l:formatted, l:line_n)
endfunction
