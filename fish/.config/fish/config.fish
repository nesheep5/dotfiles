if status is-interactive
  eval (/opt/homebrew/bin/brew shellenv)
  mise activate fish | source
  starship init fish | source
  zoxide init fish | source

  alias fc 'nvim ~/.config/fish/config.fish'
  alias vc 'nvim ~/.config/nvim/init.lua'
  alias ls 'eza --icons'
end

export PATH="$HOME/.local/bin:$PATH"

# 環境固有設定を読み込む（存在すれば）
# 仕事固有 alias / proxy / 社内ツール PATH 等は config.local.fish に置く
test -f ~/.config/fish/config.local.fish && source ~/.config/fish/config.local.fish
