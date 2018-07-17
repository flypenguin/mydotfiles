#
# ALIASES
#

# UN-aliases
alias rm >/dev/null 2>&1 && unalias rm
alias cp >/dev/null 2>&1 && unalias cp

# python virtualenv - Create VIrtualenv, WorkOn
# using mkvirtualenv
alias cvi="mkvirtualenv -p \$(which python3) \$(basename \$(pwd))"
alias wo="workon \$(basename \$(pwd))"
# local aliases
alias cvil="virtualenv -p \$(which python3) .ve-\$(basename \$(pwd))"
alias wol="source .ve-\$(basename \$(pwd))/bin/activate"

# console helpers
alias -g WL=' | wc -l'
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
alias ls="ls --color=auto"
alias dir="ls -lh"
alias  ll="ls -lh"
alias  la="ls -lha"

# arch
alias  pi="sudo pacman -S"
alias  pq="pacman -Qs"
alias pqs="pq"
alias pss="pacman -Ss"
alias prs="sudo pacman -Rs"
alias psy="sudo pacman -Sy"
alias psu="sudo pacman -Su"
alias yss="yaourt -Ss"
alias  yi="yaourt -S"
alias ysu="yaourt -Syu --aur"

# kubernetes (we already have aliases from ... somewhere, so just add missing)
alias kd="k describe"
alias kdds="k describe daemonset"
alias kg="k get"
alias kgi="k get ingress"
alias kgds="k get daemonset"
alias kdel="k delete"
alias ka="k --all-namespaces"

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
