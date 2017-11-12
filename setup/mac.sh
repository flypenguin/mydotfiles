#!/usr/bin/env bash

# install homebrew if needed
if ! which brew ; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew tap caskroom/cask
  # we don't have the Brewfile cloned - yet. so ... wait.
else
  echo "Skipping homebrew installation. Seems to be installed."
fi

# clone the repo if not yet done ;)
if [ ! -d "$HOME/.dotfiles" ] ; then
  cd "$HOME"
  # now we *definitively* have git ...
  git clone https://github.com/flypenguin/mydotfiles.git .dotfiles
fi

# NOW we have the brewfile :) . use it.
brew bundle --file=$HOME/.dotfiles/dotfiles/Brewfile

# continue with generic items
"$HOME/.dotfiles/setup/generic.sh"
