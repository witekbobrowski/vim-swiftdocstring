" 
"   parser.vim
"   witekbobrowski/vim-swiftdocstring 
"
"   Created by Witek Bobrowski (witek@bobrowski.co).
"   Published under MIT license.
"

" Main function to trigger parsing process, which consists of retrievied the
" context from passed line and finally parsing it to the intermediate
" representation.
"
" Parameters
" - line_n: An intiger value referencinf the line number in current file
" - options: Dictionary with user defined or contex related options that could
"       be updated during the parsing procedure.
" Returns: Internal representation that got parsed
function! g:swiftdocstring#parser#parse(line_n, options)
    let l:context = s:get_context(a:line_n, a:options)
    return s:parse(l:context)
endfunction

" Retrive a list of numbers that represent lines that match any of the passed
" keywords
"
" Parameter keywords: a list of Swift keywords that shoudl be matched 
" Returns: A list of line numbers
function! g:swiftdocstring#parser#get_lines_of_keywords(keywords)
    let l:matched = []
    for line_number in range(0, line('$'))
        let l:line = getline(line_number)
        " Skip iteration if line is a comment
        if g:swiftdocstring#regex#is_comment(l:line)
            continue
        endif
        " Skip iteration if line is docstring
        if g:swiftdocstring#regex#is_docstring(l:line)
            continue
        endif
        let l:keyword = g:swiftdocstring#regex#match_keyword(l:line)
        " Skip if not a single function keyword was matched
        if index(a:keywords, l:keyword) == -1 
            continue
        endif
        " Skip iteration if the docstring already exists for the context
        if g:swiftdocstring#regex#is_docstring(getline(line_number - 1))
            continue
        endif
        " Add matched line number to the list
        call add(l:matched, line_number)
    endfor
    return l:matched
endfunction

function! s:get_context(line_n, options)
    " Skip iteration if line is a comment
    if g:swiftdocstring#regex#is_comment(getline(a:line_n))
        return [] 
    endif
    " Skip iteration if line is docstring
    if g:swiftdocstring#regex#is_docstring(getline(a:line_n))
        return [] 
    endif
    let l:lines = []
    let l:keyword = '' 
    " Traverse up to get keyword
    while empty(l:keyword) 
        " Break loop if reached beginning of file
        if a:line_n - len(l:lines) <= 0
            break
        endif
        let l:current = getline(a:line_n - len(l:lines))
    	let l:lines = [l:current] + l:lines
        let l:keyword = s:get_keyword([l:current])
    endwhile
    let a:options['target-line-number'] = a:line_n - len(l:lines) 
    let l:i = 0
    " Traverse down as long as the context is not full
    while !s:is_full_context(l:lines, l:keyword) 
		let l:i += 1
        " Break loop if reached end of file
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
    let l:keywords = g:swiftdocstring#keywords#factory()
    let l:context = g:swiftdocstring#utils#merge(a:lines)
    if index(l:keywords.functions(), a:keyword) >= 0
        return g:swiftdocstring#regex#is_full_function_context(l:context)
    elseif index(['enum'], a:keyword) >= 0
        return g:swiftdocstring#regex#is_full_enum_context(l:context)
    else
        return 1
    endif
endfunction

function! s:parse(lines)
    let l:keywords = g:swiftdocstring#keywords#factory()
    let l:keyword = s:get_keyword(a:lines) 
    if index(l:keywords.properties(), l:keyword) >= 0
        return {'property': {}}
    elseif index(l:keywords.types(), l:keyword) >= 0
        return s:parse_type(l:keyword, a:lines)
    elseif index(l:keywords.functions(), l:keyword) >= 0
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
    if swiftdocstring#regex#function_throws(l:context)
        let l:function_info['throws'] = 1
    endif
    if swiftdocstring#regex#function_returns(l:context)
        let l:function_info['returns'] = 1
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

