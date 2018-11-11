" 
"   swiftdocstring.vim
"   witekbobrowski/vim-swiftdocstring 
"
"   Created by Witek Bobrowski (witek@bobrowski.co).
"   Published under MIT license.
"

function! swiftdocstring#docstring_current()
    let l:parsed = swiftdocstring#parser#parse(line('.'), {})
    let l:template = swiftdocstring#template#factory()
    let l:options = l:parsed['options'] 
    let l:options['delimiter-type'] = g:swiftdocstring#use_multi_line_delimiter
    let l:docstring = swiftdocstring#docstring#build(l:parsed['parsed'], l:template, l:options)
    call swiftdocstring#utils#output(l:docstring, l:options['target-line-number'])
endfunction
