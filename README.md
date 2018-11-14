# vim-swiftdocstring

A simple vim/neovim plugin that provides Xcode-like docstring templates for Swift.

## Features

- Generate Swift docstrings for types, funcitons and properties
- Support for `///` and `/** ... */` delimiters 
- Xcode-like style of docstrings 
- Context awarness that puts Xcode docstring generation to shame
- Blazing fast parsing using regular expressions
- Zero dependency (**100%** vim-script)

## Installation

##### vim-plug
```vim
Plug 'witekbobrowski/vim-swiftdocstring'
```

##### Vundle 
```vim
Plugin 'witekbobrowski/vim-swiftdocstring'
```

##### Dein
```vim
call dein#add('witekbobrowski/vim-swiftdocstring')
```

## Usage
The interface provided by the plugin is super simple right now. Add the following
to your `.vimrc`

##### ⌨️ Mappings
```vim
" Generate docstring for current context on 'Tab' + '/'
autocmd Filetype swift nnoremap <silent><tab>/ :SwiftDocstringCurrent<CR>
```

##### 🎛 Options
```vim
" Use Multi-line delimiter '/** ... */' instead of single-line '///'
let g:swiftdocstring#use_multi_line_delimiter = 1
```

## Documentation

```vim
:help swiftdocstring
```
