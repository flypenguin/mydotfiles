# autojump
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# direnv - https://direnv.net/
which -s direnv > /dev/null 2>&1 && eval "$(direnv hook zsh)"
