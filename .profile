#
# ALIASES
#

# git
alias gco="git checkout"
alias gls="git ls"
alias gri="git rebase --interactive"
alias gra="git rebase --abort"
alias grc="git rebase --continue"
alias gpf="git push --force"
alias  gp="git push"
alias  gs="git status"
alias  gd="git diff"
alias gdc="git diff --cached"

# ls
alias ls="ls --color=auto"
alias dir="ls -lh"

# arch
alias  pi="sudo pacman -S"
alias  pq="pacman -Qs"
alias pss="pacman -Ss"
alias prs="sudo pacman -Rs"
alias psy="sudo pacman -Sy"
alias psu="sudo pacman -Su"
alias yss="yaourt -Ss"
alias  yi="yaourt -S"


#
# SETTINGS
#

# less awful java font rendering
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'


#
# PATH setting ...
#

export PATH="${HOME}/bin:$PATH"

