set number
set noerrorbells
set nowritebackup
set nobackup
set nowrap

set virtualedit=block
set backspace=indent,eol,start
set ambiwidth=double
set wildmenu
set shellslash
set showmatch
set matchtime=1
set cinoptions+=:0
set hlsearch
set incsearch
set cursorline
set showtabline=2
set showcmd
set display=lastline

set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2

set guioptions-=T
set guioptions+=a
set smartindent
set noswapfile
set title
set clipboard+=unnamed,autoselect
set ignorecase
set smartcase
set wrapscan

set nrformats=
set whichwrap=b,s,h,l,<,>,[,],~
set mouse=a
filetype on
set cmdheight=2
autocmd BufWritePre * :%s/\s\+$//ge

set encoding=utf-8
set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8
set modeline
syntax on

if !has('nvim') | set viminfofile=$XDG_CACHE_HOME/vim/viminfo | endif
source ~/.vim/plugins.vim
