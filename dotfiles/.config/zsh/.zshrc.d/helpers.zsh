# ###########################################################################
#
# always useful: some colors ...
#

C_BOLD="\e[1m"
C_BRED="\e[91m"
C_BGRE="\e[92m"
C_BYEL="\e[93m"
C_BWHI="\e[97m"
C_REST="\e[0m"
H_GREN="${C_BGRE}${C_BOLD}"
H_YELO="${C_BYEL}${C_BOLD}"
H_REDD="${C_BRED}${C_BOLD}"
DINFO="${C_BWHI}${C_BOLD}INFO:${C_REST}"
DERRR="${C_BRED}${C_BOLD}ERROR:${C_REST}"
DWARN="${C_BYEL}${C_BOLD}WARNING:${C_REST}"


# ###########################################################################
#
# shell & system
#

clean-ds() {
  find . -name ".DS_Store" -print -delete
}


# ###########################################################################
#
# git
#

# $1 - message
# very stupid alias for "git commit -m 'upd: ...'"
if whence git > /dev/null ; then
    local _func='!_git_upd() {
    local num_args=$#
    local original_args=("$@")
    local git_args=()
    local message=""
    local scope=""
    local important=""
    i=0  # Zsh arrays are 1-indexed by default
    while (( i <= num_args )); do
        arg="${original_args[i]}"
        if [[ "$arg" == -m* ]]; then
            (( i+= 1 ))
            message="${original_args[i]}"
        elif [[ "$arg" == --scope ]]; then
            (( i+= 1 ))
            scope="${original_args[i]}"
        elif [[ "$arg" == --important ]]; then
            important="\!"
        else
            git_args+=("$arg")
        fi
        (( i+= 1 ))
    done

    [[ -n "$scope" ]] && scope="($scope)"
    message="upd${scope}$important: $message"
    echo git commit -m "\"$message\"" "${git_args[@]}"
    git commit -m "$message" "${git_args[@]}"
}
_git_upd'
    # INACTIVE FOR NOW, does not work for _whatever_ reason ... :/
    #git config --global alias.upd "$_func"
    unset _func
fi


# ###########################################################################
#
# python
#

# $1 - optional - work on WHAT. default: current path name
# WHY DO WE NEED THIS EPIC SHIT?!
# BECAUSE FUCKING PYENV ACTIVATE DOES NOT MODIFY THE GODFORSAKEN
# PROMPT, BECAUSE "FUCK IT". THIS IS THE ULTIMATE FUCKED UP MOTHERFUCKING
# BLOODY FUCKED UP SHIT SHOW.
# also, the auto-activate feature is probably fucked up and broken as well.
# python envs are just the MOTHER of all FUCKs.
wo() {
  local activate_script
  local base_dir
  activate_script=""
  base_dir="${1:-.}"
  for venv_dir in venv .venv . ; do
    [[ -d "$base_dir/$venv_dir"  ]] && activate_script="$base_dir/$venv_dir/bin/activate" && break
  done
  if [[ ! -f "$activate_script" ]]; then
    echo "ERROR: Activation script not found."
    echo "Aborting."
    return
  fi
  source "$activate_script"
}


# ###########################################################################
#
# azure
#

# ac - az with jsonc output
ac() {
  az "$@" --output jsonc
}

# aj - az with json output
aj() {
  az "$@" --output json
}

# ###########################################################################
#
# ssh
#

# wrapper around "ssh-keygen -R"
skr() {
  if [[ -z "${1:-}" ]] ; then
    echo "USAGE: skr REGEX"
    echo "       removes keys from known hosts file"
    return 1
  fi
  set -x
  local hostname
  hostname="$(ssh -G $1 | awk '/^hostname / {print $2}')"
  [[ -n "$hostname" ]] && ssh-keygen -R "$hostname" || echo "No host found for '$1'."
  cat "$HOME/.ssh/known_hosts" | grep -Ev "$1" > "$HOME/.ssh/known_hosts.new"
  mv -f "$HOME/.ssh/known_hosts.new" "$HOME/.ssh/known_hosts"
  set +x
}

# $1 = name of the identity file
# $@ = ssh parameters
ssi() {
  if [ -z "$2" ]; then
    echo "USAGE: ssi filename ssh_param [ssh_param ...]"
    return
  fi
  local IDFILE="$1"
  [ ! -f "$IDFILE" ] && IDFILE="$HOME/.ssh/$IDFILE"
  if [ ! -f "$IDFILE" ]; then
    echo "File '$IDFILE' not found. Looked in: ['.', '~/.ssh']"
    return
  else
    echo "Using ID file: $IDFILE"
  fi
  shift
  ssh -i "$IDFILE" -o IdentitiesOnly=yes "$@"
}

# create hash for ssh (public) keys, mainly for AWS
# see here: https://serverfault.com/a/603983, https://is.gd/OURGbO
ssh-key-hash() {
  if [ -z "$1" ]; then
    echo "USAGE: ssh-key-hash (PUB_)KEY_FILE"
    return
  fi
  if grep -q "OPENSSH PRIVATE KEY" "$1"; then
    echo "ERROR: OPENSSH PRIVATE KEYs are not supported (yet)."
    echo "To convert the file IN PLACE to openSSL RSA format, use the command below."
    echo "AGAIN: this WILL CHANGE the saved file!"
    echo ""
    echo "    ssh-keygen -pN \"\" -m pem -f \"$1\""
    echo ""
  elif grep -q "RSA PRIVATE KEY" "$1"; then
    # we have a private key :)
    echo "Found RSA private key."

    echo -n "PUBkey  MD5  openssl:     "
    openssl pkey -in "$1" -pubout -outform DER | openssl md5 -c |
      grep --color=never -Eo '(([a-z0-9]{2}:)+[a-z0-9]{2})'

    echo -n "PRIVkey SHA1 openssl:     "
    openssl pkcs8 -in "$1" -inform PEM -outform DER -topk8 -nocrypt |
      openssl sha1 -c 2>/dev/null |
      grep --color=never -Eo '(([a-z0-9]{2}:)+[a-z0-9]{2})'

    echo -n "PRIVkey MD5 openssl:      "
    openssl rsa -in "$1" -pubout -outform DER |
      openssl md5 -c |
      grep --color=never -Eo '(([a-z0-9]{2}:)+[a-z0-9]{2})'
  else
    # we have a public key
    echo -n "PUBkey MD5 AWS hash (AWS):   "
    ssh-keygen -f "$1" -e -m PKCS8 |
      openssl pkey -pubin -outform DER |
      openssl md5 -c
    echo -n "PUBkey MD5 ssh-keygen hash:  "
    ssh-keygen -E md5 -lf "$1" | grep --color=never -Eo '(([a-z0-9]{2}:)+[a-z0-9]{2})'
  fi
}

ssh-test-key() {
  if [[ -z "${1:-}" ]]; then
    echo "USAGE: ssh-test-key  SSH_KEY  SSH_TARGET"
    echo ""
    echo "Examples:"
    echo "    ssh-test-key  ./id_ed25519_key  git@github.com:Group/repo.git"
    echo "    ssh-test-key  ./id_ed25519_key  myuser@myhost.com"
    return
  elif [[ ! -f "${1:-}" ]]; then
    echo "ERROR: No such key file: '$1'."
    return
  fi
  echo "Using key: $1"
  local SSH_KEY_FILE="$1"
  local SSH_TARGET="$2"
  local GIT_TMP
  GIT_TMP=(
    ssh -o "IdentityFile=$SSH_KEY_FILE"
        -o IdentitiesOnly=yes
        -o IdentityAgent=none
        -o IgnoreUnknown=UseKeyChain
        -o StrictHostKeyChecking=no
        -o UseKeyChain=no
        -o UserKnownHostsFile=/dev/null
        -F /dev/null
  )
  if [[ "$SSH_TARGET" == "git@"* ]]; then
    echo "Checking git access ..."
    GIT_SSH_COMMAND="${GIT_TMP}" git ls-remote $SSH_TARGET
  else
    echo "Checking SSH host access ..."
    "${GIT_TMP[@]}" "$SSH_TARGET"
  fi
}

# let's alias those
alias aws-ssh-fingerprint=ssh-key-hash
alias ssh-aws-fingerprint=ssh-key-hash
alias aws-fp=ssh-key-hash

grH() {
  if [[ -z "${1:-}" ]] ; then
    echo "USAGE: grHH <num-of-commits>"
    echo "       executes 'git reset --hard HEAD~<num-of-commits'"
    return 1
  fi
  git reset --hard HEAD~$1
}

# create a backup branch of the current one
gibb() {
  BBRANCH="backup/$(git rev-parse --abbrev-ref HEAD)/$(date "+%Y%m%d-%H%M%S")"
  git branch "$BBRANCH"
  echo "$BBRANCH"
}

# gitignore service :)
function giti() { curl -L -s https://www.gitignore.io/api/$@; }

# giba = git backup [branch]
function giba() {
  CURRENT_COMMIT="$(git rev-parse --short HEAD)"
  CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
  BACKUP_BRANCH="backup/$CURRENT_BRANCH/$(date +%Y%m%d-%H%M%S)"
  git checkout -b "$BACKUP_BRANCH" > /dev/null
  git checkout "$CURRENT_BRANCH" > /dev/null
  echo "Created backup branch: $CURRENT_COMMIT -> '$BACKUP_BRANCH'"
}

# gdelb = git delete branch
# $1 - name of branch to delete
function gdelb() {
  branch_to_delete="$1"
  git branch -D "$branch_to_delete" && \
    git push origin ":$branch_to_delete"
}


# ###########################################################################
#
# K8S
#

ks() {
  CONTEXTS="$(kubectl config get-contexts 2>&1 | sed -e 1d -Ee 's/^.{8}//g' | awk '{print $1}')"
  CONTEXT="$(echo $CONTEXTS | fzf)"
  [[ -z $CONTEXT ]] && return
  k9s --context "$CONTEXT" -c pods
}


# (h)elm (s)ave (v)alues
#   $1 - search term
hsv() {
  local RESULT=""
  local DIR="."
  local SEARCH_TERM="${1:-}"
  while [[ "$SEARCH_TERM" == "-"* && "$DIR" != "-"* ]] ; do
    case "$SEARCH_TERM" in
      -h) break ;; # display help
      -s) RESULT="Show"  ; shift ; SEARCH_TERM="${1:-}" ;;
      -w) RESULT="Write" ; shift ; SEARCH_TERM="${1:-}" ;;
      -d) RESULT="Write" ; shift ; DIR="${1:-}" ; shift ; SEARCH_TERM="${1:-}" ;;
    esac
  done
  DIR="${DIR%/}"
  if [[ ! -d "$DIR" ]]; then
    echo -e "ERROR: Not a directory: '$DIR'.\nAborting." > /dev/stderr
    return 1
  elif [[ -z "$SEARCH_TERM" || "$SEARCH_TERM" == "-h" ]] ; then
    [[ -z "$SEARCH_TERM" ]] && echo -e "\nERROR: Search term missing." > /dev/stderr
    [[ "$DIR" == "-" ]] && echo -e "\nERROR: Output directory missing." > /dev/stderr
    local ME="${0##*/}"
    echo ""
    echo "USAGE:"
    echo ""
    echo "    ${ME} SEARCH_TERM [...]"
    echo "    ${ME} SEARCH_TERM -s [...]"
    echo "    ${ME} SEARCH_TERM -w [...]"
    echo "    ${ME} SEARCH_TERM -d DIR [...]"
    echo ""
    echo "  Tries to find SEARCH_TERM in installed helm repos, and displays"
    echo "  the default values file of the first result to stdout."
    echo "  Basically performs ..."
    echo "    \$ helm search repo -r [...] SEARCH_TERM"
    echo "  (yes, [...] is moved to the front)"
    echo ""
    echo "  Parameters:"
    echo "    -h   show help and exit"
    echo "    -s   print default values to stdout"
    echo "    -w   write default values into (REPO)--(CHART)-v(VERSION).yaml"
    echo "         in the current working dir"
    echo "    -d   writes file into DIR, implies -w"
    echo ""
    echo "  Without -s ('show' on stdout) or -w ('write' to file) $ME will"
    echo "  ask what to do - write or show."
    echo ""
    return 1
  fi

  shift

  local SEARCH_RESULT="$(helm search repo -o json -r "$@" "$SEARCH_TERM")"
  if [[ "$SEARCH_RESULT" != "[]" ]]; then
    local REPO_NAME="$(printf "$SEARCH_RESULT" | jq -r ".[0].name")"
    local REPO_VERSION="$(printf "$SEARCH_RESULT" | jq -r ".[0].version")"
    local OUTFILE="${DIR}/${REPO_NAME//\//--}-$REPO_VERSION.yaml"
    [[ -n "$RESULT" ]] || RESULT=$( \
      echo -n "Show values\nSave values to '$OUTFILE'" \
      | fzf \
        --height=~100% \
        --prompt 'Do what with the values?' \
        --layout=reverse \
        --accept-nth=1 --delimiter=" "
    )
    if [[ -z "$RESULT" ]]; then echo "Abort." ; return 1 ; fi
    if [[ "$RESULT" == "Show" ]] ; then
      local PAGER
      command -v bat > /dev/null && PAGER=(bat -l yaml) || PAGER=(less)
      helm show values "$REPO_NAME" | "${PAGER[@]}"
    else
      helm show values "$REPO_NAME" >"$OUTFILE"
      helm show values "$REPO_NAME" \
      | grep -Ev '^ *(#.*)?$' \
      > "${OUTFILE%.yaml}.plain.yaml"
      echo -e "Default values of $REPO_NAME written to:\n    $OUTFILE"
    fi
  else
    echo "Error looking up '$SEARCH_TERM', no results found."
  fi
}


# ###########################################################################
#
# AWS
#

_set_aws_region() {
  AWS_REGION=${AWS_REGION:-$AWS_DEFAULT_REGION}
  if [[ -z $AWS_REGION ]]; then
    echo "WARNING: Setting AWS_REGION to 'eu-central-1'" >&2
    export AWS_REGION="eu-central-1"
  fi
}

ecr-login() {
  _set_aws_region
  local ACC_ID="$(aws sts get-caller-identity --query Account --output text)"
  for cmd in podman docker skopeo ; do
    if ! command -v $cmd > /dev/null ; then continue ; fi
    echo "Logging in to $cmd ..."
    aws ecr get-login-password \
      | $cmd login --username AWS --password-stdin $ACC_ID.dkr.ecr.$AWS_REGION.amazonaws.com
  done
}

# $@ - optional grep filter parameters
ecr-list-repos() {
  if [[ ${1:-} = -h ]]; then
    echo "USAGE: ecr-list-repos [GREP_PARAM,...]"
    echo "       List all ecr repos in the currently active account"
    echo "       GREP_PARAM is passed to a grep expression to filter"
    echo "       the output."
    echo "EXAMPLES:"
    echo "       List all repos:"
    echo "           ecr-list-repos"
    echo "       List all repos starting with '/test':"
    echo "           ecr-list-repos \\aws.com/test"
    echo "       List all repos with 'air' anywhere in the name:"
    echo "           ecr-list-repos air"
    echo "       List all repos without 'a' in the name:"
    echo "           ecr-list-repos -v a"
    echo "       Colorize grep output (makes only sense with a grep pattern):"
    echo "           ecr-list-repos --color=yes PATTERN"
    echo "       ... etc."
    return 255
  fi
  _set_aws_region
  local REPOS=$(aws ecr describe-repositories \
    --query "repositories[*].repositoryUri" \
    | jq -r '.[]' \
    | sort
  )
  if [[ -z $REPOS ]]; then
    echo "No repositories found." > /sys/stderr
    return 2
  fi
  # only call 'grep' if we actually _have_ grep parameters.
  # grep without a pattern will result in an error.
  local GREP_CMD=("cat")
  [[ -z $1 ]] || GREP_CMD=("grep" "-P")
  # let's REMOVE the "1234.dkr.[...]aws.com/" part, and apply the grep
  # _only_ to the actual repo name. then re-add the whole thing, so
  # you can copy-paste the output.
  local FQDN="${REPOS%%/*}"
  local REPO
  (while read REPO ; do echo "${REPO#*/}"; done < <(echo $REPOS)) \
  | "${GREP_CMD[@]}" "$@" \
  | sed -Ee "s:^:$FQDN/:"
}

# $1    - repo name (required)
# $2..n - optional grep parameters
ecr-list-images() {
  local ECR_REPO
  ECR_REPO="${1:-}"
  if [[ -z $ECR_REPO ]] || [[ $ECR_REPO = -h ]]; then
    echo "USAGE: ecr-list-images REPONAME [GREP_FILTER,...]"
    echo "       List all image tags in the ECR repo 'REPONAME'"
    echo "EXAMPLES:"
    echo "       List all images with 'prod' in the name:"
    echo "           ecr-list-images prod"
    echo "       List all images with 'prod' _not_ in the name:"
    echo "           ecr-list-images -v prod"
    return 1
  fi
  shift
  # make sure we can post _any_ full ECR image "thing",
  # and just extract the repo name.
  ECR_REPO="${ECR_REPO#*.com/}"
  ECR_REPO="${ECR_REPO%:*}"
  # same as above - only call 'grep' in case we have actual patterns
  # given as parameters.
  local GREP_CMD=("cat")
  [[ -z $1 ]] || GREP_CMD=("grep" "-P")
  # gooooo ...
  _set_aws_region
  aws ecr list-images \
    --repository-name "$ECR_REPO" \
    --query 'imageIds[*].[imageTag]' \
    --output text \
    | awk "{print \"$ECR_REPO:\"\$1}" \
    | sort \
    | uniq \
    | "${GREP_CMD[@]}" "$@"
}

AWS_TOKEN_DURATION=28800 # AWS_8h

C_BOLD="\e[1m"
C_BRED="\e[91m"
C_BGRE="\e[92m"
C_BYEL="\e[93m"
C_BWHI="\e[97m"
C_REST="\e[0m"
H_GREN="${C_BGRE}${C_BOLD}"
H_YELO="${C_BYEL}${C_BOLD}"
H_REDD="${C_BRED}${C_BOLD}"
DINFO="${C_BWHI}${C_BOLD}INFO:${C_REST}"
DERRR="${C_BRED}${C_BOLD}ERROR:${C_REST}"
DWARN="${C_BYEL}${C_BOLD}WARNING:${C_REST}"

# this function assumes the following env variables are present:
#   - AWS_TOKEN_VALIDITY
# parameters
#   $1 - the AWS profile for which to check
# it returns:
#   0 - still valid (loaded _OR_ active tokens)
#   1 - token almost expired
#   2 - token expired
#   3 - no token found
_aws_load_token() {
  local TOKEN_FILE="$HOME/.aws/token.$1.sh"

  if [ "$AWS_MFA_BASE" != "$1" ]; then
    if [ ! -f "$TOKEN_FILE" ]; then
      # "no existing token found"
      echo "$DINFO ${H_YELO}No existing token${C_REST} found."
      return 3
    else
      . "$TOKEN_FILE"
    fi
  fi
  # now we are set and can verify the token lifetime
  local TIME_NOW=$(date +%s)
  local TIME_REMAINING=$((AWS_TOKEN_VALIDITY - TIME_NOW))
  if ((TIME_REMAINING > 3600)); then
    echo "$DINFO existing ${H_GREN}token still valid${C_REST} (and active)"
    return 0
  fi
  # token no longer "fresh", let's check if there's a newer one already in the
  # TOKEN_FILE ...
  if [ -f "$TOKEN_FILE" ]; then
    . "$TOKEN_FILE"
    TIME_REMAINING=$((AWS_TOKEN_VALIDITY - TIME_NOW))
    if ((TIME_REMAINING > 3600)); then
      echo "$DINFO saved ${H_GREN}token still valid${C_REST} (and now active)"
      return 0
    fi
  fi
  # so we're REALLY no longer "fresh" ...
  if ((TIME_REMAINING > 0)); then
    # "token almost expired"
    echo "$DINFO existing ${H_YELO}token almost expired${C_REST}, creating new one"
    return 2
  else
    echo "$DINFO existing ${H_YELO}token expired${C_REST}, creating new one"
    # "token expired"
    return 1
  fi
}

# parameters:
#   $1 - the profile to get a token for
_aws_get_new_token() {
  local TOKEN_FILE="$HOME/.aws/token.$1.sh"
  local SED_MARKER
  local TMP

  echo -n ">> Enter MFA token value (ENTER to abort): "
  read MFA_TOKEN
  if [ -z "$MFA_TOKEN" ]; then
    echo "Abort."
    return 1
  fi

  # clean env variables, but only if a session token is active
  if [ -n "$AWS_MFA_BASE" ]; then
    echo "* Cleaning existing ENV vars (already have a session token)"
    unset AWS_SESSION_TOKEN
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
  fi

  export AWS_PROFILE="$1"

  echo -n "* Getting MFA ARN ... "
  MFA_ARN=$(aws --profile $AWS_PROFILE iam list-mfa-devices | jq -r '.MFADevices[0].SerialNumber')
  if [ "$?" != "0" ]; then
    echo "$DERRR something failed getting the session token. You should close this shell."
    return 2
  fi
  echo $MFA_ARN

  echo -n "* Getting session token ... "
  SESSION_TOKEN_JSON=$(aws --profile $AWS_PROFILE sts get-session-token --serial-number $MFA_ARN --token-code $MFA_TOKEN --duration-seconds $AWS_TOKEN_DURATION)
  if [ "$?" != "0" ]; then
    echo "$DERRR something failed getting the session token. You should close this shell."
    return 3
  else
    export AWS_TOKEN_VALIDITY=$(($(date +%s) + AWS_TOKEN_DURATION))
    export AWS_MFA_BASE=$AWS_PROFILE
    export AWS_PROFILE="$1_mfasession"
    echo "${C_BGRE}${C_BOLD}done${C_REST}."
  fi

  echo -n "* Setting env variables ... "
  export AWS_ACCESS_KEY_ID=$(echo $SESSION_TOKEN_JSON | jq -r '.Credentials.AccessKeyId')
  export AWS_SECRET_ACCESS_KEY=$(echo $SESSION_TOKEN_JSON | jq -r '.Credentials.SecretAccessKey')
  export AWS_SESSION_TOKEN=$(echo $SESSION_TOKEN_JSON | jq -r '.Credentials.SessionToken')
  echo "done."

  echo -n "* Writing ${C_BWHI}${C_BOLD}$TOKEN_FILE${C_REST} ... "
  cat >"$TOKEN_FILE" <<EOF
# SOURCE this file, do not execute it.
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN
export AWS_PROFILE=$AWS_PROFILE
# helper variables
export AWS_TOKEN_VALIDITY=$AWS_TOKEN_VALIDITY
export AWS_MFA_BASE=$AWS_MFA_BASE
EOF
  chmod 600 "$TOKEN_FILE"
  echo "done."

  echo -n "* Creating AWS MFA ${C_BWHI}${C_BOLD}profile '${AWS_PROFILE}'${C_REST} ... "
  # delete old version of profile from credentials file
  SED_MARKER="##- MFA $AWS_PROFILE"
  TMP="$HOME/.aws/credentials"
  touch "$TMP"
  # the only portable way to do things between mac & linux
  # see https://stackoverflow.com/a/4247319
  sed -E -i'.bak' -e "/$SED_MARKER/,/$SED_MARKER/d" "$TMP"
  # delete the backup file
  rm -f "${TMP}.bak"
  # append new credentials
  echo "$SED_MARKER start" >>"$TMP"
  echo "[$AWS_PROFILE]" >>"$TMP"
  echo "aws_access_key_id = $AWS_ACCESS_KEY_ID" >>"$TMP"
  echo "aws_secret_access_key = $AWS_SECRET_ACCESS_KEY" >>"$TMP"
  echo "aws_session_token = $AWS_SESSION_TOKEN" >>"$TMP"
  echo "$SED_MARKER end" >>"$TMP"
  chmod 600 "$TMP"
  echo "done."

  echo "* done."
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    local VALIDITY_STR=$(date --date=@$AWS_TOKEN_VALIDITY '+%Y-%m-%d %H:%M:%S')
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    local VALIDITY_STR=$(/bin/date -r $AWS_TOKEN_VALIDITY '+%Y-%m-%d %H:%M:%S')
  fi
  echo "${DINFO} ${H_GREN}token valid until ${VALIDITY_STR}${C_REST}"
}

# gat = Get Aws sessionToken
gat() {
  for check_cmd in aws jq; do
    if ! type $check_cmd > /dev/null; then
      echo "ERROR: command '$check_cmd' is not installed. Aborting."
      return
    fi
  done
  local FORCE_TOKEN="no"
  local USE_PROFILE

  if [ "$2" = "-f" ]; then
    FORCE_TOKEN="yes"
    USE_PROFILE="$1"
  elif [ "$1" = "-f" ]; then
    FORCE_TOKEN="yes"
    USE_PROFILE="${2:-${AWS_MFA_BASE:-default}}"
  else
    USE_PROFILE="${1:-${AWS_MFA_BASE:-default}}"
  fi
  echo "$DINFO using ${H_GREN}profile '${USE_PROFILE}'${C_REST}"
  TOKEN_FILE="$HOME/.aws/token.$USE_PROFILE.sh"
  # check if we already have a session token active
  if [ "$FORCE_TOKEN" = "yes" ]; then
    echo "$DINFO ${H_REDD}Force-creating${C_REST} new token ..."
    _aws_get_new_token $USE_PROFILE
  else
    _aws_load_token $USE_PROFILE || _aws_get_new_token $USE_PROFILE
  fi
}

# rat = Re-use Aws sessionToken
# same as "gat" now
rat() {
  gat "$@"
}

# ###########################################################################
#
# file operations
#

# add trailing newlines to files of a certain type
# https://unix.stackexchange.com/a/161853
# $@ - the files to add a newline to
addtrailingnewline() {
  for file in "$@"; do
    echo "Checking '$file' ..."
    tail -c1 <"$file" | read -r _ || echo >>"$file"
  done
}

# convert a file to utf8
# $1 - original encoding
# $2... - filename(s)
file2utf8() {
  if [[ -z "$2" || "$1" = "-h" ]]; then
    echo "Convert a file from a given encoding to UTF-8."
    echo "USAGE: file2utf8 FROM_ENCODING FILENAME"
    return
  fi
  FROM_ENC="$1"
  shift
  for convfile in "$@"; do
    if [ ! -f "$convfile" ]; then continue; fi
    echo "Converting: $convfile"
    iconv -f $FROM_ENC -t utf-8 "$convfile" >"$convfile.utf8" &&
      mv -f "$convfile.utf8" "$convfile"
    rm -f "$convfile.utf8"
  done
}

# trim trailing whitespaces in file
# $1 - filename
trim() {
  if [[ -z "$1" || "$1" = "-h" ]]; then
    echo "Trim trailing whitespaces from each line in a file."
    echo "USAGE: trim FILENAME"
    return
  fi
  for trimfile in "$@"; do
    if [ ! -f "$trimfile" ]; then continue; fi
    echo "Trimming: $trimfile"
    sed -Ei 's/^[ \t]+$//;s/[ \t]+$//' "$trimfile"
  done
}

# ############################################################################
#
# brew
#

# brew - m1 vs. x86
ibrew() {
  if [ -x /usr/local/bin/brew ]; then
    /usr/local/bin/brew "$@"
  else
    brew "$@"
  fi
}
