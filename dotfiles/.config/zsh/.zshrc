#!/bin/zsh
## FOR INTERACTIVE SHELLS
# zsh ordering:
#   $ZDOTDIR/.zshenv                    # all shells
#   $ZDOTDIR/.zprofile                  # login shells
#   $ZDOTDIR/.zshrc                     # interactive shells
#   $ZDOTDIR/.zlogin                    # login-shells
#   $ZDOTDIR/.zlogout                   # login-shells (on exit)
# see here: http://bit.ly/1sGzo6g

# Set the list of directories that zsh searches for commands.
# do this _HERE_, because after ~/.zshenv, zsh sources /etc/zprofile,
# which turn executes /usr/libexec/path_helper, which will rearrange
# the path again to our DISpleasure.

# Ensure path arrays do not contain duplicates.
typeset -gU path fpath

path=(
  $HOME/{,s}bin(N)
  $HOME/.local/{,s}bin(N)
  /opt/{homebrew,local}/{,s}bin(N)
  /usr/local/{,s}bin(N)
  $path
)

# start with .zshrc

# Enable Powerlevel10k instant prompt. Should stay close to the top of .zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

UNAME="${OSTYPE//darwin*/darwin}"

# Lazy-load (autoload) Zsh function files from a directory.
ZFUNCDIR=${ZDOTDIR}/.zfunctions
fpath=($ZFUNCDIR $fpath)
autoload -Uz $ZFUNCDIR/*(.:t)

# Clone antidote if necessary.
ANTIDOTE_PATH="${ZCACHEDIR:-${XDG_CACHE_HOME:-$HOME/.cache}/zsh}/antidote"
if [[ ! -d "$ANTIDOTE_PATH" ]]; then
  mkdir -p "$ANTIDOTE_PATH"
  git clone https://github.com/mattmc3/antidote "${ANTIDOTE_PATH}"
fi

# Set any zstyles you might use for configuration.
[[ ! -f ${ZDOTDIR}/.zstyles ]] || source ${ZDOTDIR}/.zstyles

# Create an amazing Zsh config using antidote plugins.
source ${ANTIDOTE_PATH}/antidote.zsh
antidote load


# Source anything in .zshrc.d.
# see chatgpt ... :roll_eyes_ ...
# _RC_FILES=(...) -> array var
#    ... /path/*  -> glob expansion
#    ... (.N)     -> zsh glob *qualifier*, saying "no result if
#                    nothing found (note: not *modifier*)
# and here we are, and it works.
# see here:
# https://zsh.sourceforge.io/Doc/Release/Expansion.html#Glob-Qualifiers
# Also, the difference between NULL_GLOB and NOMATCH seems to be that
# NOMATCH keeps the *glob expression* (e.g. "*.sh", verbatim) if nothing
# is found -- which we do NOT want.
_RC_FILES=(${ZDOTDIR:-$HOME}/.zshrc.d/*(.N))
for _rc in $_RC_FILES ; do
  # Ignore tilde files.
  if [[ $_rc:t != '~'* ]]; then
    source "$_rc"
  fi
done
unset _rc _RC_FILES

# To customize prompt, run `p10k configure` or edit .p10k.zsh.
[[ ! -f ${ZDOTDIR}/.p10k.zsh ]] || source ${ZDOTDIR}/.p10k.zsh

# find this out later ...
# we need this :/
#ZSH_CUSTOM=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}
#fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
#autoload -U compinit && compinit
