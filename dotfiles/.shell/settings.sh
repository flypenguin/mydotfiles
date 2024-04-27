# COMMON settings

# less - from http://bit.ly/1r1VoYA
export LESS='-iMRS#15'
export LESSOPEN="|$HOME/bin/_lessfilter %s"

# set & create GOPATH ...
export GOPATH="$HOME/Dev/GOPATH"
if [ ! -d "$GOPATH" ]; then
  mkdir -p "$GOPATH"
  echo "This directory is created by $HOME/.shells/settings.sh" > "$GOPATH/REALLY-README.md"
fi

# less awful java font rendering
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'
export EDITOR='vim'

# I *WANT* the virtualenv prompt
unset VIRTUAL_ENV_DISABLE_PROMPT
# now I DON'T want it ;)
#export VIRTUAL_ENV_DISABLE_PROMPT=1

# fucking terraform, this is insane
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
mkdir -p "$TF_PLUGIN_CACHE_DIR"

# ZSH settings

set -k                          # recognize inline comments on the command line

setopt HIST_IGNORE_SPACE        # start with " " -> no history entry
setopt SHARE_HISTORY            # reload history after every command
setopt INC_APPEND_HISTORY       # directly append to history file
setopt autocd                   # change into dir when entered as "command"
unsetopt correct                # might be oh-my-zsh only

DISABLE_CORRECTION="true"       # might be oh-my-zsh only

zstyle ':completion:*' special-dirs true    # please complete "cd .._/_" ...

# AWS

# disable pager
export AWS_PAGER=""
