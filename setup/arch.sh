#!/usr/bin/bash

# set up arch linux systems

SUDO_STRING="%wheel ALL=(ALL) NOPASSWD: ALL"
SUDO_MATCHR='^%wheel ALL=\(ALL\) NOPASSWD: ALL$'
WANT_SHELL="/usr/bin/zsh"
YAOURT_PACKAGES=""
PACMAN_PACKAGES="stow python2-pip python-pip python-virtualenvwrapper docker docker-compose jq zsh terminator vim rsync"


# ============================================================================
echo -e "\n\n Installing sudo rules ... \n"

if ! sudo cat /etc/sudoers | egrep "${SUDO_MATCHR}" > /dev/null ; then
    echo " * Adding global sudo rule ..."
    sudo bash -c 'echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'
    sudo rm -rf "/etc/sudoers.d/"*
else
    echo " * Skipping sudo rule installation, already present."
fi


# ============================================================================
echo -e "\n\n * Installing packages ... \n"

for p in $YAOURT_PACKAGES ; do
    if ! pacman -Qs $p > /dev/null ; then
        echo "   * Yaourt: installing $p"
        yaourt -S --noconfirm $p
    else
        echo "   * Yaourt: package already installed: $p"
    fi
done

for p in $PACMAN_PACKAGES ; do
    if ! pacman -Qs $p > /dev/null ; then
        echo "   * Pacman: installing $p"
        sudo pacman -S --noconfirm $p
    else
        echo "   * Pacman: package already installed: $p"
    fi
done


# ============================================================================
echo -e "\n\n * Setting shell ... \n"

if [ ! "$(getent passwd $USER | cut -d: -f7)" = "$WANT_SHELL" ] ; then
    echo "   * Changing shell to $WANT_SHELL ..."
    chsh -s /usr/bin/zsh
else
    echo "   * Shell already set to $WANT_SHELL"
fi


# ============================================================================
echo "\n\n * Adding this user to the docker group ..."
sudo gpasswd -a $(id -un) docker


# ============================================================================
echo -e "\n\n * Enabling system services ... \n"

for service in docker sshd ; do 
  echo "   * enable & start service '$service'..."
  sudo systemctl enable $service
  sudo systemctl start $service
done


# ============================================================================
echo -e "\n\n * Installing linuxbrew ... \n"

if ! which brew > /dev/null 2>&1 ; then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
else
  echo "   * Linuxbrew seems to be installed already. Skipping."
fi


# ============================================================================
# clone the repo if not yet done ;)
echo -e "\n\n * Cloning dotfiles repo ..."
if [ ! -d "$HOME/.dotfiles" ] ; then
  cd "$HOME"
  # now we *definitively* have git ...
  git clone https://github.com/flypenguin/mydotfiles.git .dotfiles
else
  echo "   * Seems to be present already. Skipping."
fi


# ============================================================================
echo -e "\n\n * Generic Linux setup ..."
"$HOME/.dotfiles/setup/generic.sh"


# ============================================================================
echo ""
echo -e "\n\nDone.\nPlease re-login. \n"
