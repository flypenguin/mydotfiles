#!/usr/bin/env bash

# install homebrew if needed
if ! which brew ; then
  echo "Installing homebrew ..."
  echo "We need sudo. Activating."
  sudo ls
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Skipping homebrew installation. Seems to be installed."
fi

# clone the repo if not yet done ;)
if [ ! -d "$HOME/.dotfiles" ] ; then
  cd "$HOME"
  # now we *definitively* have git ...
  git clone https://github.com/flypenguin/mydotfiles.git .dotfiles
else
  (cd "$HOME/.dotfiles" ; git pull)
fi

# NOW we have the brewfile :) . use it.
brew bundle --file=$HOME/.dotfiles/dotfiles/Brewfile

# continue with generic items
"$HOME/.dotfiles/setup/generic.sh"
