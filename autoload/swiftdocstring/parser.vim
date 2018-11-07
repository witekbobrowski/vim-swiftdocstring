function! swiftdocstring#parser#parse(line_n)
    let parser = {}

    function! parser.parse(self, line_n)
        let l:context = a:self.get_context(a:self, a:line_n)
        let l:converted = a:self.convert(a:self, l:context)
        return l:converted
    endfunction

    function! parser.get_context(self, line_n)
        let l:lines = [getline(a:line_n)]
		let l:main_keyword = self.get_main_keyword(a:self, l:lines)
        while empty(l:main_keyword) 
            if a:line_n - len(l:lines) < 0
                return []
            endif
			let l:lines = [getline(a:line_n - len(l:lines))] + l:lines
			let l:main_keyword = self.get_main_keyword(a:self, l:lines)
        endwhile
		let l:i = 0
        while !self.is_full_context(a:self, l:lines, l:main_keyword) 
            if a:line_n + l:i > line('$')
                return []
            endif
			let l:i += 1
			let l:lines += [getline(a:line_n + l:i)]
        endwhile
        return l:lines
    endfunction

    function! parser.get_main_keyword(self, lines)
        let l:keywords = ['let', 'var', 'protocol', 'class', 'struct', 'enum', 'func', 'init']
        for line in a:lines
            let l:matched = a:self.match_line(line, l:keywords) 
            if !empty(l:matched)
                return l:matched
            endif 
        endfor
        return ''
    endfunction

    function! parser.is_full_context(self, lines, main_keyword)
		if index(['let', 'var', 'protocol', 'class', 'struct'], a:main_keyword) >= 0
			return 1
		elseif 'enum' ==# a:main_keyword
			return a:self.is_full_enum_scope(a:lines)
        elseif index(['init', 'func'], a:main_keyword) >= 0
			return a:self.is_full_func_scope(a:lines)
		else 
			return 0
		endif
    endfunction

    function! parser.is_full_enum_scope(lines)
		" TODO: Check if all the context for docstring is present 
        let l:full_scope_regex = '\v\{\n((\t.*\n)|(^$\n))*^\}'
        return 1
    endfunction

    function! parser.is_full_func_scope(lines)
        for line in a:lines
            if line =~# '{'
                return 1
            endif
        endfor
        return 0
    endfunction

    function! parser.match_line(line, keywords)
        for keyword in a:keywords
            if a:line =~ '\<' . keyword . '\>'
                return keyword 
            endif
        endfor
        return 0
    endfunction

    function! parser.convert(self, lines)
        let l:keyword = a:self.get_main_keyword(a:self, a:lines) 
		if index(['let', 'var'], l:keyword) >= 0
			return {'property': {}}
        elseif index(['protocol', 'class', 'struct', 'enum'], l:keyword) >= 0
            return a:self.convert_type(a:self, l:keyword, a:lines)
        elseif index(['init', 'func'], l:keyword) >= 0
            return a:self.convert_function(a:self, a:lines)
		else 
            return {}
		endif
    endfunction

    function! parser.convert_function(self, lines)
        " TODO: Convert lines with function context to internal reprezentation
       	let l:function_parameters_pattern = '\v\(@<=(.|\s)*\)@='
       	let l:function_returns_pattern = '\v\(@<=(.|\s)*\)@=(.|\s)*[->]+'
   		let l:scope = ''
        for line in a:lines
            let l:scope .= line
        endfor
        echo matchstr(l:scope, l:function_parameters_pattern)
        echo match(l:scope, l:function_returns_pattern)
        return {'function': {}}
    endfunction

    function! parser.convert_type(self, type, lines)
        let l:type_info = {a:type : {}}
		if 'enum' ==# a:type
            let l:cases = []
            for line in a:lines
                let l:cases += a:self.match_cases(line) 
            endfor
            let l:type_info[a:type] = {'cases': l:cases}
        endif
	    return {'type': l:type_info}
    endfunction

    function! parser.match_cases(line)
        let l:cases = []
        return l:cases
    endfunction

    return parser.parse(parser, a:line_n)
endfunction

