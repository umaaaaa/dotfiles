#!/bin/sh

if [ ! -d .anyenv ]; then
  git clone https://github.com/riywo/anyenv ~/.anyenv
  anyenv install rbenv
  anyenv install plenv
  anyenv install pyenv
  anyenv install ndenv
fi
if [ ! -d envs ]; then
  mkdir ~/.anyenv/envs
fi


ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.zshrc.alias ~/.zshrc.alias
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.tmux-powerline ~/.tmux-powerline
