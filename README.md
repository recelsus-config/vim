## Dependencies

Works offline with bundled plugins. Optional for best experience:
- Truecolor terminal (for `termguicolors`)
- System clipboard support (for `clipboard+=unnamedplus`)

## Keymap List

### Tab Related Operations
- `<leader>1..9`: Go to tab 1..9
- `<leader>t`: Open a new tab (`:tabnew`)
- `<leader>q`: Close the current tab (`:tabclose`)

### File Explorer (Fern)
- `<C-e>`: Toggle Fern drawer at project root and reveal current file
- Inside Fern buffer
  - `<CR>`: Open
  - `-`: Go up one directory
  - `<C-v>`: Open in vertical split
  - `<C-x>`: Open in horizontal split

### Terminal Drawer
- `<C-t>`: Toggle terminal drawer (terminal-drawer.vim)

### Window Navigation
- Use default Vim: `<C-w> h/j/k/l`

### QuickScope
- Highlights targets for `f/F/t/T` to ease jump navigation

## Configuration Structure

- Core config: `vimrc`
- Plugins and UI tweaks: `plugins.vim`
- Plugin manager: `autoload/plug.vim` (vim-plug; bundled)
- Local plugins: `plugged/`

Bundled minimal plugins
- `joshdick/onedark.vim` (colorscheme)
- `unblevable/quick-scope` (jump hints)
- `jiangmiao/auto-pairs` (pairs)
- `lambdalisue/fern.vim` (file explorer)
- `iaalm/terminal-drawer.vim` (terminal)

## Notes

- Fern present: disables netrw and provides drawer on `<C-e>`.
- `<C-e>` is mapped in normal mode only; default scroll-down is replaced.
- Colorscheme tries `onedark`, falls back to `default`.
- Uses `termguicolors` and `unnamedplus` when available.

## How to Run

- Use this config temporarily:
  - `vim -u /home/reg/.vim/vimrc -U NONE -N`
    - `-u` pick this `vimrc`
    - `-U NONE` disable `gvimrc`
    - `-N` use 'nocompatible' mode

Portable launcher
- `vim/bin/vim-portable` executes `vim -u vimrc -U NONE -N`
