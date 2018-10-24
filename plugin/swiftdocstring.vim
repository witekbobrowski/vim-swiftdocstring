if exists('g:loaded_swiftdocstring')
    finish
endif
let g:loaded_swiftdocstring = 1

" Public command
command! -nargs=0 SwiftDocstringCurrent call swiftdocstring#docstring_current()

" User defined options
let g:swiftdocstring#use_multi_line_delimiter = 0