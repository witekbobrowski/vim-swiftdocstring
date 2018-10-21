if exists('g:loaded_after_object')
  finish
endif
let g:loaded_after_object = 1

function! swiftdocstring#template()
  let template = {}

  function! template.empty()
    return "///"
  endfunction

  function! template.simple()
    return "/// Description"
  endfunction

  function! template.parameters()
    return "/// - Parameters:"
  endfunction

  function! template.returns()
    return  "/// - Returns: return value description"
  endfunction

  function! template.parameter(parameter)
    return "///   - ". a:parameter. ": ". a:parameter. " description"
  endfunction

  function! template.enumCase(case)
    return "/// - ". a:case. ": ". a:case. " description"
  endfunction

  return template
endfunction

function! swiftdocstring#docstring()
    let template = swiftdocstring#template()
    echo template.simple()
endfunction
