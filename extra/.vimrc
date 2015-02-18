set termencoding=utf-8
set nomodeline
map <F10> :set encoding=koi8-r<CR>
map <F11> :set encoding=8bit-cp1251<CR>
map <F12> :set encoding=utf-8<CR>

if v:progname =~? "evim"
  finish
endif

set nocompatible

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  autocmd BufEnter * let &titlestring = hostname() . " " . expand("%:p")

endif " has("autocmd")

"set autoindent
set autoread	"ar: automatically read a file when it was modified outside of Vim
set background=dark
set backspace=indent,eol,start
set backup
set breakat=\ \	!*+;,?	"brk: which characters might cause a line break
set gdefault
set guifont=8x13 
set history=50
set hlsearch
set ignorecase
set incsearch
set linebreak
set magic "change the way backslashes are used in search patterns
set modified
set noswapfile
set nolinebreak	"nolbr: wrap long lines at a character in 'breakat'
set ruler
set shiftwidth=4
set showcmd
set showmatch
set smartcase "scs: override 'ignorecase' when pattern has upper case characters
set smartindent
set smarttab
set startofline
set tabstop=4
set textwidth=220
set title
set titlelen=70
set titleold=""
set titlestring=%<%F%=%l/%L-%P
set viminfo='50,\"1000,:50,/50,%,n~/.viminfo
set wrapscan "ws: search commands wrap around the end of the buffer
set wildmenu	"wmnu: command-line completion shows a list of matches
set enc=utf-8
syntax sync ccomment
colorscheme elflord

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif


map Q gq
map <F5> i{<Esc>ea}<Esc>
map \p i(<Esc>ea)<Esc>
map <F7> :if exists("syntax_on") <Bar>
        \   syntax off <CR> 
        \ else <Bar>
        \   syntax enable <Bar>
        \ endif <CR>
