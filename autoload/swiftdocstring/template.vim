" 
"   template.vim
"   witekbobrowski/vim-swiftdocstring 
"
"   Created by Witek Bobrowski (witek@bobrowski.co).
"   Published under MIT license.
"

" Factory of single line templates designated to use in docstring builder
function! g:swiftdocstring#template#factory(options)
    let self = {'options': a:options}
    
    function! self.placeholder(text)
        let l:options = self['options']
        if !l:options['use-placeholder']
            return a:text
        endif
        let l:open = l:options['placeholder-open']
        let l:close = l:options['placeholder-close']
        return l:open . a:text . l:close
    endfunction

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
        return self.placeholder('Description')
    endfunction
    
    function! self.parameters()
        return '- Parameters:'
    endfunction

    function! self.returns()
        let l:placeholder = self.placeholder('return value description')
        return '- Returns: ' . l:placeholder
    endfunction

    function! self.throws()
        let l:placeholder = self.placeholder('throws value description')
        return '- Throws: ' . l:placeholder
    endfunction

    function! self.parameter_single(parameter)
        let l:placeholder = self.placeholder(a:parameter . ' description')
        return '- Parameter ' . a:parameter . ': ' . l:placeholder 
    endfunction
    
    function! self.parameter(parameter)
        let l:placeholder = self.placeholder(a:parameter . ' description')
        return '  - '. a:parameter . ': ' . l:placeholder
    endfunction

    function! self.enumCase(case)
        let l:placeholder = self.placeholder(a:case . ' description')
        return '- ' . a:case . ': ' . l:placeholder 
    endfunction

    return self
endfunction
