" 
"   parser.vim
"   witekbobrowski/vim-swiftdocstring 
"
"   Created by Witek Bobrowski (witek@bobrowski.co).
"   Published under MIT license.
"

function! g:swiftdocstring#parser#parse(line_n, options)
    let l:context = s:get_context(a:line_n, a:options)
    let l:converted = s:parse(l:context)
    return l:converted
endfunction

function! s:get_context(line_n, options)
    let l:lines = [getline(a:line_n)]
    let l:main_keyword = s:get_keyword(l:lines)
    while empty(l:main_keyword) 
        if a:line_n - len(l:lines) < 0
            return []
        endif
    	let l:lines = [getline(a:line_n - len(l:lines))] + l:lines
        let l:main_keyword = s:get_keyword(l:lines)
    endwhile
    let a:options['target-line-number'] = a:line_n - len(l:lines) 
    let l:i = 0
    while !s:is_full_context(l:lines, l:main_keyword) 
        if a:line_n + l:i > line('$')
            return []
        endif
		let l:i += 1
    	let l:lines += [getline(a:line_n + l:i)]
    endwhile
    return l:lines
endfunction

function! s:parse(lines)
    let l:keyword = s:get_keyword(a:lines) 
    if index(['let', 'var'], l:keyword) >= 0
        return {'property': {}}
    elseif index(['protocol', 'class', 'struct', 'enum'], l:keyword) >= 0
        return s:parse_type(l:keyword, a:lines)
    elseif index(['init', 'func'], l:keyword) >= 0
        return s:parse_function(a:lines)
    else 
        return {}
    endif
endfunction

function! s:parse_function(lines)
    let l:context = swiftdocstring#utils#merge(a:lines)  
    let l:raw_parameters = swiftdocstring#regex#function_parameters(l:context)
    let l:parameters = []
    for raw_parameter in split(l:raw_parameters, ',')
        let l:components = split(raw_parameter, ':')
        call add(l:parameters, split(l:components[0], ' ')[-1])
    endfor
    let l:function_info = {}
    if len(l:parameters) != 0
        let l:function_info = {'parameters': l:parameters}
    endif
    if swiftdocstring#regex#function_throws(l:context) != -1
        let l:function_info['throws'] = 'true'
    endif
    if swiftdocstring#regex#function_returns(l:context) != -1
        let l:function_info['returns'] = 'true'
    endif
    return {'function': l:function_info}
endfunction

function! s:parse_type(type, lines)
    let l:type_info = {}
    if 'enum' ==# a:type
        let l:type_info[a:type] = s:parse_enum(a:lines)
    else
        let l:type_info[a:type] = {}
    endif
    return {'type': l:type_info}
endfunction

function! s:parse_enum(lines)
    let l:cases = []
    for line in a:lines
        let l:cases += s:match_cases(line) 
    endfor
    return {'cases': l:cases}
endfunction

function! s:get_keyword(lines)
    let l:keywords = ['let', 'var', 'protocol', 'class', 'struct', 'enum', 'func', 'init']
    for line in a:lines
        let l:matched = s:match_line(line, l:keywords) 
        if !empty(l:matched)
            return l:matched
        endif 
    endfor
    return ''
endfunction

function! s:is_full_context(lines, keyword)
    if index(['let', 'var', 'protocol', 'class', 'struct'], a:keyword) >= 0
        return 1
    elseif 'enum' ==# a:keyword
        return s:is_full_enum_scope(a:lines)
    elseif index(['init', 'func'], a:keyword) >= 0
        return s:is_full_func_scope(a:lines)
    else
        return 0
    endif
endfunction

function! s:is_full_enum_scope(lines, keyword)
	" TODO: Check if all the context for docstring is present 
    let l:full_scope_regex = '\v\{\n((\t.*\n)|(^$\n))*^\}'
    return 1
endfunction

function! s:is_full_func_scope(lines)
    for line in a:lines
        if line =~# '{'
            return 1
        endif
    endfor
    return 0
endfunction

function! s:match_cases(line, keywords)
    let l:cases = []
    return l:cases
endfunction

function! s:match_line(line, keywords)
    for keyword in a:keywords
        if a:line =~ '\<' . keyword . '\>'
            return keyword 
        endif
    endfor
    return 0
endfunction

