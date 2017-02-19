#!/usr/bin/env bash

# install rvm - ruby version manager
echo "Setting up rvm ..."
gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable

# install zplug - zsh plugin manager
echo "Installing zplug ..."
git clone https://github.com/zplug/zplug $HOME/.zplug

echo "Installing oh-my-zsh (just to be sure ;) ..."
git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
