# jump (autojump seems dead) - don't forget QUOTING!! :)
whence jump >/dev/null 2>&1 && eval "$(jump shell zsh)"

# direnv - https://direnv.net/
whence direnv > /dev/null 2>&1 && eval "$(direnv hook zsh)"

# nvm - the Node Version Manager
# use the oh-my-zsh "nvm" plugin for "stupid" initialization, or use lazy loading here.

# zsh syntax highlighting
# from arch :)
local SCRIPT="/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[ -f "$SCRIPT" ] && source "$SCRIPT"

