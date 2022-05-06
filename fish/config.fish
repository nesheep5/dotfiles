
# historyに重複コマンドを残さない
set -x HISTCONTROL ignoreboth
set -x EDITOR nvim
# grep PATH
set -x PATH  /usr/local/opt/grep/libexec/gnubin $PATH

# set -x BUNDLE_GEMFILE "Gemfile.local"


# alias ++++++++++++++++++++++++++++++++++++++++++++++++++
alias vim "nvim"
alias vc 'vim ~/.config/nvim/init.vim'
alias fc 'vim ~/.config/fish/config.fish'
alias fc_local 'vim ~/.config/fish/config_local.fish'
alias tc 'vim ~/.tmux.conf'
alias gl 'cd (ghq root) | cd (ghq list | fzf)'
#alias rm 'rmtrash'

alias gc 'git checkout'
alias gfu 'git fetch upstream'

alias ide 'tmux split-window -v -p 30; tmux split-window -h -p 66; tmux split-window -h -p 50'

# set -x GOPATH $HOME/git
# set -x PATH $PATH $GOPATH/bin
set -x PATH $PATH ~/go/bin
set -x GOENV_DISABLE_GOPATH 1 # goenvのvar毎にGOPATH管理する機能を無効化

# for direnv
direnv hook fish | source

# init anyenv
#status --is-interactive; and source (anyenv init -|psub)
source /usr/local/opt/asdf/asdf.fish

# init iterm2 shell integration
source ~/.iterm2_shell_integration.(basename $SHELL)

# mysql
set -g fish_user_paths "/usr/local/opt/mysql@5.7/bin" $fish_user_paths
# local config
source ~/.config/fish/config_local.fish

set -g fish_user_paths "/usr/local/opt/avr-gcc@8/bin" $fish_user_paths
# set -x PATH $HOME/.local/share/vim-lsp-settings/servers $PATH
set -g fish_user_paths "/usr/local/opt/opencv@2/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/postgresql@11/bin" $fish_user_paths

# bundle install で/usr/bin/gcc を利用するためにPATHの前方に追加
# set -x PATH /usr/bin $PATH

set -g fish_user_paths "/home/linuxbrew/.linuxbrew/bin" $fish_user_paths

# source /usr/local/opt/asdf/asdf.fish
source /home/linuxbrew/.linuxbrew/opt/asdf/asdf.fish

# To enable agent forwarding when screen is reconnected.
# See http://mokokko.hatenablog.com/entry/2013/03/14/133850
set AUTH_SOCK "$HOME/.ssh/.ssh-auth-sock"
if [ -S "$AUTH_SOCK" ]
    set -x SSH_AUTH_SOCK $AUTH_SOCK
else if [ ! -S "$SSH_AUTH_SOCK" ]
    set -x SSH_AUTH_SOCK $AUTH_SOCK
else if [ ! -L "$SSH_AUTH_SOCK" ]
    ln -snf "$SSH_AUTH_SOCK" $AUTH_SOCK && set -x SSH_AUTH_SOCK $AUTH_SOCK
end
