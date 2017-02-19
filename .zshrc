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

TIME_CALLS=0
TIME_LAST=$(/usr/local/opt/coreutils/libexec/gnubin/date +%s.%N)
TIME_START=$TIME_LAST
ttime() {
  [ "$TIME_CALLS" = "0" ] && return
  local NEWTIME
  local DURATION
  local USE_TIME
  [ "$2" = "" ] && USE_TIME=$TIME_LAST || USE_TIME=$2
  NEWTIME=$(/usr/local/opt/coreutils/libexec/gnubin/date +%s.%N)
  DURATION=$(( $NEWTIME - $USE_TIME ))
  printf "%15s done after %f\n" $1 $DURATION
  TIME_LAST=$NEWTIME
}


# ############################################################################
# Init
# ############################################################################

set -k                          # recognize inline comments on the command line
setopt HIST_IGNORE_SPACE        # start with " " -> no history entry
typeset -U path                 # see here: https://is.gd/1Kfp67
UNAME=$(uname -s)               # to find out OS later
DISABLE_CORRECTION="true"       # might be oh-my-zsh only
unsetopt correct                # dito
setopt autocd
zstyle ':completion:*' special-dirs true    # please complete "cd .._/_" ...

[ -f "$HOME/.settings" ] && source "$HOME/.settings"
[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"

ttime init

# ############################################################################
# Mac OS specific settings.
# ############################################################################

if [[ "$UNAME" = "Darwin" ]] ; then
  # use iterm2 shell integration
  source "$HOME/bin/iterm2_shell_integration.zsh"

  # nice keyboard bindings
  bindkey '[D' backward-word          # alt-left
  bindkey '[C' forward-word           # alt-right

  # use homebrew gnu utils if intalled instead of system binaries
  # we might be able to speed this up using the find command
  for a in /usr/local/opt/* ; do
    [ -d "$a/libexec/gnubin" ] && path=("$a/libexec/gnubin" $path)
  done
  [ -d /usr/local/sbin ] && path=("$a/libexec/gnubin" $path)
fi
ttime mac_specific

# ############################################################################
# Mangle some more paths
# ############################################################################

# we SHOULD not need this much longer (maybe), thanks to zplug :D
if [ -d "$HOME/clis" ] ; then
  for p in "$HOME/clis/"* ; do
    [ -d "$p/bin" ] && p="$p/bin"
    path+=($p)
  done
fi
ttime clis

# our own binary directory should have preference over the system ones ...
path=("$HOME/bin" $path)

# load rvm
if [ -d "$HOME/.rvm" ]; then
    path=("$HOME/.rvm" $path)
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
fi
ttime rvm


# ############################################################################
# Start.
# ############################################################################

# start zplug
source ~/.zplug/init.zsh

ttime zplug_init

zplug "zplug/zplug",            hook-build:"zplug --self-manage"

zplug "Tarrasch/zsh-autoenv"
zplug "johnhamelink/rvm-zsh",   if:"which rvm"

zplug "themes/robbyrussell",    from:oh-my-zsh
zplug "plugins/git",            from:oh-my-zsh
zplug "plugins/rvm",            from:oh-my-zsh
zplug "lib/directories",        from:oh-my-zsh
zplug "lib/grep",               from:oh-my-zsh
zplug "lib/termsupport",        from:oh-my-zsh
zplug "lib/completion",         from:oh-my-zsh

# I ignore local-* in this directory. so for host-local settings, this is
# the place to put them. cool, eh? :)
zplug "~/.zsh",                 from:local, use:"*.zsh"

ttime zplug_commands


# ############################################################################
# Almost done - do host-local settings if present
# ############################################################################

[ -f "$HOME/.zshrc.local" ] && source $a


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
ttime all $TIME_START
