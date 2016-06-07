if [ -d ${HOME}/.rbenv  ] ; then
  export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
fi

export GOPATH=$HOME/.go
export JAVA_HOME=/Library/Java/Home
