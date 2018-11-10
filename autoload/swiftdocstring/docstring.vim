" Builder for generating docstring from intermediate representation.
"
" Parameters
" - template: Object with methods that returns appropriate docstring parts. 
" - intermediate_representaiton: Dictionary containing all the parsed
"      info about the context to which the docstring should be generated.
function! swiftdocstring#docstring#build(template, intermediate_representaiton)
    return s:generate(a:template, a:intermediate_representaiton)
endfunction

" Helper function that delegates other, more specified functions to perform
" docstring generation from Intermediate Representation with template.
function! s:generate(template, ir)
    let l:lines = []
    if has_key(a:ir, 'property')
        let l:lines = [a:template.simple()]
    elseif has_key(a:ir, 'function')
        let l:lines = s:generate_from_function(a:template, a:ir['function'])
    elseif has_key(a:ir, 'type')
        let l:lines = s:generate_from_type(a:template, a:ir['type'])
    endif
    return l:lines
endfunction

" Generating docstring for Swift funcitons from Intermediate Representation
function! s:generate_from_function(template, function_ir)
    let l:lines = [a:template.simple()]
    if has_key(a:function_ir, 'parameters')
        call add(l:lines, a:template.empty())
        call add(l:lines, a:template.parameters())
        for parameter in a:function_ir['parameters']
             call add(l:lines, a:template.parameter(parameter))
        endfor
    endif
    if has_key(a:function_ir, 'returns')
        if !has_key(a:function_ir, 'parameters')
            call add(l:lines, a:template.empty())
        endif
        call add(l:lines, a:template.returns())
    endif
    return l:lines
endfunction

" Generating docstring for Swift types from Intermediate Representation
function! s:generate_from_type(template, type_ir)
    if has_key(a:type_ir, 'enum')
        return s:generate_from_enum(a:template, a:type_ir['enum'])
    elseif has_key(a:type_ir, 'struct')
        return [a:template.simple()]
    elseif has_key(a:type_ir, 'class')
        return [a:template.simple()]
    elseif has_key(a:type_ir, 'protocol')
        return [a:template.simple()]
    endif
endfunction

" Generating docstring for Swift enumerations from Intermediate Representation
function! s:generate_from_enum(template, enum_ir)
    let l:lines = [a:template.simple()]
    call add(l:lines, a:template.empty())
    for case in a:enum_ir['cases']
        call add(l:lines, a:template.enumCase(case))
    endfor
    return l:lines
endfunction

