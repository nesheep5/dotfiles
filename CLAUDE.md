# CLAUDE.md — dotfiles（GNU Stow 管理）

このリポジトリは Claude Code 経由での編集・管理を主な運用方法として設計されている。
作業時は以下を必ず守ること。

## このリポジトリの役割

全環境共通の dotfiles を **GNU Stow + symlink** で管理する。
個人 Mac / 仕事 Mac / 仕事 EC2(Ubuntu) で共有する。**公開リポジトリ**である。

- 管理ツール本体は最小限（Stow のみ）。バージョン固定や CI は意図的に持たない（シンプル優先）
- nvim 設定は別リポジトリ（github.com/nesheep5/nvim）。ここには含めず bootstrap で clone する

## ディレクトリ地図

```
fish/    .config/fish/{config.fish, fish_plugins}   ← fisher生成物は追跡しない
tmux/    .config/tmux/tmux.conf                       ← tpm の plugins/ は追跡しない
ghostty/ .config/ghostty/config                      ← Mac限定
starship/.config/starship.toml
mise/    .config/mise/config.toml
git/     {.gitconfig, .gitignore_global} + .config/git/ignore
Brewfile           全環境必須コアのみ（手キュレーション。全dumpしない）
bootstrap.sh       新環境セットアップ（冪等・Mac/Ubuntu両対応）
Makefile           check / stow / restow / unstow / bootstrap
```

各パッケージ内は `<pkg>/.config/<tool>/...` という Stow 流の構造で、`stow` 実行時に
`~`（ホーム）へミラーされる。

## 公開 NG（絶対にコミットしないもの）

**秘密情報・業務関連・社内固有設定は一切このリポジトリに入れない。** これは会社ポリシー。

環境固有・秘密は次のローカルファイル（`.gitignore` 済・各環境で手動作成）に置く:

| ファイル | 置くもの |
|---|---|
| `~/.config/fish/config.local.fish` | 仕事固有 alias / proxy / 社内ツール PATH |
| `~/.config/tmux/tmux.local.conf` | 環境固有の tmux 設定 |
| `ghostty/.config/ghostty/config.local`（リポジトリ側） | font-size / window-size / Mac固有 keybind |
| `~/.gitconfig.local` | 1Password 署名パス / signingkey / hooksPath（環境依存） |

> ghostty の `config.local` だけは扱いが特殊で **実体＋symlink の2段構え**。
> `config-file = ?config.local` の相対パスは「メイン config ファイルの置き場所」
> （＝ `~/.config/ghostty/`。**symlink は辿らない**）を基準に解決される。よって:
> 1. 編集対象の実体は **リポジトリ側** `ghostty/.config/ghostty/config.local` に置く
>    （`.gitignore` 済みでコミットされない）。
> 2. `~/.config/ghostty/config.local` からその実体へ **symlink** を張る
>    （bootstrap.sh が生成）。これが無いと `?` により黙ってスキップされ、config.local
>    の設定（opacity / blur / Mac固有 keybind 等）が一切効かないので注意。

公開して良いのは「全環境で同一」かつ「秘密でない」設定のみ。
リポジトリには各 `*.example` をサンプルとして同梱している。

## 編集動線（重要）

- `~/.config/<tool>/...` は**このリポジトリ内ファイルへの symlink**。
  symlink 経由で Edit すればリポジトリ実体が変わる（**apply ステップは不要**）。
- git コミットは必ずこのリポジトリ（`~/ghq/github.com/nesheep5/dotfiles`）で行う。
- 編集後は必ず `make check` を実行してからコミットする。

## 検証手順

1. `make check`（fish 構文 / stow dry-run / gitleaks / git status）
2. fish 変更時: 新しいシェルを開いて alias・プロンプトを確認
3. tmux 変更時: `tmux source-file ~/.config/tmux/tmux.conf`
4. git 変更時: `git config --show-origin <key>` で値の出所を確認

## Stow 運用

- **target（リンク先＝$HOME）は `.stowrc` で設定済み**。ghq 管理でリポジトリがホームから
  深い階層にあるため、`.stowrc` が無いと stow は親（`~/ghq/github.com/nesheep5/`）へ
  誤ってリンクする。`.stowrc` がこれを防ぐ。
- パッケージ追加: リポジトリルートで `stow <pkg>`（`-t ~` は `.stowrc` があるので不要）。
  日常運用は `make stow` / `make restow` / `make unstow` を使う。
- **`stow --adopt` は危険**: 既存実体をリポジトリ側に取り込み、リポジトリ内容を実体で
  上書きする。使う前に必ず `git status` がクリーン＆コミット済みであることを確認すること。
- 自動生成物（fish の functions/ completions/ conf.d/ fish_variables）はコミットしない
  （`.gitignore` 済）。fish パッケージ配下にはファイルのみ置く（サブディレクトリを置くと
  Stow が `~/.config/fish` ごと symlink 化する folding が起きるため）。
- ghostty の `config.local` は `ghostty/.stow-local-ignore` で stow 対象外にしている
  （リポジトリ側に実体を置くため。stow に任せず `~/.config/ghostty/config.local` への
  symlink は bootstrap.sh が `link_if_absent` で別途張る。上の「公開 NG」節を参照）。

## fish プラグイン

- プラグインの**真実の源は `fish_plugins`**（fisher 宣言）。
- 追加は `fisher install <repo>` 実行後、`fish_plugins` の差分のみコミットする。
  functions/ completions/ は生成物なのでコミットしない。

## tmux プラグイン（tpm 管理）

- プラグインの**真実の源は `tmux.conf` の `set -g @plugin '...'` 宣言**。
- tpm 本体・各プラグインは **`~/.config/tmux/plugins/`（実体）** に clone される。
  リポジトリ側に置くと Stow folding（`~/.config/tmux` ごと symlink 化）が起きるため、
  fish と同様に実体ディレクトリへ直接置き、`plugins/` は `.gitignore` 済み（コミットしない）。
- tmux.conf 末尾の tpm 初期化は `if-shell` で tpm の存在時のみ `run` する
  （未導入環境でも起動エラーにならないようにするため）。
- 追加は `tmux.conf` に `@plugin` 行を足し、prefix(`C-q`) + `I` でインストール
  （または bootstrap.sh が `tpm/bin/install_plugins` で非対話インストール）。`@plugin` 行のみコミットする。
- 現在の導入プラグイン: `tmux-cpu`（status-right の `#{cpu_percentage}` / `#{ram_percentage}` を提供）。

## 新環境セットアップ

`./bootstrap.sh` を参照（OS判定 → brew → brew bundle → stow → tpm clone+install →
nvim clone → fisher → chsh → *.local テンプレ生成 → pre-commit install）。

## コミット規約（親 ~/ghq/CLAUDE.md より）

- コミットメッセージは**日本語**で簡潔に（1行目で要約、1コミット1目的）
- 機密ファイルを絶対にコミットしない
- force push は `--force-with-lease` のみ（`--force` / `-f` は禁止）
