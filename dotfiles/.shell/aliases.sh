#
# ALIASES
#

# UN-aliases
alias rm >/dev/null 2>&1 && unalias rm
alias cp >/dev/null 2>&1 && unalias cp

# those nifgy G, L etc aliases :)
alias -g WCL=' | wc -l'
alias -g   S=' | sort'

# console helpers
alias    tma="tmux attach"

#
# ssh
alias ssr="ssh -l root"
alias ssp="ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no"
alias sshconfig="vim \$HOME/.ssh/config"
alias ssh-clean="rm -f '$HOME/.ssh/sockets/'*"

# git
alias gco="git checkout"
alias gnp="git --no-pager"
#alias gls="git ls" // git ls was a GIT INTERNAL alias, removed for simplicity.
alias gri="git rebase --interactive"
alias gra="git rebase --abort"
alias grc="git rebase --continue"
alias gpf="git push --force"
alias  gp="git push"
alias  gs="git status"
alias  gd="git diff"
alias gdc="git diff --cached"
# see http://is.gd/h9AB6z
# it's ...
# (g)it (l)og ...
#   (s)hort, (c)ontinuous, (l)ong, (d)iff
# (g)it (d)iff ...
#   (), (s)tat
alias gls="git ls"
alias glv="git --no-pager log -n 30 --pretty=format:'%C(yellow)%h %ad%Creset %s %Cblue[%an]%Cred%d%Creset%+b' --decorate --date=short"
alias glc="git lc"
alias glvc="git            log       --pretty=format:'%C(yellow)%h %ad%Creset %s %Cblue[%an]%Cred%d%Creset%+b' --decorate --date=short"
alias gll="git ll"
alias gld="git ld"
alias gds="git --no-pager diff --stat"
alias glf="git log --stat --oneline --pretty='%n%C(yellow reverse)%h%C(reset) %C(yellow)%ad%C(red)%d%C(reset) %C(white)%s%C(reset) %C(blue)[%an]%C(reset)'"
alias gpb="git push --set-upstream origin \$(git rev-parse --abbrev-ref HEAD)"
# from here: https://stackoverflow.com/a/38404202/902327
alias git-branch-clean="git fetch -p && git branch -vv | awk '/: gone]/{print \$1}' | xargs git branch -d"
alias git-branch-clean-f="git fetch -p && git branch -vv | awk '/: gone]/{print \$1}' | xargs git branch -D"
# overwrite some predefined aliases
alias gb="git --no-pager branch -vv"

# ls
if which exa >/dev/null 2>&1 ; then
  unalias ls
  alias  ls="exa"
  alias  ll="ls -lFh"
  alias  la="ll -a"
  alias  lg="ll -G"
  alias dir="lg"
else
  unalias ls
  alias ls="ls --color=auto"
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
alias     krew="k krew"
alias       kd="k describe"
alias     kdds="k describe daemonset"
alias       kg="k get"
alias      kgi="k get ingress"
alias     kgpv="k get pv"
alias     kgds="k get daemonset"
alias     kdel="k delete"
alias       kc="k config"
alias    kcsnd="k config set-context --current --namespace=default"

# docker
alias docker_clean_images="docker images | grep '<none>' | awk '{print \$3}' | xargs docker rmi"
alias docker_rm_all="docker ps -a | grep Exited | cut -d ' ' -f 1 | grep -v CONTAINER | xargs docker rm -f"
alias docker_stop_all="docker ps | cut -d ' ' -f 1 | grep -v CONTAINER | xargs docker stop"
alias docker_kill_all="docker ps | cut -d ' ' -f 1 | grep -v CONTAINER | xargs docker kill"
alias dockify="eval \$(docker-machine env default)"

# JSON conversion with pipes
alias -g YAML="| python3 -c 'import sys, yaml, json; yaml.safe_dump(json.load(sys.stdin), sys.stdout, default_flow_style=False)'"

# OPS AWS
alias aws-list-instances="aws ec2 describe-instances | jq '.Reservations[].Instances[] | {IP: .PrivateIpAddress, ID: .InstanceId, Name: .Tags[] | select(.Key==\"Name\").Value}'"
alias aws-list-tagged-volumes="aws ec2 describe-volumes | jq '.Volumes[] | select(has(\"Tags\")) | {ID: .VolumeId, Size: .Size, Name: .Tags[] | select(.Key==\"Name\").Value}'"

# azure
alias azgroups="az group list --query '[].name'"

## SINCE WE'RE NOT USING KUBECTL PLUGIN FROM ZSH ANY MORE (too high startup time on mac)
## HERE ARE THE ALIASES ...

alias k=kubectl
alias kca='_kca(){ kubectl "$@" --all-namespaces;  unset -f _kca; }; _kca'
alias kaf='kubectl apply -f'
alias keti='kubectl exec -ti'
alias kcuc='kubectl config use-context'
alias kcsc='kubectl config set-context'
alias kcdc='kubectl config delete-context'
alias kccc='kubectl config current-context'
alias kcgc='kubectl config get-contexts'
# General aliases
alias kdel='kubectl delete'
alias kdelf='kubectl delete -f'
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods --all-namespaces'
alias kgpw='kgp --watch'
alias kgpwide='kgp -o wide'
alias kep='kubectl edit pods'
alias kdp='kubectl describe pods'
alias kdelp='kubectl delete pods'
alias kgpl='kgp -l'
alias kgs='kubectl get svc'
alias kgsa='kubectl get svc --all-namespaces'
alias kgsw='kgs --watch'
alias kgswide='kgs -o wide'
alias kes='kubectl edit svc'
alias kds='kubectl describe svc'
alias kdels='kubectl delete svc'
alias kgi='kubectl get ingress'
alias kgia='kubectl get ingress --all-namespaces'
alias kei='kubectl edit ingress'
alias kdi='kubectl describe ingress'
alias kdeli='kubectl delete ingress'
alias kgns='kubectl get namespaces'
alias kens='kubectl edit namespace'
alias kdns='kubectl describe namespace'
alias kdelns='kubectl delete namespace'
alias kcn='kubectl config set-context $(kubectl config current-context) --namespace'
alias kgcm='kubectl get configmaps'
alias kgcma='kubectl get configmaps --all-namespaces'
alias kecm='kubectl edit configmap'
alias kdcm='kubectl describe configmap'
alias kdelcm='kubectl delete configmap'
alias kgsec='kubectl get secret'
alias kgseca='kubectl get secret --all-namespaces'
alias kdsec='kubectl describe secret'
alias kdelsec='kubectl delete secret'
alias kgd='kubectl get deployment'
alias kgda='kubectl get deployment --all-namespaces'
alias kgdw='kgd --watch'
alias kgdwide='kgd -o wide'
alias ked='kubectl edit deployment'
alias kdd='kubectl describe deployment'
alias kdeld='kubectl delete deployment'
alias ksd='kubectl scale deployment'
alias krsd='kubectl rollout status deployment'
alias kgrs='kubectl get rs'
alias krh='kubectl rollout history'
alias kru='kubectl rollout undo'
alias kgss='kubectl get statefulset'
alias kgssa='kubectl get statefulset --all-namespaces'
alias kgssw='kgss --watch'
alias kgsswide='kgss -o wide'
alias kess='kubectl edit statefulset'
alias kdss='kubectl describe statefulset'
alias kdelss='kubectl delete statefulset'
alias ksss='kubectl scale statefulset'
alias krsss='kubectl rollout status statefulset'
alias kpf="kubectl port-forward"
alias kga='kubectl get all'
alias kgaa='kubectl get all --all-namespaces'
alias kl='kubectl logs'
alias kl1h='kubectl logs --since 1h'
alias kl1m='kubectl logs --since 1m'
alias kl1s='kubectl logs --since 1s'
alias klf='kubectl logs -f'
alias klf1h='kubectl logs --since 1h -f'
alias klf1m='kubectl logs --since 1m -f'
alias klf1s='kubectl logs --since 1s -f'
alias kcp='kubectl cp'
alias kgno='kubectl get nodes'
alias keno='kubectl edit node'
alias kdno='kubectl describe node'
alias kdelno='kubectl delete node'
alias kgpvc='kubectl get pvc'
alias kgpvca='kubectl get pvc --all-namespaces'
alias kgpvcw='kgpvc --watch'
alias kepvc='kubectl edit pvc'
alias kdpvc='kubectl describe pvc'
alias kdelpvc='kubectl delete pvc'
