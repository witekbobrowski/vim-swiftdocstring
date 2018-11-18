" 
"   template.vim
"   witekbobrowski/vim-swiftdocstring 
"
"   Created by Witek Bobrowski (witek@bobrowski.co).
"   Published under MIT license.
"

" Factory of single line templates designated to use in docstring builder
function! g:swiftdocstring#template#factory()
    let self = {}
    
    function! self.single_line()
        return '///'
    endfunction
    
    function! self.multi_line_begin()
        return '/**'
    endfunction

    function! self.multi_line_end()
        return '*/' 
    endfunction

    function! self.empty()
        return ''
    endfunction

    function! self.simple()
        return '<#Description#>'
    endfunction
    
    function! self.parameters()
        return '- Parameters:'
    endfunction

    function! self.returns()
        return '- Returns: return value description'
    endfunction

    function! self.throws()
        return '- Throws: throws value description'
    endfunction

    function! self.parameter_single(parameter)
        return '- Parameter ' . a:parameter . ': ' . a:parameter . ' description'
    endfunction
    
    function! self.parameter(parameter)
        return '  - '. a:parameter . ': ' . a:parameter . ' description'
    endfunction

    function! self.enumCase(case)
        return '- ' . a:case . ': ' . a:case . ' description'
    endfunction

    return self
endfunction
