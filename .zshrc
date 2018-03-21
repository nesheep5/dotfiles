# --------------------------------------------------
# base setting.
# --------------------------------------------------
# 文字コード
export LANG=ja_JP.UTF-8
# '#' 以降をコメントとして扱う
setopt interactive_comments

# cdコマンド省略
setopt auto_cd
# cd したら自動的にpushdする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# コマンド履歴
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000


# Emacs 風キーバインドにする
bindkey -e

# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# フローコントロールを無効にする
setopt no_flow_control

# vim:set ft=zsh :

# ## Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# --------------------------------------------------
# plugin
# --------------------------------------------------
# zsh-completions(補完機能強化)
  if [ -e /usr/local/share/zsh-completions ]; then
        fpath=(/usr/local/share/zsh-completions $fpath)
  fi
  # 大文字と小文字を区別しない
  zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
  # 補完機能を有効にする ※zsh-completionsより後に記述すること
  autoload -Uz compinit
  compinit

# cdr(ディレクトリ移動履歴)
  autoload -Uz add-zsh-hook
  autoload -Uz chpwd_recent_dirs cdr
  add-zsh-hook chpwd chpwd_recent_dirs

# vcs_info(gitリポジトリ表示)
  autoload -Uz add-zsh-hook
  autoload -Uz vcs_info
  zstyle ':vcs_info:git:*' check-for-changes true
  zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
  zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
  zstyle ':vcs_info:*' formats '%F{green}%c%u[%b]%f'
  zstyle ':vcs_info:*' actionformats '[%b|%a]'
  function _update_vcs_info_msg() {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    RPROMPT="${vcs_info_msg_0_}"
  }
  add-zsh-hook precmd _update_vcs_info_msg

# --------------------------------------------------
# alias
# --------------------------------------------------
alias -g L='| less'
alias -g G='| grep'

# ls系
alias -g ll='ls -l'
alias -g la='ls -la'

#=================
# プラグイン
#=================

#=================
# 色設定
#=================
autoload colors
colors

# プロンプト
PROMPT="%{${fg[green]}%}%n@%m %{${fg[yellow]}%}%~ %{${fg[red]}%}%# %{${reset_color}%}"
PROMPT2="%{${fg[yellow]}%} %_ > %{${reset_color}%}"
SPROMPT="%{${fg[red]}%}correct: %R -> %r ? [n,y,a,e] %{${reset_color}%}"

# ls
export LSCOLORS=gxfxcxdxbxegedabagacag
export LS_COLORS='di=36;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;46'

# 補完候補もLS_COLORSに合わせて色が付くようにする
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# lsがカラー表示になるようエイリアスを設定
case "${OSTYPE}" in
darwin*)
  # Mac
  alias ls="ls -GF"
  ;;
linux*)
  # Linux
  alias ls='ls -F --color'
  ;;
esac

# git config
function gitconfig_parsonal(){
  git config --local --replace-all user.name shogo.mizuno
  git config --local --replace-all user.email ne.sheep.5mouths@gmail.com
  git config -l
}
function gitconfig_work(){
  git config --local --replace-all user.name shogo.mizuno 
  git config --local --replace-all user.email shogo.mizuno@dena.com 
  git config -l
}

# local file 
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
