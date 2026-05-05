" --- environment file loading ---
let s:startup_cwd = getcwd()
let s:config_env_path = fnamemodify(expand('<sfile>:p:h:h') . '/.env', ':p')

function! s:trim(value) abort
  let l:value = substitute(a:value, '^\s\+', '', '')
  return substitute(l:value, '\s\+$', '', '')
endfunction

function! s:decode_double_quoted(value) abort
  let l:result = ''
  let l:index = 0
  while l:index < strlen(a:value)
    let l:char = a:value[l:index]
    if l:char ==# '\' && l:index + 1 < strlen(a:value)
      let l:index += 1
      let l:next = a:value[l:index]
      if l:next ==# 'n'
        let l:result .= "\n"
      elseif l:next ==# 'r'
        let l:result .= "\r"
      elseif l:next ==# 't'
        let l:result .= "\t"
      elseif l:next ==# '"'
        let l:result .= '"'
      elseif l:next ==# '\'
        let l:result .= '\'
      else
        let l:result .= l:next
      endif
    else
      let l:result .= l:char
    endif
    let l:index += 1
  endwhile
  return l:result
endfunction

function! s:parse_value(raw) abort
  let l:value = s:trim(a:raw)
  if empty(l:value)
    return ''
  endif

  let l:first = l:value[0]
  if l:first ==# "'"
    let l:last = match(l:value, "'", 1)
    if l:last == -1
      return strpart(l:value, 1)
    endif
    return strpart(l:value, 1, l:last - 1)
  endif

  if l:first ==# '"'
    let l:escaped = 0
    let l:index = 1
    while l:index < strlen(l:value)
      let l:char = l:value[l:index]
      if l:char ==# '"' && !l:escaped
        return s:decode_double_quoted(strpart(l:value, 1, l:index - 1))
      endif
      let l:escaped = l:char ==# '\' && !l:escaped
      let l:index += 1
    endwhile
    return s:decode_double_quoted(strpart(l:value, 1))
  endif

  return s:trim(substitute(l:value, '\s\+#.*$', '', ''))
endfunction

function! s:parse_line(line) abort
  let l:text = s:trim(a:line)
  if empty(l:text) || l:text[0] ==# '#'
    return [0, '', '']
  endif

  let l:text = substitute(l:text, '^export\s\+', '', '')
  let l:match = matchlist(l:text, '^\([A-Za-z_][A-Za-z0-9_]*\)\s*=\s*\(.*\)$')
  if empty(l:match)
    return [-1, '', 'invalid .env line: ' . a:line]
  endif

  return [1, l:match[1], s:parse_value(l:match[2])]
endfunction

function! s:resolve_path(path, base_dir) abort
  if empty(a:path)
    return ''
  endif
  if a:path =~# '^\(/\|[A-Za-z]:[\/\\]\)'
    return fnamemodify(a:path, ':p')
  endif
  return fnamemodify(a:base_dir . '/' . a:path, ':p')
endfunction

function! s:find_project_env() abort
  let l:dir = s:startup_cwd
  while 1
    let l:path = l:dir . '/.env'
    if filereadable(l:path)
      return fnamemodify(l:path, ':p')
    endif

    let l:parent = fnamemodify(l:dir, ':h')
    if l:parent ==# l:dir
      return ''
    endif
    let l:dir = l:parent
  endwhile
endfunction

function! s:env_load(path, ...) abort
  let l:opts = a:0 ? a:1 : {}
  let l:base_dir = get(l:opts, 'base_dir', getcwd())
  let l:silent = get(l:opts, 'silent', 0)
  let l:resolved = s:resolve_path(a:path, l:base_dir)
  if empty(l:resolved) || !filereadable(l:resolved)
    if !l:silent
      echohl WarningMsg
      echomsg 'Env file not found: ' . (empty(l:resolved) ? a:path : l:resolved)
      echohl None
    endif
    return 0
  endif

  let l:count = 0
  let l:errors = []
  let l:line_number = 1
  for l:line in readfile(l:resolved)
    let l:parsed = s:parse_line(l:line)
    if l:parsed[0] == 1
      call setenv(l:parsed[1], l:parsed[2])
      let l:count += 1
    elseif l:parsed[0] == -1
      call add(l:errors, printf('%s:%d: %s', l:resolved, l:line_number, l:parsed[2]))
    endif
    let l:line_number += 1
  endfor

  if !l:silent
    let l:message = printf('Loaded %d env vars from %s', l:count, l:resolved)
    if !empty(l:errors)
      let l:message .= printf(' (%d skipped)', len(l:errors))
      echohl WarningMsg
      echomsg l:message
      for l:error in l:errors
        echomsg l:error
      endfor
      echohl None
    else
      echomsg l:message
    endif
  endif
  return 1
endfunction

function! s:env_load_project(path) abort
  let l:target = empty(a:path) ? s:find_project_env() : a:path
  return s:env_load(l:target, {'base_dir': s:startup_cwd})
endfunction

if filereadable(s:config_env_path)
  call s:env_load(s:config_env_path, {'silent': 1})
endif

command! -nargs=? -complete=file EnvLoad call <SID>env_load_project(<q-args>)
