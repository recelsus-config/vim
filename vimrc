" Neovim-like lightweight defaults
let mapleader = ' '

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
set clipboard+=unnamedplus
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
set fileencodings=utf-8
set modeline
syntax on

" Neovim-like behavior tweaks
set hidden
if has('termguicolors')
  set termguicolors
endif
if has('clipboard')
  set clipboard+=unnamedplus
endif
set signcolumn=yes

if !has('nvim') | set viminfofile=$XDG_CACHE_HOME/vim/viminfo | endif

set splitright
set splitbelow
set complete=.,w,b,u
set path+=**
set completeopt=menu,menuone,noselect

" conf.d 以下を順に読み込む
let s:cfgdir = expand('<sfile>:p:h')
for s:conf in glob(s:cfgdir . '/conf.d/*.vim', 0, 1)
  execute 'source' fnameescape(s:conf)
endfor

" Simple tab operations
nnoremap <silent> <leader>t :tabnew<CR>
nnoremap <silent> <leader>q :tabclose<CR>
for i in range(1, 9)
  execute 'nnoremap <silent> <leader>'.i.' '.i.'gt'
endfor
