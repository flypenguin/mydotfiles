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

export _TIME_STARTUP=0

if [[ $_TIME_STARTUP -ne 0 ]] ; then
  # enable using GNU date on Mac
  for t in /usr/local/opt/coreutils/libexec/gnubin/date /usr/bin/date $(which date) ; do
    if [ -f $t ] ; then
      export DATE_BIN=$t
      echo "Using date binary: $DATE_BIN"
      break
    fi
  done
  export _TIME_STARTUP_LAST=$($DATE_BIN +%s.%N)
  export _TIME_STARTUP_FIRST=$_TIME_STARTUP_LAST
fi

ttime() {
  [ "$_TIME_STARTUP" = "0" ] && return
  local NEWTIME
  local DURATION
  local USE_TIME
  [ "$2" = "" ] && USE_TIME=$_TIME_STARTUP_LAST || USE_TIME=$2
  NEWTIME=$($DATE_BIN +%s.%N)
  DURATION=$(( $NEWTIME - $USE_TIME ))
  printf "%15s at %f sec\n" $1 $DURATION
  export _TIME_STARTUP_LAST=$NEWTIME
}


# ############################################################################
# Mangle some more paths
# ############################################################################

# our own binary directory should have preference over the system ones ...
path=("$HOME/bin" $path)

# only relevant for this script.
UNAME=$(uname -s)               # to find out OS later


# ############################################################################
# Start.
# ############################################################################

# start zplug
source ~/.zplug/init.zsh

ttime zplug_init

zplug "zplug/zplug",                  hook-build:"zplug --self-manage"

zplug "Tarrasch/zsh-autoenv"
zplug "johnhamelink/rvm-zsh"
zplug "supercrabtree/k"

# alternate theme(s):
#zplug "themes/robbyrussell",          from:oh-my-zsh

zplug "themes/jreese",                from:oh-my-zsh, as:theme

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
zplug "~/.shell",                     from:local, use:"*.sh{.$UNAME,}"
zplug "~/.shell",                     from:local, use:"*.zsh{.$UNAME,}"

ttime zplug_commands


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
ttime zplug_check


zplug load
ttime zplug_load
ttime all $_TIME_STARTUP_FIRST
