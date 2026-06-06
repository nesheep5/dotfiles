# =============================================================================
# Brewfile — 全環境に必ず入れる「コアツール」のみを手キュレーションで管理
#
# 方針:
#   - ここには「どの環境(個人Mac/仕事Mac/EC2)でも絶対に必要」なものだけ置く
#   - 個人固有・仕事固有・用途特化(ffmpeg/pandoc/aws系等)は各環境で手動 brew install
#   - cask/font は環境依存(GUI/Mac限定)のため Brewfile には含めない
#
# 適用: brew bundle --file Brewfile
# =============================================================================

# --- dotfiles 管理基盤 ---
brew "stow"          # 本リポジトリの symlink 管理

# --- シェル土台 ---
brew "fish"
brew "starship"      # プロンプト
brew "zoxide"        # cd 強化

# --- ランタイムバージョン管理 ---
brew "mise"

# --- エディタ / 端末多重化 ---
brew "neovim"
brew "tmux"

# --- git 周り ---
brew "git"
brew "gh"            # GitHub CLI
brew "ghq"           # リポジトリ管理
brew "git-delta"     # diff pager
brew "lazygit"       # TUI git クライアント
brew "gitleaks"      # 秘密情報スキャン（公開事故防止）
brew "pre-commit"    # commit 前フック管理

# --- モダン CLI（config.fish が依存: ls=eza 置換 等） ---
brew "eza"           # ls 代替
brew "bat"           # cat 代替
brew "fd"            # find 代替
brew "ripgrep"       # grep 代替
brew "fzf"           # ファジーファインダー
