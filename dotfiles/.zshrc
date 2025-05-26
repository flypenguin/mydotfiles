## FOR INTERACTIVE SHELLS
# zsh ordering:
#   $ZDOTDIR/.zshenv                    # all shells
#   $ZDOTDIR/.zprofile                  # login shells
#   $ZDOTDIR/.zshrc                     # interactive shells
#   $ZDOTDIR/.zlogin                    # login-shells
#   $ZDOTDIR/.zlogout                   # login-shells (on exit)
# see here: http://bit.ly/1sGzo6g

local check_for_plugins=()

# we need this :/
UNAME=$(uname -s)
ZSH_CUSTOM=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}

# "dynamic" plugins
ADD_PLUGINS=()

# loads of shit does not work if this is not properly set EARLY.
# later = higher preference, so /usr/local is "first" in the
# list
for PATH_SEARCH in \
  "$HOME/.local/bin" \
  "$HOME/bin" \
; do
  if [ -d "$PATH_SEARCH" ]; then
    path=($PATH_SEARCH $path)
  fi
done

for cmd in $check_for_plugins; do
  if [[ $+commands[$cmd] -eq 1 ]]; then
    ADD_PLUGINS+=$cmd
  fi
done
unset cmd check_for_plugins

# Adding _all_ custom plugins.
# see readme files in the respective directories for more info.
for ADD_PLUGIN in "$ZSH_CUSTOM/plugins/"*; do
  ADD_PLUGIN=${ADD_PLUGIN##*/}
  [[ ! $ADD_PLUGIN == example ]] || continue
  ADD_PLUGINS+=${ADD_PLUGIN##*/}
done
unset ADD_PLUGIN

export ZSH="$HOME/.oh-my-zsh"
export UPDATE_ZSH_DAYS=13

if [ -d "$HOME/.oh-my-zsh.theme" ]; then
  ZSH_THEME="$(cat "$HOME/.oh-my-zsh.theme")"
else
  ZSH_THEME="robbyrussell"
fi

DISABLE_UPDATE_PROMPT="true"
HIST_STAMPS="yyyy-mm-dd"

plugins=(brew direnv common-aliases git podman fzf kubectl aws)
plugins+=(${ADD_PLUGINS[@]})

# CASE_SENSITIVE="true"
# DISABLE_AUTO_UPDATE="true"
# DISABLE_MAGIC_FUNCTIONS="true"
# DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true"
# COMPLETION_WAITING_DOTS="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# ZSH_CUSTOM=/path/to/new-custom-folder

# again taken from https://is.gd/1qNH1K, no idea whether this is actually
# "good" or "shit".

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
autoload -U compinit && compinit

echo plugins=$plugins
source "$ZSH/oh-my-zsh.sh"

# ===========================================================================
# User configuration

export LANG=en_US.UTF-8

# iterm2 shell integration
test -f $HOME/.iterm2_shell_integration.zsh && . $HOME/.iterm2_shell_integration.zsh

for sourceme in $HOME/.shell/*.sh{,.$UNAME} ; do
  source "$sourceme"
done
