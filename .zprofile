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

# going zsh-native. duplicate in .profile if needed ...

# host-specific profiles are not checked in. they exist on one host only :)
a="$HOME/.host_specific_profile"
[ -f "$a" ] && source $a
