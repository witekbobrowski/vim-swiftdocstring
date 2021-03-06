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
    call s:retrive_indentation_option(l:options)
    call s:retrive_placeholder_options(l:options)

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

" Get indentation from global option.
function! s:retrive_indentation_option(options)
    let l:indentation_level = g:swiftdocstring#text_indentation_level
    let a:options['indentation-level'] = l:indentation_level
endfunction

" Get placeholder settings from global option.
function! s:retrive_placeholder_options(options)
    let l:use_placeholders = g:swiftdocstring#use_placeholders
    let a:options['use-placeholder'] = l:use_placeholders
    if l:use_placeholders
        let l:placeholder_template = g:swiftdocstring#placeholder_template
        let a:options['placeholder-open'] = l:placeholder_template[0]
        let a:options['placeholder-close'] = l:placeholder_template[-1]
    endif
endfunction


