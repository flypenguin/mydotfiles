set -k                          # recognize inline comments on the command line
typeset -U path                 # see here: https://is.gd/1Kfp67

setopt HIST_IGNORE_SPACE        # start with " " -> no history entry
setopt SHARE_HISTORY            # reload history after every command
setopt INC_APPEND_HISTORY       # directly append to history file
setopt autocd                   # change into dir when entered as "command"
unsetopt correct                # might be oh-my-zsh only

DISABLE_CORRECTION="true"       # might be oh-my-zsh only

zstyle ':completion:*' special-dirs true    # please complete "cd .._/_" ...

echo "boooh"
