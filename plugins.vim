let plug_vim_path = expand('~/.vim/autoload/plug.vim')

if !filereadable(plug_vim_path)
  echo "Installing vim-plug..."
  silent execute '!curl -fLo ' . plug_vim_path . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'jiangmiao/auto-pairs'
Plug 'lambdalisue/fern.vim'
Plug 'joshdick/onedark.vim'
Plug 'unblevable/quick-scope'
Plug 'iaalm/terminal-drawer.vim'

call plug#end()

syntax enable
set background=dark
colorscheme onedark

set splitright
set splitbelow

" ======= Fern

let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1

nmap <C-e> :Fern . -reveal=% -drawer -toggle<CR>

augroup FernMappings
  autocmd!
  autocmd FileType fern call s:fern_custom_mappings()
augroup END

function! s:fern_custom_mappings() abort
  nmap <buffer> <Enter> <Plug>(fern-action-open)
  nmap <buffer> - <Plug>(fern-action-leave)

  nmap <buffer> <C-v> <Plug>(fern-action-open:vsplit)
  nmap <buffer> <C-x> <Plug>(fern-action-open:split)
endfunction

" ====== QuickScope

let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

highlight QuickScopePrimary guifg='#afff5f' gui=bold ctermfg=155 cterm=bold
highlight QuickScopeSecondary guifg='#5fffff' gui=bold ctermfg=81 cterm=bold

set complete=.,w,b,u
set path+=**
set completeopt=menu,menuone,noselect
