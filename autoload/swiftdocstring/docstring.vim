" 
"   docstring.vim
"   witekbobrowski/vim-swiftdocstring 
"
"   Created by Witek Bobrowski (witek@bobrowski.co).
"   Published under MIT license.
"

" Builder for generating docstring from intermediate representation.
"
" Parameters
" - intermediate_representaiton: Dictionary containing all the parsed
"      info about the context to which the docstring should be generated.
" - template: Object with methods that returns appropriate docstring parts. 
" - options: Dictionary with user defined or contex related options that are
"   used during generation process.
function! g:swiftdocstring#docstring#build(intermediate_representaiton, template, options)
    let l:lines = s:generate(a:intermediate_representaiton, a:template)
    let l:updated = s:update_with_options(l:lines, a:options, a:template)
    return l:updated 
endfunction

" Helper function that delegates other, more specified functions to perform
" docstring generation from Intermediate Representation with template.
function! s:generate(ir, template)
    let l:lines = []
    if has_key(a:ir, 'property')
        let l:lines = [a:template.simple()]
    elseif has_key(a:ir, 'function')
        let l:lines = s:generate_from_function(a:ir['function'], a:template)
    elseif has_key(a:ir, 'type')
        let l:lines = s:generate_from_type(a:ir['type'], a:template)
    endif
    return l:lines
endfunction

" Generating docstring for Swift funcitons from Intermediate Representation.
function! s:generate_from_function(function_ir, template)
    let l:lines = [] 
    if has_key(a:function_ir, 'parameters')
        let l:params = a:function_ir['parameters']
        let l:lines = s:generate_from_parameters(l:params, a:template)
    endif
    if has_key(a:function_ir, 'throws')
        call add(l:lines, a:template.throws())
    endif
    if has_key(a:function_ir, 'returns')
        call add(l:lines, a:template.returns())
    endif
    if !empty(l:lines)
        let l:lines = [a:template.empty()] + l:lines
    endif
    return [a:template.simple()] + l:lines
endfunction

" Generate docstring for parameters in function
function! s:generate_from_parameters(parameters, template)
    " Early exit if there is a only one parameter
    if len(a:parameters) ==# 1 
        return [a:template.parameter_single(a:parameters[0])]
    endif
    " Otherwise proceed normally with iterating over parameters
    let l:lines = []
    call add(l:lines, a:template.parameters())
    for parameter in a:parameters
        call add(l:lines, a:template.parameter(parameter))
    endfor
    return l:lines
endfunction

" Generating docstring for Swift types from Intermediate Representation.
function! s:generate_from_type(type_ir, template)
    if has_key(a:type_ir, 'enum')
        return s:generate_from_enum(a:type_ir['enum'], a:template)
    elseif has_key(a:type_ir, 'struct')
        return [a:template.simple()]
    elseif has_key(a:type_ir, 'class')
        return [a:template.simple()]
    elseif has_key(a:type_ir, 'protocol')
        return [a:template.simple()]
    endif
endfunction

" Generating docstring for Swift enumerations from Intermediate Representation.
function! s:generate_from_enum(enum_ir, template)
    let l:lines = [a:template.simple()]
    call add(l:lines, a:template.empty())
    for case in a:enum_ir['cases']
        call add(l:lines, a:template.enumCase(case))
    endfor
    return l:lines
endfunction

" Evaluating options dictionary to adjust the generated docstring to context
" related and user-defined options.
function! s:update_with_options(lines, options, template)
    let l:updated = a:lines

    if has_key(a:options, 'delimiter-type')
        let l:delimiter = a:options['delimiter-type']
        let l:updated = s:update_with_delimiter(l:updated, l:delimiter, a:template) 
    endif
    
    if has_key(a:options, 'context-start-line-number')
        let l:line_number = a:options['context-start-line-number']
        let l:updated = s:update_with_indentation(l:updated, l:line_number)
    endif

    return l:updated
endfunction

" Append appropriate Swift docstring delimiter to generated docstring, either 
" single-line `/** ... */` or multi-line `///`.
function! s:update_with_delimiter(lines, delimiter_type, template)
    let l:updated = []
    let l:prefix = ''
    if a:delimiter_type ==# 'multi-line' 
        let l:prefix = ' '
        call add(l:updated, a:template.multi_line_begin())
    elseif a:delimiter_type ==# 'single-line' 
        let l:prefix = a:template.single_line()
    endif 
    let l:updated += swiftdocstring#utils#prefixed_strings(a:lines, l:prefix)
    if a:delimiter_type ==# 'multi-line'
        call add(l:updated, a:template.multi_line_end())
    endif
    return l:updated
endfunction

" Prefix all lines with indentation from given line number.
function! s:update_with_indentation(lines, line_n)
    let l:indentation = indent(a:line_n)
    return swiftdocstring#utils#indented_strings(a:lines, l:indentation)
endfunction
