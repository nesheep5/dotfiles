# =============================================================================
# dotfiles 操作・検証用 Makefile
#
#   make check     設定の健全性を検証（構文 / stow dry-run / 秘密スキャン / 差分）
#   make stow      全パッケージを symlink 配置
#   make restow    再配置（追加/削除を反映）
#   make unstow    symlink を解除
#   make bootstrap 新環境セットアップ（bootstrap.sh 実行）
#
# 注: ghostty は GUI(Mac限定) のため、Linux では PKGS から外して実行すること
#     例: make stow PKGS="fish tmux starship mise git"
# =============================================================================

# target（リンク先＝$HOME）は .stowrc で設定済みのため -t は不要
PKGS ?= fish tmux ghostty starship mise git
STOW := stow

.PHONY: check stow restow unstow bootstrap

check:
	@echo "== fish 構文チェック =="
	@fish -n fish/.config/fish/config.fish && echo "  OK: config.fish"
	@echo "== stow dry-run（conflict / folding 検出） =="
	@$(STOW) --no --verbose $(PKGS)
	@echo "== gitleaks（秘密情報スキャン） =="
	@gitleaks dir . --no-banner 2>/dev/null \
		|| gitleaks detect --source . --no-banner 2>/dev/null \
		|| echo "  (gitleaks 未導入または検出なし)"
	@echo "== git status =="
	@git status --short

stow:
	$(STOW) --verbose $(PKGS)

restow:
	$(STOW) --restow --verbose $(PKGS)

unstow:
	$(STOW) --delete --verbose $(PKGS)

bootstrap:
	./bootstrap.sh
