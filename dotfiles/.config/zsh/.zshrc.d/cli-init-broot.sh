if (( $+commands[broot] )); then
    BROOT_CONFIG_FILE="$HOME/.config/broot/init.sh"
    if [ ! -f "$BROOT_CONFIG_FILE" ]; then
        BROOT_CONFIG_DIR="${BROOT_CONFIG_FILE%/*}"
        mkdir -p "$BROOT_CONFIG_DIR"
        broot --print-shell-function zsh > "$BROOT_CONFIG_FILE"
        broot --set-install-state installed > /dev/null 2>&1
        echo "'broot' set up initially."
    fi
    source "$BROOT_CONFIG_FILE"
    unset BROOT_CONFIG_FILE
fi
