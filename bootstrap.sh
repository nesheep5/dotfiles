#!/usr/bin/env bash
# =============================================================================
# bootstrap.sh — 新環境セットアップ（冪等・Mac/Ubuntu 両対応）
#
# 使い方:
#   ghq get github.com/nesheep5/dotfiles   # or git clone
#   cd ~/ghq/github.com/nesheep5/dotfiles
#   ./bootstrap.sh
#
# 何度実行しても安全（既存チェック付き）。
# =============================================================================
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_REPO="https://github.com/nesheep5/nvim"
OS="$(uname -s)"

log() { printf '\033[1;34m==>\033[0m %s\n' "$1"; }

# 不在時のみ *.example から *.local を生成
copy_if_absent() { [ -f "$2" ] || { mkdir -p "$(dirname "$2")"; cp "$1" "$2"; log "生成: $2"; }; }

# --- (a) Homebrew ---
if [ "$OS" = "Darwin" ]; then
  BREW_PREFIX="/opt/homebrew"
else
  BREW_PREFIX="/home/linuxbrew/.linuxbrew"
fi
if ! command -v brew >/dev/null 2>&1; then
  if [ ! -x "$BREW_PREFIX/bin/brew" ]; then
    log "Homebrew をインストール"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
fi
[ -x "$BREW_PREFIX/bin/brew" ] && eval "$("$BREW_PREFIX/bin/brew" shellenv)"

# --- (b) コアツール ---
log "brew bundle でコアツールを導入"
brew bundle --file="$DOTFILES_DIR/Brewfile"

# --- (c) stow（ghostty は Mac のみ） ---
log "stow で symlink を配置"
PKGS="fish tmux starship mise git"
[ "$OS" = "Darwin" ] && PKGS="$PKGS ghostty"
cd "$DOTFILES_DIR"
# shellcheck disable=SC2086
stow -t "$HOME" --restow $PKGS

# --- (d) *.local テンプレを不在時のみ生成（ghostty config-file 不在エラー回避も兼ねる） ---
log "*.local テンプレートを生成（不在時のみ）"
copy_if_absent "$DOTFILES_DIR/fish/.config/fish/config.local.fish.example" "$HOME/.config/fish/config.local.fish"
copy_if_absent "$DOTFILES_DIR/tmux/.config/tmux/tmux.local.conf.example"   "$HOME/.config/tmux/tmux.local.conf"
copy_if_absent "$DOTFILES_DIR/git/.gitconfig.local.example"                "$HOME/.gitconfig.local"
if [ "$OS" = "Darwin" ]; then
  copy_if_absent "$DOTFILES_DIR/ghostty/.config/ghostty/config.local.example" "$HOME/.config/ghostty/config.local"
fi

# --- (e) nvim 別リポジトリ ---
if [ ! -d "$HOME/.config/nvim" ]; then
  log "nvim 設定を clone"
  git clone "$NVIM_REPO" "$HOME/.config/nvim"
fi

# --- (f) fisher プラグイン復元（fish_plugins 宣言から同期） ---
if command -v fish >/dev/null 2>&1; then
  log "fisher プラグインを復元"
  fish -c 'type -q fisher; or begin; curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source; and fisher install jorgebucaran/fisher; end'
  fish -c 'fisher update'
fi

# --- (g) fish をログインシェル化 ---
FISH_BIN="$(command -v fish || true)"
if [ -n "$FISH_BIN" ]; then
  if ! grep -qx "$FISH_BIN" /etc/shells 2>/dev/null; then
    log "fish を /etc/shells に登録（sudo）"
    echo "$FISH_BIN" | sudo tee -a /etc/shells >/dev/null
  fi
  if [ "${SHELL:-}" != "$FISH_BIN" ]; then
    log "ログインシェルを fish に変更"
    chsh -s "$FISH_BIN"
  fi
fi

# --- (h) pre-commit をこのリポジトリに有効化 ---
if command -v pre-commit >/dev/null 2>&1; then
  log "pre-commit フックを有効化"
  (cd "$DOTFILES_DIR" && pre-commit install)
fi

log "完了。新しいシェルを開いて動作を確認してください。"
log "仕事/環境固有の設定は ~/.config/*/.../*.local（および ~/.gitconfig.local）を編集してください。"
