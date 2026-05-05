" --- netrw display defaults ---
let g:netrw_banner = 0
let g:netrw_liststyle = 1
let g:netrw_winsize = 20
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_keepdir = 0

" --- netrw drawer size ---
function! s:netrw_drawer_width() abort
  return max([20, (&columns * get(g:, 'netrw_winsize', 20)) / 100])
endfunction

" Keep the netrw view compact after it was left as the only window.
function! s:netrw_resize_drawer() abort
  let l:win = s:netrw_winnr()
  if l:win == -1 || winnr('$') == 1
    return
  endif

  let l:current = winnr()
  execute l:win . 'wincmd w'
  execute 'vertical resize ' . s:netrw_drawer_width()
  setlocal winfixwidth
  execute l:current . 'wincmd w'
endfunction

function! s:netrw_balance_edit_windows() abort
  call s:netrw_resize_drawer()
  if s:netrw_winnr() == -1 || winnr('$') <= 2
    return
  endif

  let l:current = winnr()
  wincmd =
  execute l:current . 'wincmd w'
endfunction

" --- netrw file open ---
function! s:netrw_target_winnr() abort
  let l:previous = winnr('#')
  if l:previous > 0 && l:previous <= winnr('$')
    let l:buf = winbufnr(l:previous)
    if getbufvar(l:buf, '&filetype') !=# 'netrw' && winwidth(l:previous) > s:netrw_drawer_width()
      return l:previous
    endif
  endif

  let l:target = -1
  let l:target_width = 0
  for l:win in range(1, winnr('$'))
    let l:buf = winbufnr(l:win)
    if getbufvar(l:buf, '&filetype') !=# 'netrw' && winwidth(l:win) > l:target_width
      let l:target = l:win
      let l:target_width = winwidth(l:win)
    endif
  endfor
  return l:target
endfunction

function! s:netrw_selected_path() abort
  if !exists('*netrw#Call')
    return ''
  endif

  let l:path = netrw#Call('NetrwBrowseChgDir', 1, netrw#Call('NetrwGetWord'), 1)
  if empty(l:path)
    return ''
  endif
  if isdirectory(l:path)
    call netrw#LocalBrowseCheck(l:path)
    return ''
  endif
  return l:path
endfunction

function! s:netrw_current_path() abort
  if !exists('*netrw#Call') || !exists('b:netrw_curdir')
    return ''
  endif

  let l:name = netrw#Call('NetrwGetWord')
  if empty(l:name) || l:name ==# './' || l:name ==# '../'
    return ''
  endif
  if l:name =~# '^\(/\|\a:\)'
    return l:name
  endif
  return b:netrw_curdir . '/' . l:name
endfunction

function! s:netrw_refresh() abort
  if &filetype !=# 'netrw' || !exists('b:netrw_curdir')
    return
  endif

  let l:dir = b:netrw_curdir
  if exists('*netrw#Call')
    silent! call netrw#Call('NetrwRefresh', 1, l:dir)
  else
    silent! call netrw#LocalBrowseCheck(l:dir)
  endif
endfunction

function! s:netrw_create_file() abort
  let l:base = exists('b:netrw_curdir') ? b:netrw_curdir . '/' : getcwd() . '/'
  let l:path = input('New file: ', l:base, 'file')
  if empty(l:path)
    return
  endif
  let l:path = fnamemodify(l:path, ':p')
  if filereadable(l:path) || isdirectory(l:path)
    echoerr 'Path already exists: ' . l:path
    return
  endif

  let l:dir = fnamemodify(l:path, ':h')
  if !isdirectory(l:dir)
    echoerr 'Directory does not exist: ' . l:dir
    return
  endif

  call writefile([], l:path)
  call s:netrw_refresh()
endfunction

function! s:netrw_rename_file() abort
  let l:old_path = s:netrw_current_path()
  if empty(l:old_path)
    return
  endif

  let l:new_path = input('Rename to: ', l:old_path, 'file')
  if empty(l:new_path) || l:new_path ==# l:old_path
    return
  endif
  let l:new_path = fnamemodify(l:new_path, ':p')
  if filereadable(l:new_path) || isdirectory(l:new_path)
    echoerr 'Path already exists: ' . l:new_path
    return
  endif

  let l:dir = fnamemodify(l:new_path, ':h')
  if !isdirectory(l:dir)
    echoerr 'Directory does not exist: ' . l:dir
    return
  endif
  if rename(l:old_path, l:new_path) != 0
    echoerr 'Rename failed: ' . l:old_path
    return
  endif

  call s:netrw_refresh()
endfunction

function! s:netrw_delete_file() abort
  let l:path = s:netrw_current_path()
  if empty(l:path)
    return
  endif

  let l:message = isdirectory(l:path) ? 'Delete directory recursively ' . l:path . '?' : 'Delete ' . l:path . '?'
  let l:answer = confirm(l:message, "&Yes\n&No", 2)
  if l:answer != 1
    return
  endif

  if isdirectory(l:path)
    if delete(l:path, 'rf') != 0
      echoerr 'Delete failed: ' . l:path
      return
    endif
  elseif filereadable(l:path)
    if delete(l:path) != 0
      echoerr 'Delete failed: ' . l:path
      return
    endif
  else
    echoerr 'Path does not exist: ' . l:path
    return
  endif

  call s:netrw_refresh()
endfunction

function! s:netrw_edit_open() abort
  let l:path = s:netrw_selected_path()
  if empty(l:path)
    return
  endif

  let l:target = s:netrw_target_winnr()
  if l:target == -1
    execute 'keepalt vertical rightbelow split ' . fnameescape(l:path)
    setlocal nowinfixwidth
    call s:netrw_resize_drawer()
    return
  endif

  execute l:target . 'wincmd w'
  execute 'keepalt edit ' . fnameescape(l:path)
  setlocal nowinfixwidth
  call s:netrw_resize_drawer()
endfunction

function! s:netrw_split_open(cmd) abort
  let l:path = s:netrw_selected_path()
  if empty(l:path)
    return
  endif

  let l:target = s:netrw_target_winnr()
  if l:target != -1
    execute l:target . 'wincmd w'
  endif

  execute 'keepalt rightbelow ' . a:cmd . ' ' . fnameescape(l:path)
  setlocal nowinfixwidth
  if a:cmd ==# 'vertical split'
    call s:netrw_resize_drawer()
  endif
endfunction

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
    call s:netrw_balance_edit_windows()
  endif
endfunction

nnoremap <silent> <C-e> :call <SID>netrw_toggle()<CR>

" --- netrw mappings ---
augroup NetrwMappings
  autocmd!
  autocmd FileType netrw call s:netrw_custom_mappings()
  autocmd FileType netrw call s:netrw_resize_drawer()
  autocmd BufWinEnter * call s:netrw_resize_drawer()
augroup END

function! s:netrw_custom_mappings() abort
  nnoremap <silent> <buffer> <CR> :<C-u>call <SID>netrw_edit_open()<CR>
  nnoremap <silent> <buffer> <C-v> :<C-u>call <SID>netrw_split_open('vertical split')<CR>
  nnoremap <silent> <buffer> <C-x> :<C-u>call <SID>netrw_split_open('split')<CR>
  nnoremap <silent> <buffer> a :<C-u>call <SID>netrw_create_file()<CR>
  nnoremap <silent> <buffer> r :<C-u>call <SID>netrw_rename_file()<CR>
  nnoremap <silent> <buffer> d :<C-u>call <SID>netrw_delete_file()<CR>
  nnoremap <silent> <buffer> <C-w>h :<C-u>wincmd h<CR>
  nnoremap <silent> <buffer> <C-w>j :<C-u>wincmd j<CR>
  nnoremap <silent> <buffer> <C-w>k :<C-u>wincmd k<CR>
  nnoremap <silent> <buffer> <C-w>l :<C-u>wincmd l<CR>
endfunction
