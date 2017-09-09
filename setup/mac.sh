#!/usr/bin/env bash

# install homebrew if needed
if ! which brew ; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew tap caskroom/bundle
  brew bundle                 # so much nicer :)
  brew bundle                 # so much nicer :)
else
  echo "Skipping homebrew installation. Seems to be installed."
fi

# clone the repo if not yet done ;)
if [ ! -d "$HOME/.dotfiles" ] ; then
  cd "$HOME"
  # now we *definitively* have git ...
  git clone https://github.com/flypenguin/mydotfiles.git .dotfiles
fi

# continue with generic items
"$HOME/.dotfiles/setup/generic.sh"
