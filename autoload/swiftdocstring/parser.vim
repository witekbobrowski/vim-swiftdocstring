function! swiftdocstring#parser#parse(line_n)
    let parser = {}

    function! parser.parse(self, line_n)
        let l:context = a:self.get_context(a:self, a:line_n)
        let l:converted = a:self.convert(l:context)
        return l:converted
    endfunction

    function! parser.get_context(self, line_n)
        let l:lines = [getLine(a:line_n)]
		let l:main_keyword = self.get_main_keyword(a:self, l:lines)
        while empty(l:main_keyword) 
			l:lines = [getLine(a:line_n - len(l:lines))] + l:lines
			let l:main_keyword = self.get_main_keyword(a:self, l:lines)
        endwhile
		let l:i = 0
        while !self.is_full_context(a:self, l:lines, l:main_keyword) 
			let l:i += 1
			l:lines += [getLine(a:line_n + l:i)]
        endwhile
        return l:lines
    endfunction

    function! parser.get_main_keyword(self, lines)
        let l:keywords = ['let', 'var', 'protocol', 'class'. 'struct', 'enum', 'func']
        for line in a:lines
            let l:matched = a:self.match_line(line, l:keywords) 
            if l:matched
                return l:matched
            endif 
         endfor
       return 0
    endfunction

    function! parser.is_full_context(self, lines, main_keyword)
		if index(['let', 'var', 'protocol', 'class', 'struct'], a:main_keyword) >= 0
			return 1
		elseif 'enum' ==# a:main_keyword
			return a:self.is_full_enum_scope(a:lines)
		elseif 'func' ==# a:main_keyword
			return a:self.is_full_func_scope(a:lines)
		else 
			return 0
		endif
    endfunction

    function! parser.is_full_enum_scope(lines)
		" TODO: Check if all the context for docstring is present 
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

    function! parser.convert(context)
		" TODO: Convert to internal representation
    endfunction

    return parser.parse(parser, a:line_n)
endfunction

