" 
"   options.vim
"   witekbobrowski/vim-swiftdocstring 
"
"   Created by Witek Bobrowski (witek@bobrowski.co).
"   Published under MIT license.
"

" Public builder of dictionary containing user-defined and context related 
" options that will be used to generate docstring.
function! g:swiftdocstring#options#build()
    let l:options = {}

    call s:retrive_delimiter_option(l:options)

    return l:options
endfunction

" Get Swift docstring delimiter type from global option.
function! s:retrive_delimiter_option(options)
    if g:swiftdocstring#use_multi_line_delimiter
        let a:options['delimiter-type'] = 'multi-line'
    else  
        let a:options['delimiter-type'] = 'single-line'
    endif 
endfunction
