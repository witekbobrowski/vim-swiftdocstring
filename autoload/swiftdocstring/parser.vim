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
    if empty(l:context)
        return {}
    endif 
    return s:parse(l:context, a:options)
endfunction

" Retrive a list of numbers that represent lines that match any of the passed
" keywords
"
" Parameter keywords: a list of Swift keywords that shoudl be matched 
" Returns: A list of line numbers
function! g:swiftdocstring#parser#get_lines_of_keywords(keywords)
    let l:matched = []
    for line_number in range(0, line('$'))
        let l:keyword = s:get_keyword(line_number)
        " Skip if not a single requested keyword was matched
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

" Get keyword if present at line with passed keyword. This function rejects
" lines that are comments or docstrings.
"
" Parameter line_n: number of line in burrent buffer
" Returns: Keyword if gets matched, else empty string
function! s:get_keyword(line_n)
    let l:line = getline(a:line_n)
    " Return empty string if line is a comment
    if g:swiftdocstring#regex#is_comment(l:line)
        return ''
    endif
    " Return empty string if line is docstring
    if g:swiftdocstring#regex#is_docstring(l:line)
        return ''
    endif
    return g:swiftdocstring#regex#match_keyword(l:line)
endfunction

" Traverse up looking for a keyword in burrent buffer. This funciton will
" return negative value if beginning of the file was reached or it stumbled
" upon an empty line.
"
" Parameter line_n: number of line in burrent buffer
" Returns: Keyword if gets matched, else empty string
function! s:traverse_up_for_keyword(line_n)
    let l:line_number = a:line_n
    " While there are no keywords matched iterate over
    while empty(s:get_keyword(l:line_number)) 
        " If line is empty return with -1
        if empty(getline(l:line_number))
            return -1
        endif
        " Break loop if reached beginning of file
        if l:line_number <= 0
            return -1
        endif
        " Traverse one line above current
        let l:line_number -= 1
    endwhile
    return l:line_number
endfunction

" Retrive context for passed line that will be used for parsing to
" intermediate representation.
"
" Parameters
" - line_n: An intiger value referencinf the line number in current file
" - options: Dictionary with user defined or contex related options that could
"       be updated during the parsing procedure.
" Returns: List of lines relative to the context 
function! s:get_context(line_n, options)
    " Skip iteration if line is a comment
    if g:swiftdocstring#regex#is_comment(getline(a:line_n))
        return [] 
    endif
    " Skip iteration if line is docstring
    if g:swiftdocstring#regex#is_docstring(getline(a:line_n))
        return [] 
    endif
    let l:current_line_n = s:traverse_up_for_keyword(a:line_n)
    " Return if could not get line for keyword
    if l:current_line_n ==# -1
        return []
    endif

    let l:lines = [getline(l:current_line_n)]
    let l:keyword = s:get_keyword(l:current_line_n) 
    let a:options['context-start-line-number'] = l:current_line_n

    " Traverse down as long as the context is not full
    while !s:is_full_context(l:lines, l:keyword) 
		let l:current_line_n += 1
        " Break loop if reached end of file
        if l:current_line_n > line('$')
            return []
        endif
        " Special check for function declarations in protocols
        " Return previous lines if current contains other keyword
        if l:keyword ==# 'func' && !empty(s:get_keyword(l:current_line_n))
            return l:lines
        endif
        " Proceed normally
        call add(l:lines, getline(l:current_line_n))
    endwhile
    return l:lines
endfunction

" Check if full context is present in lines for give keyword
"
" Parameters:
" - lines: List of lines
" - keyword: Swift keyword that defines how the context should look like
" Returns: A boolean (0 or 1) if requirements are met
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

" An actual parsing method that takes the lines with the context and converts
" them to an intermediate representation.
"
" Parameters:
" - lines: List of lines
" - options: Dictionary with options for parsing process 
" Returns: Internal representation 
function! s:parse(lines, options)
    let l:keywords = g:swiftdocstring#keywords#factory()
    let l:keyword = s:get_keyword(a:options['context-start-line-number']) 
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

" Helper function for parsing function context to intermediate representation
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

" Helper function for parsing function parameters 
function! s:parse_function_parameters(context)
    let l:raw = g:swiftdocstring#regex#match_function_parameters(a:context)
    let l:parameters = []
    for raw_param in split(l:raw, ',')
        let l:components = split(raw_param, ':')
        call add(l:parameters, split(l:components[0], ' ')[-1])
    endfor
    return l:parameters
endfunction

" Helper function for parsing type context to intermediate representation
function! s:parse_type(type, lines)
    let l:type_info = {}
    if 'enum' ==# a:type
        let l:type_info[a:type] = s:parse_enum(a:lines)
    else
        let l:type_info[a:type] = {}
    endif
    return {'type': l:type_info}
endfunction

" Helper function for parsing enums 
function! s:parse_enum(lines)
    let l:context = g:swiftdocstring#utils#merge(a:lines)
    let l:declarations = []
    for line in a:lines
        if g:swiftdocstring#regex#is_enum_case_declaration(line)
            call add(l:declarations, line)
        endif
    endfor
    echom len(l:declarations)
    let l:cases = []
    for line in l:declarations
        let l:cases += s:parse_enum_cases(line)
    endfor
    return {'cases': l:cases}
endfunction

function! s:parse_enum_cases(line)
    let l:cases = []
    let l:context = g:swiftdocstring#regex#match_cases_context(a:line)
    for word in split(l:context, ',')
        let l:stripped = g:swiftdocstring#regex#strip_enum_case_value(word)
        call add(l:cases, l:stripped)
    endfor
    return l:cases
endfunction
