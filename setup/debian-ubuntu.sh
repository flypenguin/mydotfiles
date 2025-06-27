#!/usr/bin/env bash
# this is for Debian AND Ubuntu, not for "Debian-Ubuntu" ...

export THIS_SCRIPT="debian-ubuntu.sh"
export BREWFILE="$HOME/.dotfiles/Brewfile"
export BREWFILE_VARIANT="linux"
export THIS_HTTPS="https://github.com/flypenguin/mydotfiles.git"
export THIS_SSH="git@github.com:flypenguin/mydotfiles.git"
export BREW_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

# lines: shell / system / network / dev
# array variable.
export PACKAGES=(
    less direnv vim zsh file pwgen rsync stow bat fzf zip unzip tmux zoxide
    apt-file apt-file apt-listchanges aptitude deborphan debian-goodies
    strace dnsutils iputils-ping nmap tcpdump rclone ncat telnet
    git make build-essential jq just
)


# #################################################################################################
# start here

set -euo pipefail

if [[ "${0}" == "bash" ]]; then
    # we're in 'bash -c "$(curl ...)"' mode ...

    # remember -- git might not be installed yet.
    command -v git > /dev/null || sudo apt-get install -y git

    [[ -d "$HOME/.dotfiles" ]] || git clone "$THIS_HTTPS" "$HOME/.dotfiles"
    "$HOME/.dotfiles/setup/${THIS_SCRIPT}"

elif [[ "${1:-}" == "as-root" ]]; then

    # called from the "else" branch below :)

    TARGET_USER="$2"

    apt-get update && apt-get -y upgrade
    apt-get install -y "${PACKAGES[@]}"
    chsh -s /bin/zsh "$TARGET_USER"

    SUDOERS_FILE="/etc/sudoers.d/999-${TARGET_USER}"
    echo "$(printf '%-20s' "$TARGET_USER")    ALL=(ALL:ALL) NOPASSWD:ALL" > "$SUDOERS_FILE"
    chmod 600 "$SUDOERS_FILE"

elif [[ "${1:-}" == "as-user" ]]; then

    # this is not run as root ...
    [[ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]] || \
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    brew bundle --file="${BREWFILE}.${BREWFILE_VARIANT}"

    cd "$HOME/.dotfiles"
    git remote set-url origin "$THIS_SSH"

    # continue with generic items
    "$HOME/.dotfiles/setup/generic.sh"

elif (cd "$HOME/.dotfiles" ; git remote get-url origin) | grep -q https ; then

    # our "marker" is that git is still on the https:// url.
    # if this is the case, let's update and run the shit :)
    git -C "$HOME/.dotfiles" pull

    sudo bash -c "\"${0}\" as-root "$USER""
    "${0}" as-user

    echo "GOOD NEWS: we should be done."

else

    echo "The initialization was apparently completed before."

fi
