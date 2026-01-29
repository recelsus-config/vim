" --- netrw display defaults ---
let g:netrw_banner = 0
let g:netrw_liststyle = 1
let g:netrw_winsize = 20
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_keepdir = 0

" --- netrw drawer root ---
function! s:netrw_reveal_dir() abort
  let l:dir = expand('%:p:h')
  if empty(l:dir)
    let l:dir = getcwd()
  endif
  return l:dir
endfunction

" --- find active netrw window ---
function! s:netrw_winnr() abort
  for l:win in range(1, winnr('$'))
    let l:buf = winbufnr(l:win)
    if getbufvar(l:buf, '&filetype') ==# 'netrw'
      return l:win
    endif
  endfor
  return -1
endfunction

" --- toggle netrw drawer ---
function! s:netrw_toggle() abort
  let l:win = s:netrw_winnr()
  if l:win != -1
    execute l:win . 'wincmd q'
  else
    execute 'Lexplore ' . fnameescape(s:netrw_reveal_dir())
  endif
endfunction

nnoremap <silent> <C-e> :call <SID>netrw_toggle()<CR>

" --- netrw mappings ---
augroup NetrwMappings
  autocmd!
  autocmd FileType netrw call s:netrw_custom_mappings()
augroup END

function! s:netrw_custom_mappings() abort
  nmap <silent> <buffer> <CR> v
  nmap <silent> <buffer> <C-v> v
  silent! nunmap <buffer> <C-x>
  nnoremap <silent> <buffer> <C-w>h :<C-u>wincmd h<CR>
  nnoremap <silent> <buffer> <C-w>j :<C-u>wincmd j<CR>
  nnoremap <silent> <buffer> <C-w>k :<C-u>wincmd k<CR>
  nnoremap <silent> <buffer> <C-w>l :<C-u>wincmd l<CR>
endfunction
