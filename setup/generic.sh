#!/usr/bin/env bash

# this file is mainly for the one-time things which already
# provide methods to update on their own.


# $1 repo URL to be cloned
# $2 target directory, must be set
clone_repo_to() {
  if ! [ -d "$2" ] ; then
    echo "   * Cloning $1 -> $2 ..."
    mkdir -p "$(dirname $2)"
    git clone "$1" "$2"
  else
    echo "   * $2 already present, skipping '$1'"
  fi
}


## START

# install rvm - ruby version manager
#if [ ! -d "$HOME/.rvm" ] ; then
#  echo -e "\n\n * Installing up rvm ..."
#  gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
#  \curl -sSL https://get.rvm.io | bash -s stable
#else
#  echo "   * rvm seems to be installed. please update using rvm itself."
#fi


echo -e "\n\n * Installing zsh manager(s) ..."
# from ohmyz.sh website
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#clone_repo_to https://github.com/tarjoilija/zgen.git          "${HOME}/.zgen"
#clone_repo_to https://github.com/zplug/zplug                  "$HOME/.zplug"
# clone_repo_to https://github.com/robbyrussell/oh-my-zsh.git   "$HOME/.oh-my-zsh"

# now use stow to manage shit. :)
# first, save what might be overwritten.
echo -e "\n\n * Updating dotfiles ..."
"$HOME/.dotfiles/dotfiles/bin/dotfile-update" -f


echo -e "\n\nIMPORTANT NOTE\nPlease remember to switch your shell to zsh :)\n"
echo -e "\n... and have fun :)\n\n"
