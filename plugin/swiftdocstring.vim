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

" Public command
command! -nargs=0 SwiftDocstringCurrent call g:swiftdocstring#docstring_current()

" User defined options
let g:swiftdocstring#use_multi_line_delimiter = 0
