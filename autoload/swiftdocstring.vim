if exists('g:loaded_swiftdocstring')
  finish
endif
let g:loaded_swiftdocstring = 1

function! swiftdocstring#docstring()
	let l:line_n = line('.') - 1
    let l:template = swiftdocstring#template#factory()
    let l:sample = {'type': {'enum': {'cases': ['north', 'south', 'east', 'west']}}}
    let l:lines = swiftdocstring#generator#docstring(l:template, l:sample)
    let l:formatted = swiftdocstring#output#formatted(l:lines, line('.'))
    call swiftdocstring#output#output(l:formatted, l:line_n)
endfunction
