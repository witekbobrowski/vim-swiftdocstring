" 
"   swiftdocstring.vim
"   witekbobrowski/vim-swiftdocstring 
"
"   Created by Witek Bobrowski (witek@bobrowski.co).
"   Published under MIT license.
"

" Public

" Generate docstring for context at current line.
function! g:swiftdocstring#docstring_current()
    call s:docstring(line('.'))
endfunction

" Generate docstring for all functions in current file.
function! g:swiftdocstring#docstring_functions()
    let l:keywords = swiftdocstring#keywords#factory()
    call s:docstrings_for(l:keywords.functions())
endfunction

" Generate docstring for all types in current file.
function! g:swiftdocstring#docstring_types()
    let l:keywords = swiftdocstring#keywords#factory()
    call s:docstrings_for(l:keywords.types())
endfunction

" Private 

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

" Wraper function for generating docstring in multiple lines
function! s:docstrings(lines)
    " Iterate in reversed order so pasting docstrings will not mess with correct
    " placement
    for line in reverse(a:lines)
        call s:docstring(line)
    endfor
endfunction

" Generate docstring for contexts with passed keywords
function! s:docstrings_for(keywords)
    let l:lines = g:swiftdocstring#parser#get_lines_of_keywords(a:keywords)
    call s:docstrings(l:lines)
endfunction
