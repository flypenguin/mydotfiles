#!/usr/bin/bash

# set up arch linux systems

SUDO_STRING="%wheel ALL=(ALL) NOPASSWD: ALL"
SUDO_MATCHR='^%wheel ALL=\(ALL\) NOPASSWD: ALL$'
WANT_SHELL="/usr/bin/zsh"
YAOURT_PACKAGES=""
PACMAN_PACKAGES="stow python2-pip python-pip python-virtualenvwrapper docker docker-compose jq zsh vim rsync base-devel openssh ruby"
LOGFILE="/tmp/setup-arch.$(date +%Y%m%d_%H%M%S).log"


die() {
    echo "$@"
    exit -1
}

runme() {
    echo -e "COMMAND: $@\n\n" >> $LOGFILE
    "$@" >> $LOGFILE 2>&1
    echo -e "\n\n" >> $LOGFILE
}


# ============================================================================
echo -e "\n\n Some preliminary checks ...\n"

set -euo pipefail

echo -n " * LOGFILE IS: $LOGFILE"
echo -n " * checking if $WANT_SHELL exists ... "
test -x "$WANT_SHELL" && echo "ok" || die "XX"

# ============================================================================
echo -e "\n\n Installing pacman packages ...\n"

for p in $PACMAN_PACKAGES ; do
    if ! pacman -Q $p | cut -d" " -f 1 | grep -qE "^$p$" ; then
        echo "   * Pacman: installing $p"
        runme sudo pacman -S --noconfirm $p
    else
        echo "   * Pacman: package already installed: $p"
    fi
done

# ============================================================================
echo -e "\n\n Installing yaourt ...\n"

if ! which yaourt >/dev/null 2>&1 ; then
    TMP=$(mktemp -d)
    cd "$TMP"
    for pkg in package-query yaourt ; do
        runme curl -sLO "https://aur.archlinux.org/cgit/aur.git/snapshot/${pkg}.tar.gz"
        runme tar xzf "${pkg}.tar.gz"
        runme cd "${pkg}"
        runme makepkg --noconfirm -si
        runme cd ..
    done
else
    echo " * Skipping yaourt installation, seems to be already present."
fi

# ============================================================================
echo -e "\n\n Installing sudo rules ... \n"

if ! sudo cat /etc/sudoers | egrep "${SUDO_MATCHR}" > /dev/null ; then
    echo " * Adding global sudo rule ..."
    runme sudo bash -c 'echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'
    runme sudo rm -rf "/etc/sudoers.d/"*
else
    echo " * Skipping sudo rule installation, already present."
fi


# ============================================================================
echo -e "\n\n * Installing yaourt packages ... \n"

for p in $YAOURT_PACKAGES ; do
    if ! pacman -Qs $p > /dev/null ; then
        echo "   * Yaourt: installing $p"
        runme yaourt -S --noconfirm $p
    else
        echo "   * Yaourt: package already installed: $p"
    fi
done


# ============================================================================
echo -e "\n\n * Setting shell ... \n"

if [ ! "$(getent passwd $USER | cut -d: -f7)" = "$WANT_SHELL" ] ; then
    echo "   * Changing shell to $WANT_SHELL ..."
    chsh -s "$WANT_SHELL"
else
    echo "   * Shell already set to $WANT_SHELL"
fi


# ============================================================================
echo "\n\n * Adding this user to the docker group ..."
runme sudo gpasswd -a $(id -un) docker


# ============================================================================
echo -e "\n\n * Enabling system services ... \n"

for service in docker sshd ; do 
  echo "   * enable & start service '$service'..."
  runme sudo systemctl enable $service
  runme sudo systemctl start $service
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
  runme git clone https://github.com/flypenguin/mydotfiles.git .dotfiles
else
  echo "   * Seems to be present already. Skipping."
fi


# ============================================================================
echo -e "\n\n * Generic Linux setup ..."
"$HOME/.dotfiles/setup/generic.sh"


# ============================================================================
echo ""
echo -e "\n\nDone.\nPlease re-login. \n"
