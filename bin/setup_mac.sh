#!/usr/bin/env bash

# install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap caskroom/bundle
brew bundle                 # so much nicer :)


# continue with generic items
exec "$(dirname $0)/setup_generic.sh"
