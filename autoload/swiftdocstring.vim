if exists('g:loaded_swiftdocstring')
  finish
endif
let g:loaded_swiftdocstring = 1

function! swiftdocstring#template()
  let template = {}

  function! template.empty()
    return '///'
  endfunction

  function! template.simple()
    return '/// Description'
  endfunction

  function! template.parameters()
    return '/// - Parameters:'
  endfunction

  function! template.returns()
    return  '/// - Returns: return value description'
  endfunction

  function! template.parameter(parameter)
    return '///   - '. a:parameter. ': '. a:parameter. ' description'
  endfunction

  function! template.enumCase(case)
    return '/// - '. a:case. ': '. a:case. ' description'
  endfunction

  return template
endfunction

function! swiftdocstring#docstring()
	let l:line_n = line('.') - 1
    let l:template = swiftdocstring#template()
    let l:sample = {'type': {'enum': {'cases': ['north', 'south', 'east', 'west']}}}
    let l:lines = swiftdocstring#generate_docstring(l:template, l:sample)
    let l:formatted = swiftdocstring#formatted(l:lines, line('.'))
    call swiftdocstring#output(l:formatted, l:line_n)
endfunction

function! swiftdocstring#output(text, line_number)
    call append(a:line_number, a:text)
endfunction

function! swiftdocstring#indented(text, n_spaces)
    let l:prefix = repeat(' ', a:n_spaces)
    return l:prefix . a:text
endfunction

function! swiftdocstring#generate_docstring(template, internal_rep)
    let generator = {}

    function! generator.generate(self, template, dict)
        if has_key(a:dict, 'property')
            return [a:template.simple()]
        elseif has_key(a:dict, 'function')
            return a:self.generate_from_function(a:self, a:template, a:dict['function'])
        elseif has_key(a:dict, 'type')
            return a:self.generate_from_type(a:self, a:template, a:dict['type'])
        endif
    endfunction

    function! generator.generate_from_function(self, template, func_dict)
        let lines = [a:template.simple()]
        if has_key(a:func_dict, 'properties')
            call add(lines, a:template.empty())
            call add(lines, a:template.properties())
            for property in a:func_dict['properties']
                call add(lines, a:template.property(property))
            endfor
        elseif has_key(a:func_dict, 'returns')
            if !has_key(a:func_dict, 'properties')
                call add(lines, a:template.empty())
            endif
            call add(lines, a:template.returns())
        endif
        return lines
    endfunction

    function! generator.generate_from_type(self, template, type_dict)
        if has_key(a:type_dict, 'enum')
            return a:self.generate_from_enum(a:self, a:template, a:type_dict['enum'])
        elseif has_key(a:type_dict, 'struct')
            return [a:template.simple()]
        elseif has_key(a:type_dict, 'class')
            return [a:template.simple()]
        elseif has_key(a:type_dict, 'protocol')
            return [a:template.simple()]
        endif
    endfunction

    function! generator.generate_from_enum(self, template, enum_dict)
        let lines = [a:template.simple()]
        call add(lines, a:template.empty())
        for case in a:enum_dict['cases']
            call add(lines, a:template.enumCase(case))
        endfor
        return lines
    endfunction

    return generator.generate(generator, a:template, a:internal_rep)
endfunction

function! swiftdocstring#formatted(lines, line_n)
    let formatted = []
    for line in a:lines
        call add(formatted, swiftdocstring#indented(line, indent(a:line_n)))
    endfor
    return formatted
endfunction
