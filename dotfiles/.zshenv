## USED FOR ALL SHELLS (LOGIN, INTERACTIVE, AND 'OTHERS' ;)
# zsh ordering:
#   $ZDOTDIR/.zshenv                    # all shells
#   $ZDOTDIR/.zprofile                  # login shells
#   $ZDOTDIR/.zshrc                     # interactive shells
#   $ZDOTDIR/.zlogin                    # login-shells
#   $ZDOTDIR/.zlogout                   # login-shells (on exit)
# see here: http://bit.ly/1sGzo6g
#

# NOTE I:   .zshenv needs to live at ~/.zshenv, not in $ZDOTDIR!
# NOTE II:  All (!!) other zsh-files are now in ~/.config/zsh
#           and read from there -- see $ZDOTDIR below.

# Set ZDOTDIR if you want to re-home Zsh.
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export ZDOTDIR=${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}
export ZCACHEDIR="${ZCACHEDIR:-$XDG_CACHE_HOME/zsh}" # non-standard. for antidote.

# Ensure path arrays do not contain duplicates.
typeset -gU path fpath

# Set the list of directories that zsh searches for commands.
path=(
  $HOME/{,s}bin(N)
  $HOME/.local/{,s}bin(N)
  /opt/{homebrew,local}/{,s}bin(N)
  /usr/local/{,s}bin(N)
  $path
)

export HISTFILE="${ZCACHEDIR}/zsh_history"
export LANG=en_US.UTF-8
export ZSH_THEME="robbyrussell"
