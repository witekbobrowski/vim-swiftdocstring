" 
"   swiftdocstring.vim
"   witekbobrowski/vim-swiftdocstring 
"
"   Created by Witek Bobrowski (witek@bobrowski.co).
"   Published under MIT license.
"

function! swiftdocstring#docstring_current()
    let l:intermediate_representation = swiftdocstring#parser#parse(line('.'))
    let l:template = swiftdocstring#template#factory()
    let l:options = {}
    let l:options['target-line-number'] = line('.') 
    let l:options['delimiter-type'] = g:swiftdocstring#use_multi_line_delimiter
    let l:docstring = swiftdocstring#docstring#build(l:intermediate_representation, l:template, l:options)
    call swiftdocstring#utils#output(l:docstring, line('.') - 1)
endfunction
