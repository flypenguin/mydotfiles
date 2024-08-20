# COMMON settings

# less - from http://bit.ly/1r1VoYA
export LESS='-iMRS#15'
if command -v lesspipe.sh > /dev/null ; then
  export LESSOPEN="|/usr/local/bin/lesspipe.sh %s"
fi

# pygmentize - LOWER priority, will be overwritten below
if command -v pygmentize > /dev/null ; then
  export PYGMENTIZE_STYLE='monokai'
  export LESSCOLORIZER="pygmentize"
  # there is _also_ a global alias "P", which comes from ...
  # ... probably the pygmentize package. I stole the alias
  # from there.
  alias -g  LC="2>&1| pygmentize -l pytb"
  alias -g PYG="2>&1| pygmentize -l pytb"
fi

# bat - HIGHER priority, must come _after_ pygmentize above
if command -v bat > /dev/null ; then
  export BAT_THEME="Monokai Extended"
  export LESSCOLORIZER="bat"
  alias -g  LC="|bat --paging=always --color=always"
  alias -g BAT="|bat --paging=always --color=always"
fi

if [[ -f /usr/share/vim/vim90/macros/less.sh ]]; then
  lessc() { /usr/share/vim/vim90/macros/less.sh "$@" }
  # yes, we overwrite the LC alias ...
  alias -g LC="| lessc"
  alias    lc="lessc"
fi

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
