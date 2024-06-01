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

echo -e "\n\n * Installing zsh manager(s) ..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# find out where "brew" is
for brew_dir in /opt/homebrew /usr/local /home/linuxbrew/.linuxbrew ; do
  brew_dir=$brew_dir/bin
  if test -x $brew_dir/brew ; then
    BREW=$brew_dir/brew
    echo "   * found homebrew: $BREW"
    break
  fi
done

# are we on a mac?
[ test -d /Users ] && brew_add="mas-cli" || brew_add=""

# add brew to path for now
export PATH="$brew_dir:$PATH"

# install stow cause we need it _right now_
echo "   * Installing 'stow' using homebrew ..."
$BREW install stow $brew_add

# now use stow to manage shit. :)
# first, save what might be overwritten.
echo -e "\n\n * Updating dotfiles ..."
"$HOME/.dotfiles/dotfiles/bin/dotfile-update" -f


echo -e "\n\nIMPORTANT NOTE\nPlease remember to switch your shell to zsh :)\n"
echo -e "\n... and have fun :)\n\n"
