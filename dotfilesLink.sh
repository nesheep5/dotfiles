#! /bin/bash
ln -fs ~/dotfiles/.Brewfile ~/.Brewfile
ln -fs ~/dotfiles/.gitconfig ~/.gitconfig
ln -fs ~/dotfiles/.gitignore_global ~/.gitignore_global

mkdir -p  ~/.config/nvim
ln -fs ~/dotfiles/nvim/init.vim ~/.config/nvim/init.vim
ln -fs ~/dotfiles/nvim/indent ~/.config/nvim/indent

mkdir -p  ~/.config/fish
ln -fs ~/dotfiles/fish/config.fish ~/.config/fish/config.fish
ln -fs ~/dotfiles/fish/fishfile ~/.config/fish/fishfile

ln -fs ~/dotfiles/.tmux.conf ~/.tmux.conf
