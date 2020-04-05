## FOR INTERACTIVE SHELLS
# zsh ordering:
#   $ZDOTDIR/.zshenv                    # all shells
#   $ZDOTDIR/.zprofile                  # login shells
#   $ZDOTDIR/.zshrc                     # interactive shells
#   $ZDOTDIR/.zlogin                    # login-shells
#   $ZDOTDIR/.zlogout                   # login-shells (on exit)
# see here: http://bit.ly/1sGzo6g

# add $HOME/bin to the path.
path=("$HOME/bin" $path)

UNAME=$(uname -s)

if [ "$UNAME" = "Darwin" ] ; then
  # fix VIRTUALENVWRAPPER on OS X
  export WORKON_HOME=$HOME/.virtualenvs
  export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
  export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenv
  export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
fi

# source zgen
source "${HOME}/.zgen/zgen.zsh"

# if the init scipt doesn't exist
if ! zgen saved; then

  zgen   oh-my-zsh

  # specify plugins here
  #zgen   oh-my-zsh   "lib/directories"
  #zgen   oh-my-zsh   "lib/grep"
  #zgen   oh-my-zsh   "lib/termsupport"
  #zgen   oh-my-zsh   "lib/completion"
  #zgen   oh-my-zsh   "lib/key-bindings"
  #zgen   oh-my-zsh   "lib/history"
  #zgen   load        "denysdovhan/spaceship-prompt" spaceship
  zgen   oh-my-zsh   "themes/jreese"
  zgen   oh-my-zsh   "plugins/kubectl"
  zgen   oh-my-zsh   "plugins/helm"
  zgen   oh-my-zsh   "plugins/docker"
  zgen   oh-my-zsh   "plugins/virtualenv"
  zgen   oh-my-zsh   "plugins/virtualenvwrapper"
  zgen   oh-my-zsh   "plugins/git"
  zgen   oh-my-zsh   "plugins/common-aliases"
  zgen   oh-my-zsh   "plugins/dotenv"
  #zgen   oh-my-zsh   "plugins/fasd"

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

