# dotfiles

個人 Mac / 仕事 Mac / 仕事 EC2(Ubuntu) で共有する dotfiles。
**GNU Stow + symlink** で管理する。共通設定のみを公開し、環境固有・秘密は各環境の
`*.local` ファイルで管理する。

## セットアップ（新環境）

```sh
ghq get github.com/nesheep5/dotfiles
cd ~/ghq/github.com/nesheep5/dotfiles
./bootstrap.sh
```

`bootstrap.sh` は冪等で、以下を行う:

1. Homebrew 導入 → `brew bundle`（コアツール）
2. `stow` で symlink 配置（ghostty は Mac のみ）
3. `*.local` テンプレートを生成（不在時のみ）
4. nvim 設定（別リポジトリ）を clone
5. fisher プラグイン復元 → fish をログインシェル化
6. `pre-commit` 有効化

## 日常運用

| 操作 | コマンド |
|---|---|
| 設定検証 | `make check` |
| symlink 配置 | `make stow` |
| 再配置 | `make restow` |
| symlink 解除 | `make unstow` |

設定ファイルは `~/.config/<tool>/...`（symlink）を直接編集すれば、このリポジトリの
実体が変わる。編集後は `make check` → このリポジトリでコミット。

## 環境固有・秘密の置き場所

公開リポジトリには共通設定のみを置く。環境固有・秘密は以下（`.gitignore` 済）:

- `~/.config/fish/config.local.fish`
- `~/.config/tmux/tmux.local.conf`
- `ghostty/.config/ghostty/config.local`（リポジトリ側に置く。ghostty の相対解決仕様による）
- `~/.gitconfig.local`

各 `*.example` をひな形として同梱している。

## 関連リポジトリ

- nvim 設定: [github.com/nesheep5/nvim](https://github.com/nesheep5/nvim)（別管理）

詳細な運用ルールは [CLAUDE.md](./CLAUDE.md) を参照。
