#!/usr/bin/bash

# set up arch linux systems

sudo rm -rf "/etc/sudoers.d/"*
sudo bash -c 'echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'

yaourt -S freetype2-infinality fontconfig-infinality sublime-text-dev
sudo pacman -S python2-pip python-pip python-virtualenvwrapper docker docker-compose jq zsh terminator vim rsync

chsh -s /usr/bin/zsh

$(dirname $0)/update_dotfiles.sh git2home

gpasswd -a $(id -un) docker
newgrp docker

sudo systemctl enable docker
sudo systemctl start docker

sudo systemctl enable sshd
sudo systemctl start sshd
