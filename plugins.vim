" この設定ディレクトリを基準に、オフラインでも動くように構成
let s:cfgdir = expand('<sfile>:p:h')
let plug_vim_path = s:cfgdir . '/autoload/plug.vim'

if filereadable(plug_vim_path)
  execute 'source' fnameescape(plug_vim_path)
  call plug#begin(s:cfgdir . '/plugged')
else
  echohl WarningMsg | echom 'vim-plug (autoload/plug.vim) が見つかりません。プラグインは読み込まれません。' | echohl None
endif
if exists('*plug#begin')
  Plug 'jiangmiao/auto-pairs'
  Plug 'lambdalisue/fern.vim'
  Plug 'joshdick/onedark.vim'
  Plug 'unblevable/quick-scope'
  Plug 'iaalm/terminal-drawer.vim'
  call plug#end()
endif

syntax enable
set background=dark
if exists('g:colors_name') || exists('*colorscheme')
  try | colorscheme onedark | catch | colorscheme default | endtry
endif

set splitright
set splitbelow

" Fern drawer toggle (map always; no-op if Fern missing)
nnoremap <silent> <C-e> :<C-u>silent! Fern . -reveal=% -drawer -toggle<CR>

" ======= Fern（存在する場合のみ FileType で適用）
augroup FernMappings
  autocmd!
  autocmd FileType fern call s:fern_custom_mappings()
augroup END

function! s:fern_custom_mappings() abort
  nnoremap <silent> <buffer> <CR> <Plug>(fern-action-open)
  nnoremap <silent> <buffer> -   <Plug>(fern-action-leave)
  nnoremap <silent> <buffer> <C-v> <Plug>(fern-action-open:vsplit)
  nnoremap <silent> <buffer> <C-x> <Plug>(fern-action-open:split)
endfunction

" ====== QuickScope

let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

highlight QuickScopePrimary guifg='#afff5f' gui=bold ctermfg=155 cterm=bold
highlight QuickScopeSecondary guifg='#5fffff' gui=bold ctermfg=81 cterm=bold

set complete=.,w,b,u
set path+=**
set completeopt=menu,menuone,noselect
