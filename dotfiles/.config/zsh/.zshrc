## FOR INTERACTIVE SHELLS
# zsh ordering:
#   $ZDOTDIR/.zshenv                    # all shells
#   $ZDOTDIR/.zprofile                  # login shells
#   $ZDOTDIR/.zshrc                     # interactive shells
#   $ZDOTDIR/.zlogin                    # login-shells
#   $ZDOTDIR/.zlogout                   # login-shells (on exit)
# see here: http://bit.ly/1sGzo6g

# see remarks (2), (3) at the end
typeset -gU path fpath                  # no dupes in path
path=(
  $HOME/{,s}bin(N)
  $HOME/.local/{,s}bin(N)
  /opt/{homebrew,local}/{,s}bin(N)
  /usr/local/{,s}bin(N)
  $path
)

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
autoload -Uz $ZFUNCDIR/*(N:t~.md)

# Clone antidote if necessary.
ANTIDOTE_PATH="${ZCACHEDIR:-${XDG_CACHE_HOME:-$HOME/.cache}/zsh}/antidote"
if [[ ! -d "$ANTIDOTE_PATH" ]]; then
  mkdir -p "$ANTIDOTE_PATH"
  git clone https://github.com/mattmc3/antidote "${ANTIDOTE_PATH}"
fi

# Set any zstyles you might use for confirmation
# refs:  https://is.gd/ii05Qx (stackov.)  https://is.gd/l5gmgl (zsh docs)
[[ ! -f ${ZDOTDIR}/.zstyles ]] || source ${ZDOTDIR}/.zstyles

# PRE-antidote configs (e.g. the ones modifying plugin init behavior)
export DISABLE_CORRECTION="true"            # might be oh-my-zsh only
export ATUIN_NOBIND="true"                  # I want my own key bindings
export ZSH_THEME=""                         # we use starship below

#  BEFORE direnf (which is loaded by antidote ...)
eval "$(starship init zsh)"

source ${ANTIDOTE_PATH}/antidote.zsh        # load antidote
antidote load


# POST antidote configs (antidote also loads plugins)
# for optiona seee: see: https://linux.die.net/man/1/zshoptions
set -k                                      # recognize inline comments on the command line
bindkey '^r'        atuin-search            # bind atuin keys (reverse-search)
bindkey '^[[1;2A'   atuin-up-search         # SHIFT-UP instead of UP
setopt HIST_IGNORE_SPACE                    # start with " " -> no history entry
setopt HIST_IGNORE_ALL_DUPS                 # ignore duplicates regardless of where
setopt INC_APPEND_HISTORY                   # directly append to history file
setopt INTERACTIVE_COMMENTS                 # enable '#' comments _on the command line_ :)
setopt SHARE_HISTORY                        # reload history after every command
setopt autocd                               # change into dir when entered as "command"
unsetopt correct                            # might be oh-my-zsh only
zstyle ':completion:*' menu no              # see remark (1)
zstyle ':completion:*' special-dirs true    # please complete "cd .._/_" ...
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'  # ...

# see remark (2)
_RC_FILES=(${ZDOTDIR:-$HOME}/.zshrc.d/*(.N))
for _rc in $_RC_FILES ; do
  # Ignore tilde files.
  [[ $_rc:t == '~'* ]] || source "$_rc"
done
unset _rc _RC_FILES




# ##==========================================================================

# REMARKS:
#
# (1) from: https://www.youtube.com/watch?v=ud7YxC33Z3w&t=67s
#
#     - (Try to) set case-insensitive matching (does not work)
#       #  zstyle ':completion:*' matcher-list 'm:{a-Z}={A-Za-z}'
#     - activate fzf-preview on shell tab completion hints (really nice)
#
#
# (2) from: chatGPT
#
#     Glob expressions:
#       path=(..., /some/path/*(N), ...)
#       $ _RC_FILES=(${ZDOTDIR:-$HOME}/.zshrc.d/*(.N))
#     Let's break it down:
#       - _RC_FILES=(...) -> create/modify array var using glob expression(s)
#       - *.sh(.N)        -> the simplified glob expression
#       - (.N)            -> a zsh *modifier*, meaning "NULL_GLOB"
#
#     That modifier ... well, modifies the behavior of the glob expression.
#     In this case it will activate the "NULL_GLOB" flag, which means
#     basically "simply create an empty array var if you do not find any
#     matches". Which is exactly what we want.
#
#     There also is the "NOMATCH" modifier, which is _almost_ the same. It says
#     "if you find nothing, take the literal string '*.sh' (use the glob
#     expression verbatim) as result, which would then try to source the
#     file '*.sh' (the star is the _name_, and not something that is expanced),
#     which of course does not exist.
#
#     Finally: What is (.N) vs (N)? ... No idea. Both seems to work, too lazy
#     to look just now.
#
#     ZSH modifiers list:
#       - https://zsh.sourceforge.io/Doc/Release/Expansion.html#Glob-Qualifiers
#
#
# (3) Why do we set the path _here_, and not in .zshenv?
#
#     Simple reason, probably specific to MacOS: After ~/.zshenv, zsh sources
#     /etc/zprofile, which in turn executes /usr/libexec/path_helper, which
#     will rearrange the path again to our DISpleasure. That might be a MacOS
#     "feature", I have no Linux system at hand to verify this.
#
#
# (4) Remains of older .zshrc versions, unsure if we still require this.
#
#     $ ZSH_CUSTOM=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}
#     $ fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
#     $ autoload -U compinit && compinit
