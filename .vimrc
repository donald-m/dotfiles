set nocompatible                   "disable vi compatibility

"-- Autocomplete on command mode --
set wildmode=full                  "autocomplete filenames, help, etc.
set wildmenu                       "shows autocomplete options in a nice menu list
set wildignore=*.swp,*.bak,*.pyc   "ignore certain file types in autocompletion

"-- Syntax --
set termguicolors     " enable true colors support
let ayucolor="light"  " for light version of theme
filetype on                        "auto detect filetype
syntax on                          "syntax highlighting

"-- UI --
set shortmess=atI                  " Don't show the intro message when starting vim
set title                          " set the terminal title
set t_Co=256                       " set 256 colours
set background=dark 
colorscheme ayu
set ruler                          "show status line
set rulerformat=%10(%l,%c%V%)
set laststatus=2                   "always show status line
set cursorline                     "highlight current line
set relativenumber                 "show relatve line numbers
set numberwidth=5
set incsearch          		   " search as characters are entered
set hlsearch           		   " highlight matches
" insert space in normal mode on space bar
:nnoremap <space> i<space><esc>
