" 
"   swiftdocstring.vim
"   witekbobrowski/vim-swiftdocstring 
"
"   Created by Witek Bobrowski (witek@bobrowski.co).
"   Published under MIT license.
"

if exists('g:loaded_swiftdocstring')
    finish
endif
let g:loaded_swiftdocstring = 1

" Public commands
command! -nargs=0 SwiftDocstringCurrent call g:swiftdocstring#docstring_current()
command! -nargs=0 SwiftDocstringFunctions call g:swiftdocstring#docstring_functions()
command! -nargs=0 SwiftDocstringTypes call g:swiftdocstring#docstring_types()

" User defined options
let g:swiftdocstring#use_multi_line_delimiter = 0
