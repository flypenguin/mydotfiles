## FOR INTERACTIVE SHELLS
# zsh ordering:
#   $ZDOTDIR/.zshenv                    # all shells
#   $ZDOTDIR/.zprofile                  # login shells
#   $ZDOTDIR/.zshrc                     # interactive shells
#   $ZDOTDIR/.zlogin                    # login-shells
#   $ZDOTDIR/.zlogout                   # login-shells (on exit)
# see here: http://bit.ly/1sGzo6g

# we need this :/
UNAME=$(uname -s)

# "dynamic" plugins
ADD_PLUGINS=()

# loads of shit does not work if this is not properly set EARLY.
# later = higher preference, so /usr/local is "first" in the
# list
for PATH_SEARCH in \
  "/usr/local/bin" \
  "/opt/homebrew/bin" \
; do
  [ -d "$PATH_SEARCH" ] && path=($PATH_SEARCH $path)
done

# this is annoying, but for now it works.
path=("$HOME/bin" $path)
if [ "$UNAME" = "Darwin" ] ; then
  # fix VIRTUALENVWRAPPER on OS X
  export WORKON_HOME=$HOME/.virtualenvs
  export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
  export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenv
fi

# add pyenv _before_ the plugins load ... ugly fucking hack.
if command -v pyenv > /dev/null 2>&1 ; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  ADD_PLUGINS+="pyenv"
fi

export ZSH="$HOME/.oh-my-zsh"
export UPDATE_ZSH_DAYS=13

ZSH_THEME="robbyrussell"

DISABLE_UPDATE_PROMPT="true"
HIST_STAMPS="yyyy-mm-dd"

plugins=(direnv git docker virtualenv virtualenvwrapper pyenv common-aliases kubectl fzf)
plugins+=(${ADD_PLUGINS[@]})

# CASE_SENSITIVE="true"
# DISABLE_AUTO_UPDATE="true"
# DISABLE_MAGIC_FUNCTIONS="true"
# DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true"
# COMPLETION_WAITING_DOTS="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# ZSH_CUSTOM=/path/to/new-custom-folder

source $ZSH/oh-my-zsh.sh

# ===========================================================================
# User configuration

export LANG=en_US.UTF-8

for sourceme in $HOME/.shell/*.sh{,.$UNAME} ; do
  source "$sourceme"
done
