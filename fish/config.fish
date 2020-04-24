
# historyに重複コマンドを残さない
set -x HISTCONTROL ignoreboth
set -x EDITOR nvim
# grep PATH
set -x PATH  /usr/local/opt/grep/libexec/gnubin $PATH

# set -x BUNDLE_GEMFILE "Gemfile.local"


# alias ++++++++++++++++++++++++++++++++++++++++++++++++++
alias vim="nvim"
alias vc 'vim ~/.config/nvim/init.vim'
alias fc 'vim ~/.config/fish/config.fish'
alias fc_local 'vim ~/.config/fish/config_local.fish'
alias tc 'vim ~/.tmux.conf'
alias gl 'cd (ghq root) | cd (ghq list | fzf)'
alias rm 'rmtrash'

alias gc 'git checkout'
alias gfu 'git fetch upstream'

alias ide 'tmux split-window -v -p 30; tmux split-window -h -p 66; tmux split-window -h -p 50'

set -x GOPATH $HOME/git
set -x PATH $PATH $GOPATH/bin
set -x GOENV_DISABLE_GOPATH 1 # goenvのvar毎にGOPATH管理する機能を無効化

# for direnv
direnv hook fish | source

# init anyenv
status --is-interactive; and source (anyenv init -|psub)

# mysql
set -g fish_user_paths "/usr/local/opt/mysql@5.7/bin" $fish_user_paths

# local config
source ~/.config/fish/config_local.fish

set -g fish_user_paths "/usr/local/opt/avr-gcc@8/bin" $fish_user_paths
# set -x PATH $HOME/.local/share/vim-lsp-settings/servers $PATH
