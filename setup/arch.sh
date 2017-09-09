#!/usr/bin/bash

# set up arch linux systems

SUDO_STRING="%wheel ALL=(ALL) NOPASSWD: ALL"
SUDO_MATCHR='^%wheel ALL=\(ALL\) NOPASSWD: ALL$'
WANT_SHELL="/usr/bin/zsh"
YAOURT_PACKAGES="freetype2-infinality fontconfig-infinality sublime-text-dev"
PACMAN_PACKAGES="python2-pip python-pip python-virtualenvwrapper docker docker-compose jq zsh terminator vim rsync"


# ============================================================================
echo -e "\n\n Installing sudo rules ... \n"

if ! sudo cat /etc/sudoers | egrep "${SUDO_MATCHR}" > /dev/null ; then
    echo "Adding global sudo rule ..."
    sudo bash -c 'echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'
    sudo rm -rf "/etc/sudoers.d/"*
else
    echo "Skipping sudo rule installation, already present."
fi


# ============================================================================
echo -e "\n\n Installing packages ... \n"

for p in $YAOURT_PACKAGES ; do
    if ! pacman -Qs $p > /dev/null ; then
        yaourt -S $p
    else
        echo "Yaourt: $p already installed."
    fi
done

for p in $PACMAN_PACKAGES ; do
    if ! pacman -Qs $p > /dev/null ; then
        pacman -S $p
    else
        echo "Pacman: $p already installed."
    fi
done


# ============================================================================
echo -e "\n\n Setting shell ... \n"

if [ ! "$(getent passwd $USER | cut -d: -f7)" = "$WANT_SHELL" ] ; then
    echo "Changing shell to $WANT_SHELL ..."
    chsh -s /usr/bin/zsh
else
    echo "Shell already set to $WANT_SHELL"
fi


# ============================================================================
echo -e "\n\n Setting udpating dotfiles ... \n"

echo "Update dotfiles ..."
$(dirname $0)/update_dotfiles.sh git2home


# ============================================================================
echo -e "\n\n Modifying user's groups ... \n"

echo "Adding docker group ..."
sudo gpasswd -a $(id -un) docker


# ============================================================================
echo -e "\n\n Enabling system services ... \n"

echo "Enabling Docker service ..."
sudo systemctl enable docker
sudo systemctl start docker

echo "Enabling SSH service ..."
sudo systemctl enable sshd
sudo systemctl start sshd

echo "Setting up rest ..."
"$(dirname $0)/generic.sh"


# ============================================================================
echo -e "\n\n Installing linuxbrew ... \n"

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"


# ============================================================================
echo ""
echo -e "\n\n Done.\n Please re-login. \n"
