" シンプルなターミナルトグル。
let g:terminal_bufnr = -1
if !exists('g:terminal_drawer_height')
  let g:terminal_drawer_height = 8
endif

function! ToggleTerminal() abort
  if &buftype ==# 'terminal'
    execute 'buffer #'
    execute 'close'
  else
    if bufexists(g:terminal_bufnr)
      split
      execute 'resize ' . g:terminal_drawer_height
      execute 'buffer ' . g:terminal_bufnr
      execute 'normal i'
    else
      terminal
      let g:terminal_bufnr = bufnr('%')
      call s:setup_terminal()
    endif
  endif
endfunction

function! s:setup_terminal() abort
  if exists('+termfinish')
    setlocal termfinish=close
  endif
  execute 'resize ' . g:terminal_drawer_height
  if exists('##TermClose')
    execute printf('autocmd! TerminalDrawer TermClose <buffer=%d>', bufnr('%'))
    execute printf('autocmd TerminalDrawer TermClose <buffer=%d> call <SID>terminal_closed(%d)', bufnr('%'), bufnr('%'))
  else
    execute printf('autocmd! TerminalDrawer BufWipeout <buffer=%d>', bufnr('%'))
    execute printf('autocmd TerminalDrawer BufWipeout <buffer=%d> call <SID>terminal_closed(%d)', bufnr('%'), bufnr('%'))
  endif
endfunction

function! s:terminal_closed(bufnr) abort
  if a:bufnr == g:terminal_bufnr
    let g:terminal_bufnr = -1
  endif
endfunction

augroup TerminalDrawer
  autocmd!
augroup END

tnoremap <silent> <C-t> <C-\><C-n>:call ToggleTerminal()<CR>
nnoremap <silent> <C-t> :call ToggleTerminal()<CR>
