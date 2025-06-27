#!/usr/bin/env zsh

export THIS_SCRIPT="mac.sh"
export BREWFILE="$HOME/.dotfiles/Brewfile"
export BREWFILE_VARIANT="mac"
export THIS_HTTPS="https://github.com/flypenguin/mydotfiles.git"
export THIS_SSH="git@github.com:flypenguin/mydotfiles.git"
export BREW_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

if [[ "${0:-}" == "bash" ]]; then
    # we're in 'bash -c "$(curl ...)"' mode ...

    [[ -d "$HOME/.dotfiles" ]] || git clone "$THIS_HTTPS" "$HOME/.dotfiles"
    "$HOME/.dotfiles/setup/${THIS_SCRIPT}"

elif [[ "${1:-}" == "as-root" ]]; then

    echo "Nothing to be done as root on Mac."

elif [[ "${1:-}" == "as-user" ]]; then

    # perform root actions - if required ...
    sudo bash -c "\"${0}\" as-root"

    # on mac, do not use root for installing homebrew.
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # NOW we have the brewfile :) . use it.
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
