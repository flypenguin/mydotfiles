#
# ALIASES
#

# UN-aliases
alias rm >/dev/null 2>&1 && unalias rm
alias cp >/dev/null 2>&1 && unalias cp

# those nifgy G, L etc aliases :)
alias -g WCL=' | wc -l'
alias -g   S=' | sort'

### DEVELOPMENT related aliases
# PYTHON    - VIRTUALENV
alias cvi="mkvirtualenv -p \$(which python3) \$(basename \$(pwd))"
alias wo="workon \$(basename \$(pwd))"
alias cvil="virtualenv -p \$(which python3) .ve-\$(basename \$(pwd))"
alias wol="source .ve-\$(basename \$(pwd))/bin/activate"
# PYTHON    - DJANGO
alias pm="python manage.py"

# console helpers
alias    tma="tmux attach"

# ssh
alias ssr="ssh -l root"
alias ssp="ssh -o PubkeyAuthentication=no"
# $1 = name of the identity file, $@ = ssh parameters
ssi() {
  if [ -z "$2" ] ; then
    echo "USAGE: ssi filename ssh_param [ssh_param ...]"
    return
  fi
  local IDFILE="$1"
  [ ! -f "$IDFILE" ] && IDFILE="$HOME/.ssh/$IDFILE"
  if [ ! -f "$IDFILE" ] ; then
    echo "File '$IDFILE' not found. Looked in: ['.', '~/.ssh']"
    return
  else
    echo "Using ID file: $IDFILE"
  fi
  shift
  ssh -i "$IDFILE" -o IdentitiesOnly=yes "$@"
}

# git
alias gco="git checkout"
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
alias gls="git --no-pager log -n 40 --pretty=format:'%C(yellow)%h %ad%Cred%d %Creset%s%Cblue [%cn]' --decorate --date=short"
alias glc="git            log       --pretty=format:'%C(yellow)%h %ad%Cred%d %Creset%s%Cblue [%cn]' --decorate --date=short"
alias gll="git log --pretty=format:'%C(yellow)%h %C(white)%aD %Cred%d %Creset%s%Cblue [%cn]' --decorate --numstat"
alias gld="git log --pretty=format:'%C(yellow reverse)%h%C(reset) %C(yellow reverse)%ad%C(red reverse)%d%C(reset) %C(white reverse)%s%C(reset)%Cblue [%cn]' --decorate --date=short -p"
alias gds="git --no-pager diff --stat"
alias glf="git log --stat --oneline --pretty='%n%C(yellow reverse)%h%C(reset) %C(yellow)%ad%C(red)%d%C(reset) %C(white)%s%C(reset) %C(blue)[%cn]%C(reset)'"
alias gpb="git push --set-upstream origin \$(git rev-parse --abbrev-ref HEAD)"
# from here: https://stackoverflow.com/a/38404202/902327
alias git-branch-clean="git fetch -p && git branch -vv | awk '/: gone]/{print \$1}' | xargs git branch -d"
alias git-branch-clean-f="git fetch -p && git branch -vv | awk '/: gone]/{print \$1}' | xargs git branch -D"

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
alias yss="pikaur -Ss"
alias  yi="pikaur -S"
alias ysu="pikaur -Syu --aur"

# kubernetes (we already have aliases from ... somewhere, so just add missing)
alias       kd="k describe"
alias     kdds="k describe daemonset"
alias       kg="k get"
alias      kgi="k get ingress"
alias     kgpv="k get pv"
alias     kgds="k get daemonset"
alias     kdel="k delete"

alias     kd-a="k describe --all-namespaces"
alias    kds-a="k describe --all-namespaces svc"
alias    kdp-a="k describe --all-namespaces pod"
alias    kdi-a="k describe --all-namespaces ingress"

alias     kg-a="k get --all-namespaces"
alias    kgi-a="k get --all-namespaces ingress"
alias    kgp-a="k get --all-namespaces pods"
alias   kgds-a="k get --all-namespaces daemonset"

alias       kc="k config"
alias    kcsnd="k config set-context --current --namespace=default"

# k config set namespace
kcsns() {
  k config set-context --current --namespace=$1
}

# docker
alias docker_clean_images="docker images | grep '<none>' | awk '{print \$3}' | xargs docker rmi"
alias docker_rm_all="docker ps -a | grep Exited | cut -d ' ' -f 1 | grep -v CONTAINER | xargs docker rm -f"
alias docker_stop_all="docker ps | cut -d ' ' -f 1 | grep -v CONTAINER | xargs docker stop"
alias docker_kill_all="docker ps | cut -d ' ' -f 1 | grep -v CONTAINER | xargs docker kill"

# OPS
alias   tf="terraform"
alias  tfp="terraform plan"
alias  tfa="terraform apply"
alias tfps="terraform plan -out=terraform.plan"
alias tfas="terraform apply terraform.plan; rm -f terraform.plan"

# JSON conversion with pipes
alias _yml="python -c 'import sys, yaml, json; yaml.safe_dump(json.load(sys.stdin), sys.stdout, default_flow_style=False)'"

# OPS AWS
alias aws-list-instances="aws ec2 describe-instances | jq '.Reservations[].Instances[] | {IP: .PrivateIpAddress, ID: .InstanceId, Name: .Tags[] | select(.Key==\"Name\").Value}'"
alias aws-list-tagged-volumes="aws ec2 describe-volumes | jq '.Volumes[] | select(has(\"Tags\")) | {ID: .VolumeId, Size: .Size, Name: .Tags[] | select(.Key==\"Name\").Value}'"

# azure
alias azgroups="az group list --query '[].name'"

# create hash for ssh (public) keys, mainly for AWS
# see here: https://serverfault.com/a/603983
ssh-key-hash() {
  if [ -z "$1" ]; then
    echo "USAGE: ssh-key-hash PUB_KEY_FILE"
    return
  fi
  if grep -q BEGIN "$1" ; then
    # we have a private key :)
    echo "Found private key."

    echo -n "PUBkey  MD5  openssl:     "
    openssl pkey -in "$1" -pubout -outform DER | openssl md5 -c \
      | grep --color=never -Eo '(([a-z0-9]{2}:)+[a-z0-9]{2})'

    echo -n "PRIVkey SHA1 openssl:     "
    openssl pkcs8 -in "$1" -nocrypt -topk8 -outform DER | openssl sha1 -c \
      | grep --color=never -Eo '(([a-z0-9]{2}:)+[a-z0-9]{2})'
  else
    # we have a public key
    echo "Found public key."
    echo "Use private keys for AWS."
    echo -n "PUBkey  MD5  ssh-keygen:  "
    ssh-keygen -E md5 -lf "$1" | grep --color=never -Eo '(([a-z0-9]{2}:)+[a-z0-9]{2})'
  fi
}


# gitignore service :)
function giti() { curl -L -s https://www.gitignore.io/api/$@ ;}


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