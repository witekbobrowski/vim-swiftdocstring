function! swiftdocstring#generator#docstring(template, internal_rep)
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
