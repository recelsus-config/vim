" --- Pair completion helpers ---
let s:bracket_pairs = {
      \ '(': ')',
      \ '[': ']',
      \ '{': '}',
      \ }
let s:quote_chars = ['"', "'", '`']

function! s:pairs_open(char) abort
  return a:char . s:bracket_pairs[a:char] . "\<Left>"
endfunction

function! s:pairs_close(char) abort
  let l:line = getline('.')
  let l:col = col('.')
  if l:col <= len(l:line) && l:line[l:col - 1] ==# a:char
    return "\<Right>"
  endif
  return a:char
endfunction

function! s:pairs_quote(char) abort
  let l:line = getline('.')
  let l:col = col('.')
  let l:right = l:col <= len(l:line) ? l:line[l:col - 1] : ''
  if l:right ==# a:char
    return "\<Right>"
  endif
  return a:char . a:char . "\<Left>"
endfunction

function! s:pairs_backspace() abort
  let l:line = getline('.')
  let l:col = col('.')
  if l:col <= 1
    return "\<BS>"
  endif
  let l:left = l:line[l:col - 2]
  let l:right = l:col <= len(l:line) ? l:line[l:col - 1] : ''
  if (has_key(s:bracket_pairs, l:left) && s:bracket_pairs[l:left] ==# l:right)
        \ || (index(s:quote_chars, l:left) != -1 && l:left ==# l:right)
    return "\<BS>\<Del>"
  endif
  return "\<BS>"
endfunction

function! s:escape_key(char) abort
  return printf('<Char-%d>', char2nr(a:char))
endfunction

function! s:define_bracket(open) abort
  execute printf('inoremap <silent> <expr> %s <SID>pairs_open(%s)', s:escape_key(a:open), string(a:open))
  execute printf('inoremap <silent> <expr> %s <SID>pairs_close(%s)', s:escape_key(s:bracket_pairs[a:open]), string(s:bracket_pairs[a:open]))
endfunction

for s:open in keys(s:bracket_pairs)
  call s:define_bracket(s:open)
endfor

for s:quote in s:quote_chars
  execute printf('inoremap <silent> <expr> %s <SID>pairs_quote(%s)', s:escape_key(s:quote), string(s:quote))
endfor

inoremap <silent> <expr> <BS> <SID>pairs_backspace()
