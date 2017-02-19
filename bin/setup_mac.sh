#!/usr/bin/env bash

# install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap caskroom/cask

# install a LOT of brew goodies
brew install \
    bfg coreutils curl dos2unix emacs findutils fish \
    git gnu-sed gnu-tar gnu-time gnu-which gnupg gnutls \
    htop-osx imagemagick jpeg jq leiningen midnight-commander neovim \
    nmap node openssl pv pyenv python python3 \
    readline sqlite tig tmux unrar \
    vim watch wget xz

brew cask install \
    iterm2 java jdownloader wireshark virtualbox


# continue with generic items
exec "$(dirname $0)/setup_generic.sh"
