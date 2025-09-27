この `vim` ディレクトリは、Neovim 設定（`nvim`）に近い使い勝手を保ちつつ、依存プラグインを最小限にした Vim 用の軽量構成です。低スペック環境やオフライン環境を想定しています。

使い方
- 一時的にこの設定のみを使って起動する場合:
  - `vim -u /path/to/repo/vim/vimrc -U NONE -N`
    - `-u` でこの `vimrc` を指定
    - `-U NONE` で GUI 用の `gvimrc` を無効化
    - `-N` で 'nocompatible' モード（Vi 互換オフ）

方針
- オフライン動作を重視し、vim-plug の自動インストールは行いません。
- すでに同梱されているプラグイン（`vim/plugged/*`）をそのまま利用します。
- `vim/plugins.vim` は自身のフォルダを起点にプラグインと `autoload/plug.vim` を解決します。
- `autoload/plug.vim` が無い場合はプラグインを読み込まず、コア設定のみで動作します。

含まれるプラグイン（最小構成）
- onedark.vim（配色）
- quick-scope（`f/F/t/T` のジャンプ補助）
- auto-pairs（括弧自動補完）
- fern.vim（ファイラ、存在時のみマッピングを定義）
- terminal-drawer.vim（簡易ターミナルドロワ）

補足
- `vim/plugins.vim` 内の Fern 設定・マッピングは `:Fern` コマンドが存在する場合のみ有効化されます（プラグイン未読込時は安全に無効）。
- 配色は `onedark` を試し、失敗時は `default` にフォールバックします。
