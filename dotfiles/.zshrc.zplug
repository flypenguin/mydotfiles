## FOR INTERACTIVE SHELLS
# zsh ordering:
#   $ZDOTDIR/.zshenv                    # all shells
#   $ZDOTDIR/.zprofile                  # login shells
#   $ZDOTDIR/.zshrc                     # interactive shells
#   $ZDOTDIR/.zlogin                    # login-shells
#   $ZDOTDIR/.zlogout                   # login-shells (on exit)
# see here: http://bit.ly/1sGzo6g


# ############################################################################
# Set up timing if used
# ############################################################################

UNAME=$(uname -s)                                   # to find out OS later
source "$HOME/.zplug/init.zsh"

zplug "zplug/zplug",                  hook-build:"zplug --self-manage"

zplug "themes/robbyrussell",          from:oh-my-zsh, as:theme

zplug "lib/directories",              from:oh-my-zsh
zplug "lib/grep",                     from:oh-my-zsh
zplug "lib/termsupport",              from:oh-my-zsh
zplug "lib/completion",               from:oh-my-zsh
zplug "lib/key-bindings",             from:oh-my-zsh
zplug "lib/history",                  from:oh-my-zsh
zplug "plugins/virtualenvwrapper",    from:oh-my-zsh
zplug "plugins/virtualenv",           from:oh-my-zsh
zplug "plugins/git",                  from:oh-my-zsh
zplug "plugins/rvm",                  from:oh-my-zsh
zplug "plugins/common-aliases",       from:oh-my-zsh


# host-local things can be placed under this directory.
# and we need those two glob entries ...
zplug "~/.shell",                     from:local, use:"*.sh"
zplug "~/.shell",                     from:local, use:"*.zsh"
zplug "~/.shell",                     from:local, use:"*.sh.$UNAME"
zplug "~/.shell",                     from:local, use:"*.zsh.$UNAME"

# ############################################################################
# Finally - zplug.
# ############################################################################

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load
