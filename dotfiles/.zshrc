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
  "/home/linuxbrew/.linuxbrew/bin" \
  "/usr/local/bin" \
  "/opt/homebrew/bin" \
  "$HOME/.local/bin" \
  "$HOME/bin" \
; do
  if [ -d "$PATH_SEARCH" ]; then
    path=($PATH_SEARCH $path)
    ADD_PLUGINS+="brew"
  fi
done

# see https://github.com/paulirish/git-open?tab=readme-ov-file#oh-my-zsh
# for installation instructions
if [ -d $HOME/.oh-my-zsh/custom/plugins/git-open ]; then
  echo "add git-open"
  ADD_PLUGINS+="git-open"
fi

export ZSH="$HOME/.oh-my-zsh"
export UPDATE_ZSH_DAYS=13

if [ -d "$HOME/.oh-my-zsh.theme" ]; then
  ZSH_THEME="$(cat "$HOME/.oh-my-zsh.theme")"
else
  ZSH_THEME="robbyrussell"
fi

DISABLE_UPDATE_PROMPT="true"
HIST_STAMPS="yyyy-mm-dd"

plugins=(direnv git docker podman common-aliases kubectl fzf aws brew git-open)
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

# iterm2 shell integration
test -f $HOME/.iterm2_shell_integration.zsh && . $HOME/.iterm2_shell_integration.zsh

for sourceme in $HOME/.shell/*.sh{,.$UNAME} ; do
  source "$sourceme"
done
