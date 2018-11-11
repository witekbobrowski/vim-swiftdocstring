" 
"   swiftdocstring.vim
"   witekbobrowski/vim-swiftdocstring 
"
"   Created by Witek Bobrowski (witek@bobrowski.co).
"   Published under MIT license.
"

" Public function to generate docstring for context at current line.
function! g:swiftdocstring#docstring_current()
    call s:docstring(line('.'))
endfunction

" Main function that parses context to Intermediate Representation for given
" line to generate docstring that is being outputted to the file.
function! s:docstring(line)
    " Prepare dependencies
    let l:options = swiftdocstring#options#build() 
    let l:template = swiftdocstring#template#factory()

    " Begin flow
    let l:parsed = swiftdocstring#parser#parse(a:line, l:options)
    let l:docstring = swiftdocstring#docstring#build(l:parsed, l:template, l:options)

    " Output generated docstring
    call swiftdocstring#utils#output(l:docstring, l:options)
endfunction
