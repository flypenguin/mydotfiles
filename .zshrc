## FOR INTERACTIVE SHELLS
# zsh ordering:
#   $ZDOTDIR/.zshenv                    # all shells
#   $ZDOTDIR/.zprofile                  # login shells
#   $ZDOTDIR/.zshrc                     # interactive shells
#   $ZDOTDIR/.zlogin                    # login-shells
#   $ZDOTDIR/.zlogout                   # login-shells (on exit)
# see here: http://bit.ly/1sGzo6g

UNAME=$(uname -s)                                   # to find out OS later
export path=("/usr/local/bin" "/usr/bin" "/bin" "$path[@]")
source "${HOME}/.zgen/zgen.zsh"

# if the init scipt doesn't exist
if ! zgen saved; then

  zgen   oh-my-zsh

  # specify plugins here
  zgen   oh-my-zsh   "themes/robbyrussell"
#  zgen   oh-my-zsh   "lib/directories"
#  zgen   oh-my-zsh   "lib/grep"
#  zgen   oh-my-zsh   "lib/termsupport"
#  zgen   oh-my-zsh   "lib/completion"
#  zgen   oh-my-zsh   "lib/key-bindings"
#  zgen   oh-my-zsh   "lib/history"
  zgen   oh-my-zsh   "plugins/virtualenvwrapper"
  zgen   oh-my-zsh   "plugins/virtualenv"
  zgen   oh-my-zsh   "plugins/git"
  zgen   oh-my-zsh   "plugins/rvm"
  zgen   oh-my-zsh   "plugins/common-aliases"

  for plug in $HOME/.shell/* ; do
    zgen load "$plug"
  done

  # generate the init script from plugins above
  zgen save

fi
