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
    let template = swiftdocstring#template()
	let l:line_n = line('.') - 1
    let l:text = swiftdocstring#indented(template.simple(), indent(line('.')))
    call swiftdocstring#output(l:text, l:line_n)
endfunction

function! swiftdocstring#output(text, line_number)
    call append(a:line_number, a:text)
endfunction

function! swiftdocstring#indented(text, n_spaces)
    let l:prefix = repeat(' ', a:n_spaces)
    return l:prefix . a:text
endfunction

