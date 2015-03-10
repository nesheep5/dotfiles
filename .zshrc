# 補完機能を有効にする
autoload -Uz compinit
compinit

setopt auto_cd
# cd したら自動的にpushdする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups
 
 
# グローバルエイリアス
alias -g L='| less'
alias -g G='| grep'
alias -g ll='ls -l'
alias -g la='ls -la'

# コマンド履歴
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
 
# 大文字と小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
 
# Emacs 風キーバインドにする
bindkey -e

# 文字コード
export LANG=ja_JP.UTF-8

# 日本語ファイル名を表示可能にする
setopt print_eight_bit
 
# フローコントロールを無効にする
setopt no_flow_control
 
# '#' 以降をコメントとして扱う
setopt interactive_comments
 
# vim:set ft=zsh :

# ## Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# zsh-completions 
if [ -e /usr/local/share/zsh-completions ]; then
	    fpath=(/usr/local/share/zsh-completions $fpath)
fi


