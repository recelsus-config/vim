## 依存関係

同梱プラグインのみでオフライン動作します。推奨環境:
- Truecolor 対応端末（`termguicolors` 用）
- システムクリップボード対応（`clipboard+=unnamedplus` 用）

## キーマップ一覧

### タブ操作
- `<leader>1..9`: 1..9 番目のタブへ移動
- `<leader>t`: 新しいタブを開く（`:tabnew`）
- `<leader>q`: 現在のタブを閉じる（`:tabclose`）

### ファイラ（Fern）
- `<C-e>`: プロジェクトルートで Fern ドロワをトグル＋現在ファイルへリビール
- Fern バッファ内
  - `<CR>`: 開く
  - `-`: 一つ上のディレクトリへ
  - `<C-v>`: 縦分割で開く
  - `<C-x>`: 横分割で開く

### ターミナルドロワ
- `<C-t>`: ターミナルをトグル（terminal-drawer.vim）

### ウィンドウ移動
- Vim の既定を使用: `<C-w> h/j/k/l`

### QuickScope
- `f/F/t/T` のジャンプ先を強調表示し、移動を補助します

## 構成

- コア設定: `vimrc`
- プラグインと UI 調整: `plugins.vim`
- プラグインマネージャ: `autoload/plug.vim`（vim-plug。同梱）
- ローカルプラグイン: `plugged/`

同梱プラグイン（最小構成）
- `joshdick/onedark.vim`（配色）
- `unblevable/quick-scope`（ジャンプ補助）
- `jiangmiao/auto-pairs`（括弧補完）
- `lambdalisue/fern.vim`（ファイラ）
- `iaalm/terminal-drawer.vim`（ターミナル）

## 備考

- Fern が有効な場合は netrw を無効化し、`<C-e>` でドロワを提供します。
- `<C-e>` はノーマルモードのみで Fern に割り当てています（既定の 1 行スクロールは置き換え）。
- 配色は `onedark` を試し、失敗時は `default` にフォールバックします。
- 端末が対応していれば `termguicolors` と `unnamedplus` を有効化します。

## 起動方法

- 一時的にこの設定のみを使う場合:
  - `vim -u /home/reg/.vim/vimrc -U NONE -N`
    - `-u` でこの `vimrc` を指定
    - `-U NONE` で `gvimrc` を無効化
    - `-N` で 'nocompatible' モード

ポータブルランチャー
- `vim/bin/vim-portable` は `vim -u vimrc -U NONE -N` を実行します
