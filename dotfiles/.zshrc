## FOR INTERACTIVE SHELLS
# zsh ordering:
#   $ZDOTDIR/.zshenv                    # all shells
#   $ZDOTDIR/.zprofile                  # login shells
#   $ZDOTDIR/.zshrc                     # interactive shells
#   $ZDOTDIR/.zlogin                    # login-shells
#   $ZDOTDIR/.zlogout                   # login-shells (on exit)
# see here: http://bit.ly/1sGzo6g

UNAME=$(uname -s)

# otherwise we don't have a path. super creepy.
typeset -Ug path
export path=("$HOME/bin" "$HOME/.local/bin" "/usr/local/bin" "/usr/bin" "/bin" "$path[@]")

# fix VIRTUALENVWRAPPER on OS X
_PY_CHECK="/usr/local/bin/python2"
[[ -x "$_PY_CHECK" ]] && export VIRTUALENVWRAPPER_PYTHON="$_PY_CHECK"


# source zgen
source "${HOME}/.zgen/zgen.zsh"

# if the init scipt doesn't exist
if ! zgen saved; then

  zgen   oh-my-zsh

  # specify plugins here
  zgen   oh-my-zsh   "themes/jreese"
#  zgen   oh-my-zsh   "lib/directories"
#  zgen   oh-my-zsh   "lib/grep"
#  zgen   oh-my-zsh   "lib/termsupport"
#  zgen   oh-my-zsh   "lib/completion"
#  zgen   oh-my-zsh   "lib/key-bindings"
#  zgen   oh-my-zsh   "lib/history"
  zgen   oh-my-zsh   "plugins/kubectl"
  zgen   oh-my-zsh   "plugins/docker"
  zgen   oh-my-zsh   "plugins/virtualenv"
  zgen   oh-my-zsh   "plugins/virtualenvwrapper"
  zgen   oh-my-zsh   "plugins/git"
  zgen   oh-my-zsh   "plugins/rvm"
  zgen   oh-my-zsh   "plugins/common-aliases"

  if whence fzf >/dev/null; then
    zgen load junegunn/fzf shell/completion.zsh
    zgen load junegunn/fzf shell/key-bindings.zsh
  fi

  for system in "" ".$UNAME" ; do
    for plug in $HOME/.shell/*.sh${system} ; do
      # don't add dummy files :)
      if echo $plug | grep -q dummy ; then continue ; fi
      zgen load "$plug"
    done
  done

  # generate the init script from plugins above
  zgen save

fi
