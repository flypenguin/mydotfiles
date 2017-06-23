#
# ALIASES
#

# console helpers
alias -g WL=' | wc -l'

# ssh
alias ssr="ssh -l root"
alias ssp="ssh -o PubkeyAuthentication=no"

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

# docker
alias docker_clean_images="docker images | grep '<none>' | awk '{print \$3}' | xargs docker rmi"
alias docker_rm_all="docker ps -a | grep Exited | cut -d ' ' -f 1 | grep -v CONTAINER | xargs docker rm -f"
alias docker_stop_all="docker ps | cut -d ' ' -f 1 | grep -v CONTAINER | xargs docker stop"
alias docker_kill_all="docker ps | cut -d ' ' -f 1 | grep -v CONTAINER | xargs docker kill"

# OPS
alias   tf="terraform"
alias  tfp="terraform plan"
alias  tfa="terraform apply"
alias tfps="terraform plan -out=terraform-plan-file.tmp"
alias tfas="terraform apply terraform-plan-file.tmp ; rm -f terraform-plan-file.tmp"

# OPS AWS
alias aws-list-instances="aws ec2 describe-instances | jq '.Reservations[].Instances[] | {IP: .PrivateIpAddress, ID: .InstanceId, Name: .Tags[] | select(.Key==\"Name\").Value}'"
