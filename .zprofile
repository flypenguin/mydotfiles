## ZSH PROFILE
# should be used for login shells only.
# zsh ordering:
#   $ZDOTDIR/.zshenv                    # all shells
#   $ZDOTDIR/.zprofile                  # login shells
#   $ZDOTDIR/.zshrc                     # interactive shells
#   $ZDOTDIR/.zlogin                    # login-shells
#   $ZDOTDIR/.zlogout                   # login-shells (on exit)
# see here: http://bit.ly/1sGzo6g
# with oh-my-zsh this file seems to be read twice (oh-my-zsh.sh seems to
# read this AGAIN somehow).

source "$HOME/.all_shells_profile"
