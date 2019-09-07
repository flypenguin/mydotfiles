# autojump
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# direnv - https://direnv.net/
which -s direnv > /dev/null 2>&1 && eval "$(direnv hook zsh)"

# nvm - the Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm


# PKD
pkd-site-of() { okta-cli users list -s "profile.pkUsername eq \"$1\"" --output-fields profile.site }
