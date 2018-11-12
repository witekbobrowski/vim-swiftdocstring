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
    let l:keyword = s:get_keyword(l:lines)
    while empty(l:keyword) 
        if a:line_n - len(l:lines) < 0
            return []
        endif
        let l:current = getline(a:line_n - len(l:lines))
    	let l:lines = [l:current] + l:lines
        let l:keyword = s:get_keyword([l:current])
    endwhile
    let a:options['target-line-number'] = a:line_n - len(l:lines) 
    let l:i = 0
    while !s:is_full_context(l:lines, l:keyword) 
		let l:i += 1
        if a:line_n + l:i > line('$')
            return []
        endif
        let l:current = getline(a:line_n + l:i) 
        " Special check for function declarations in protocols
        " Return previous lines if current contains other keyword
        echom s:get_keyword([l:current])
        if l:keyword ==# 'func' && !empty(s:get_keyword([l:current]))
            return l:lines
        endif
        " Proceed normally
        call add(l:lines, l:current)
    endwhile
    return l:lines
endfunction

function! s:is_full_context(lines, keyword)
    let l:context = g:swiftdocstring#utils#merge(a:lines)
    if index(['let', 'var', 'protocol', 'class', 'struct'], a:keyword) >= 0
        return 1
    elseif 'enum' ==# a:keyword
        return g:swiftdocstring#regex#is_full_enum_context(l:context) != -1
    elseif index(['init', 'func'], a:keyword) >= 0
        return g:swiftdocstring#regex#is_full_function_context(l:context) != -1
    else
        return 0
    endif
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
    let l:function_info = {}
    let l:parameters = s:parse_function_parameters(l:context)
    if !empty(l:parameters)
        let l:function_info['parameters'] = l:parameters
    endif
    if swiftdocstring#regex#function_throws(l:context) != -1
        let l:function_info['throws'] = 'true'
    endif
    if swiftdocstring#regex#function_returns(l:context) != -1
        let l:function_info['returns'] = 'true'
    endif
    return {'function': l:function_info}
endfunction

function! s:parse_function_parameters(context)
    let l:raw = g:swiftdocstring#regex#match_function_parameters(a:context)
    let l:parameters = []
    for raw_param in split(l:raw, ',')
        let l:components = split(raw_param, ':')
        call add(l:parameters, split(l:components[0], ' ')[-1])
    endfor
    return l:parameters
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
    let l:context = g:swiftdocstring#utils#merge(a:lines)
    let l:cases = g:swiftdocstring#regex#match_enum_cases(l:context)
    return {'cases': l:cases}
endfunction

function! s:get_keyword(lines)
    let l:context = g:swiftdocstring#utils#merge(a:lines)
    return g:swiftdocstring#regex#match_keyword(l:context)
endfunction
