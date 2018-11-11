" 
"   swiftdocstring.vim
"   witekbobrowski/vim-swiftdocstring 
"
"   Created by Witek Bobrowski (witek@bobrowski.co).
"   Published under MIT license.
"

function! swiftdocstring#docstring_current()
    call s:docstring(line('.'))
endfunction

" Main function that parses context to Intermediate Representation for given
" line to generate docstring that is being outputted to the file.
function! s:docstring(line)
    let l:options = swiftdocstring#options#build() 
    let l:parsed = swiftdocstring#parser#parse(a:line, l:options)
    let l:template = swiftdocstring#template#factory()
    let l:docstring = swiftdocstring#docstring#build(l:parsed, l:template, l:options)
    call swiftdocstring#utils#output(l:docstring, l:options)
endfunction
