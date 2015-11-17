#!/usr/bin/bash

# set up arch linux systems


yaourt -S freetype2-infinality fontconfig-infinality
sudo pacman -S python2-pip python-pip python-virtualenvwrapper docker docker-compose jq zsh terminator

chsh -s /usr/bin/zsh
