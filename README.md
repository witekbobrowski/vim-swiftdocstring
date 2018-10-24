# vim-swiftdocstring

A simple vim/neovim plugin that provides Xcode-like docstring templates for Swift.

## Installation

##### vim-plug
```
Plug 'witekbobrowski/vim-swiftdocstring'
```

##### Vundle 
```
Plugin 'witekbobrowski/vim-swiftdocstring'
```

##### Dein
```
call dein#add('witekbobrowski/vim-swiftdocstring')
```

## Usage
The interface provided by the plugin is super simple right now. Add the following
to your `.vimrc`

##### ⌨️ Mappings
```
" Generate docstring for current context
autocmd Filetype swift nnoremap <silent><tab>/ :SwiftDocstringCurrent<CR>
```

##### 🎛 Options
```
" Use Multi-line delimiter '/** ... */' instead of single-line '///'
let g:swiftdocstring#use_multi_line_delimiter = 1
```

## Documentation

```
:help swiftdocstring
```
