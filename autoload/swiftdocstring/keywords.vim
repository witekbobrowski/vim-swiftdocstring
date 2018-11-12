" 
"   keywords.vim
"   witekbobrowski/vim-swiftdocstring 
"
"   Created by Witek Bobrowski (witek@bobrowski.co).
"   Published under MIT license.
"

" Factory for different types of Swift keyword
function! g:swiftdocstring#keywords#factory() 
    let l:self = {}

    function! self.properties()
        return ['let', 'var']
    endfunction

    function! self.functions()
        return ['func', 'init']
    endfunction

    function! self.types()
        return ['protocol', 'struct', 'class', 'enum', 'typealias', 'associatedtype']
    endfunction

    function! self.all()
        return l:self.properties() + l:self.functions() + l:self.types()
    endfunction

    return l:self
endfunction
