" --- Persistent undo ---
if has('persistent_undo')
  let s:undo_path = expand('~/.vim/undo')
  if !isdirectory(s:undo_path)
    call mkdir(s:undo_path, 'p')
  endif
  let &undodir = s:undo_path
  set undofile
endif
