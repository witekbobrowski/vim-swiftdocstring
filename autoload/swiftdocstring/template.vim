" 
"   template.vim
"   witekbobrowski/vim-swiftdocstring 
"
"   Created by Witek Bobrowski (witek@bobrowski.co).
"   Published under MIT license.
"

" Factory of single line templates designated to use in docstring builder
function! swiftdocstring#template#factory()
    let template = {}
    
    function! template.single_line()
        return '///'
    endfunction
    
    function! template.multi_line_begin()
        return '/**'
    endfunction

    function! template.multi_line_end()
        return '*/' 
    endfunction

    function! template.empty()
        return ''
    endfunction

    function! template.simple()
        return ' Description'
    endfunction
    
    function! template.parameters()
        return ' - Parameters:'
    endfunction

    function! template.returns()
        return ' - Returns: return value description'
    endfunction

    function! template.throws()
        return ' - Throws: throws value description'
    endfunction

    function! template.parameter_single(parameter)
        return ' - Parameter ' . a:parameter . ': ' . a:parameter . ' description'
    endfunction
    
    function! template.parameter(parameter)
        return '   - '. a:parameter . ': ' . a:parameter . ' description'
    endfunction

    function! template.enumCase(case)
        return ' - ' . a:case . ': ' . a:case . ' description'
    endfunction

    return template
endfunction
