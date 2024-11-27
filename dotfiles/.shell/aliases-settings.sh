# ###########################################################################
#
# SETTINGS (global)
#

# gpg
export GPG_TTY=$(tty)

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


# ###########################################################################
#
# ALIASES (global)
#

# UN-aliases
alias rm >/dev/null 2>&1 && unalias rm
alias cp >/dev/null 2>&1 && unalias cp

# those nifgy G, L etc aliases :)
alias -g WCL=" | wc -l"
alias -g   S=" | sort"
alias -g   U=" | uniq"
alias -g SED=" | sed"

# console helpers
# "BAT" & "L" are set in helpers.sh
alias    tma="tmux attach"

#
# ssh
alias ssr="ssh -l root"
alias ssp="ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no"
alias sshconfig="vim \$HOME/.ssh/config"
alias ssh-clean="rm -f '$HOME/.ssh/sockets/'*"

# git
# delete all branches not on remote - https://stackoverflow.com/a/38404202/902327
alias git-branch-clean="git fetch -p && git branch -vv | awk '/: gone]/{print \$1}' | xargs git branch -D"
alias git-clean-branches="git-branch-clean"
# short aliases
alias  gco="git checkout"
alias gcob="git checkout -b"
alias  gnp="git --no-pager"
alias  gri="git rebase --interactive"
alias  gra="git rebase --abort"
alias  grc="git rebase --continue"
alias gcpa="git cherry-pick --abort"
alias  gpf="git push --force"
alias   gp="git push"
alias   gs="git status"
alias   gd="git diff"
alias  gdc="git diff --cached"
# see http://is.gd/h9AB6z
# it's ...
# (g)it (l)og ...
#   (s)hort, (c)ontinuous, (l)ong, (d)iff
# (g)it (d)iff ...
#   (), (s)tat
alias  gls="git --no-pager log -n 25 --pretty=format:'%C(yellow)%h %C(bold white)%ci%Creset %s %Cblue[%cn]%Cred%d%Creset' --decorate --date=short"
alias  glv="git --no-pager log -n 25 --pretty=format:'%C(yellow)%h %C(bold white)%ci%Creset %s %Cblue[%an]%Cred%d%Creset%+b' --decorate --date=short"
alias  glc="git            log       --pretty=format:'%C(yellow)%h %C(bold white)%ci%Creset %s %Cblue[%cn]%Cred%d%Creset' --decorate --date=short"
alias glvc="git            log       --pretty=format:'%C(yellow)%h %C(bold white)%ci%Creset %s %Cblue[%an]%Cred%d%Creset%+b' --decorate --date=short"
alias  gll="git log --pretty=format:'%C(yellow)%h %C(yellow reverse)%aD%Creset %s %Cblue[%cn]%Cred%d%Creset' --decorate --numstat"
alias  gld="git log --pretty=format:'%C(white reverse)%n%h %C(yellow reverse)%ad%Creset %C(white reverse)%s%Creset %C(brightblue)[%cn]%C(red)%d%Creset' --decorate --date=short -p"
alias  gds="git --no-pager diff --stat"
alias  glf="git log --stat --oneline --pretty='%n%C(yellow reverse)%h%C(reset) %C(yellow)%ad%C(red)%d%C(reset) %C(white)%s%C(reset) %C(blue)[%an]%C(reset)'"
alias  gpb="git push --set-upstream origin \$(git rev-parse --abbrev-ref HEAD)"
alias gr-h="git reset --hard"
# overwrite some predefined aliases
alias gb="git --no-pager branch -vv"
# stash only staging area
alias gsts="git stash push -S"

# ls
if which eza >/dev/null 2>&1; then
  unalias ls
  alias  ls="eza"
  alias  ll="ls -lh"
  alias  la="ll -a"
  alias  lg="ll -G"
  alias dir="lg"
else
  unalias ls
  alias  ls="ls --color=auto"
  alias  ll="ls -lh"
  alias  la="ls -lha"
  alias dir="ls -lh"
fi

# arch
alias  pi="sudo pacman -S"
alias  pq="pacman -Qs"
alias pqs="pq"
alias pss="pacman -Ss"
alias prs="sudo pacman -Rs"
alias psy="sudo pacman -Sy"
alias psu="psy && sudo pacman -Su"
alias yss="yay -Ss"
alias  yi="yay -S"
alias ysu="yay -Syu --aur"

# tmux
alias tms="tmux list-sessions"

# kubernetes (we already have aliases from ... somewhere, so just add missing)
alias kubeshell="kubectl run my-shell --rm -i --tty --image ubuntu -- bash"
alias      krew="kubectl krew"
alias        kd="kubectl describe"
alias      kdds="kubectl describe daemonset"
alias        kg="kubectl get"
alias       kgi="kubectl get ingress"
alias      kgpv="kubectl get pv"
alias      kgds="kubectl get daemonset"
alias      kdel="kubectl delete"
alias        kc="kubectl config"
alias     kcsnd="kubectl config set-context --current --namespace=default"

# docker
alias docker-clean-images="docker images | grep '<none>' | awk '{print \$3}' | xargs docker rmi"
alias docker-rm-all="docker ps -a | grep Exited | cut -d ' ' -f 1 | grep -v CONTAINER | xargs docker rm -f"
alias docker-stop-all="docker ps | cut -d ' ' -f 1 | grep -v CONTAINER | xargs docker stop"
alias docker-kill-all="docker ps | cut -d ' ' -f 1 | grep -v CONTAINER | xargs docker kill"
alias dockify="eval \$(docker-machine env default)"
alias dra="docker-rm-all"
alias dci="docker-clean-images"
alias dsa="docker-stop-all"
alias dka="docker-kill-all"

# JSON conversion with pipes
alias -g YAML="| python3 -c 'import sys, yaml, json; yaml.safe_dump(json.load(sys.stdin), sys.stdout, default_flow_style=False)'"

# OPS AWS
alias aws-list-instances="aws ec2 describe-instances | jq '.Reservations[].Instances[] | {IP: .PrivateIpAddress, ID: .InstanceId, Name: .Tags[] | select(.Key==\"Name\").Value}'"
alias aws-list-tagged-volumes="aws ec2 describe-volumes | jq '.Volumes[] | select(has(\"Tags\")) | {ID: .VolumeId, Size: .Size, Name: .Tags[] | select(.Key==\"Name\").Value}'"

# azure
alias azgroups="az group list --query '[].name'"

## SINCE WE'RE NOT USING KUBECTL PLUGIN FROM ZSH ANY MORE (too high startup time on mac)
## HERE ARE THE ALIASES ...

# kubectl ...
alias       k=kubectl
alias      ka="kubectl apply"
alias     kaf="kubectl apply -f"
alias      kr="kubectl remove"

# kubectl config ...
alias     kcuc="kubectl config use-context"
alias     kcsc="kubectl config set-context"
alias     kcdc="kubectl config delete-context"
alias     kccc="kubectl config current-context"
alias     kcgc="kubectl config get-contexts"
alias      kcn="kubectl config set-context \$(kubectl config current-context) --namespace"

alias     kdel="kubectl delete"
alias    kdelf="kubectl delete -f"
alias    kdelp="kubectl delete pods"
alias    kdels="kubectl delete svc"
alias    kdeli="kubectl delete ingress"
alias   kdelns="kubectl delete namespace"
alias   kdelcm="kubectl delete configmap"
alias  kdelsec="kubectl delete secret"
alias    kdeld="kubectl delete deployment"
alias   kdelss="kubectl delete statefulset"
alias   kdelno="kubectl delete node"
alias  kdelpvc="kubectl delete pvc"

alias     kdcm="kubectl describe configmap"
alias      kdd="kubectl describe deployment"
alias      kdi="kubectl describe ingress"
alias     kdns="kubectl describe namespace"
alias     kdno="kubectl describe node"
alias      kdp="kubectl describe pods"
alias    kdpvc="kubectl describe pvc"
alias    kdsec="kubectl describe secret"
alias     kdss="kubectl describe statefulset"
alias      kds="kubectl describe svc"

alias     kecm="kubectl edit configmap"
alias      ked="kubectl edit deployment"
alias      kei="kubectl edit ingress"
alias     kens="kubectl edit namespace"
alias     keno="kubectl edit node"
alias      kep="kubectl edit pods"
alias    kepvc="kubectl edit pvc"
alias     kess="kubectl edit statefulset"
alias      kes="kubectl edit svc"

alias      kga="kubectl get all"
alias     kgaa="kubectl get all --all-namespaces"
alias     kgcm="kubectl get configmaps"
alias    kgcma="kubectl get configmaps --all-namespaces"
alias      kgd="kubectl get deployment"
alias     kgda="kubectl get deployment --all-namespaces"
alias     kgdw="kubectl get deployment --watch"
alias  kgdwide="kubectl get deployment -o wide"
alias      kgi="kubectl get ingress"
alias     kgia="kubectl get ingress --all-namespaces"
alias      kgp="kubectl get pods"
alias     kgpa="kubectl get pods --all-namespaces"
alias     kgpl="kubectl get pods -l"
alias  kgpwide="kubectl get pods -o wide"
alias     kgpw="kubectl get pods --watch"
alias    kgpvc="kubectl get pvc"
alias   kgpvca="kubectl get pvc --all-namespaces"
alias   kgpvcw="kubectl get pvc --watch"
alias     kgns="kubectl get namespaces"
alias     kgno="kubectl get nodes"
alias     kgrs="kubectl get rs"
alias    kgsec="kubectl get secret"
alias   kgseca="kubectl get secret --all-namespaces"
alias     kgsw="kubectl get secret --watch"
alias  kgswide="kubectl get secret -o wide"
alias     kgss="kubectl get statefulset"
alias    kgssa="kubectl get statefulset --all-namespaces"
alias    kgssw="kubectl get statefulset --watch"
alias kgsswide="kubectl get statefulset -o wide"
alias      kgs="kubectl get svc"
alias     kgsa="kubectl get svc --all-namespaces"

alias       kl="kubectl logs"
alias      klf="kubectl logs -f"
alias     kl1h="kubectl logs --since 1h"
alias     kl1m="kubectl logs --since 1m"
alias     kl1s="kubectl logs --since 1s"
alias    klf1h="kubectl logs --since 1h -f"
alias    klf1m="kubectl logs --since 1m -f"
alias    klf1s="kubectl logs --since 1s -f"

# other ...
alias      kca="_kca(){ kubectl \"$@\" --all-namespaces;  unset -f _kca; }; _kca"
alias      kaf="kubectl apply -f"
alias      kcp="kubectl cp"
alias     keti="kubectl exec -ti"
alias      kpf="kubectl port-forward"
alias     krsd="kubectl rollout status deployment"
alias      krh="kubectl rollout history"
alias      kru="kubectl rollout undo"
alias    krsss="kubectl rollout status statefulset"
alias      ksd="kubectl scale deployment"
alias     ksss="kubectl scale statefulset"