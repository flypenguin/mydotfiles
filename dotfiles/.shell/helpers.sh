# ###########################################################################
#
# configure generic helpers
#

# jump (autojump seems dead) - don't forget QUOTING!! :)
whence jump >/dev/null 2>&1 && eval "$(jump shell zsh)"

# direnv - https://direnv.net/
whence direnv > /dev/null 2>&1 && eval "$(direnv hook zsh)"

# nvm - the Node Version Manager
# use the oh-my-zsh "nvm" plugin for "stupid" initialization, or use lazy loading here.

# zsh syntax highlighting
# from arch :)
local SCRIPT="/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[ -f "$SCRIPT" ] && source "$SCRIPT"

# this is intended for zsh & bash, even if it's called "bash"
if [ -f "$HOME/.config/broot/launcher/bash/br" ] ; then
  source "$HOME/.config/broot/launcher/bash/br"
fi


# ###########################################################################
#
# python
#

# $1 - optional - work on WHAT. default: current path name
wo() { if [ -z "$1" ] ; then workon "$(basename "$PWD")" ; else workon "$1" ; fi }

# $1 - (OPTIONAL) name of virtual environment
cvi() {
  local ENVNAME=${1:-$(basename $PWD)}
  mkvirtualenv -p $(which python3) "$ENVNAME"
}

# $1 - (OPTIONAL) name of virtual environment
cvv() {
  local ENVNAME=${1:-$(basename $PWD)}
  python3 -m venv --prompt "$ENVNAME" .venv
  # mimic 'mkvirtualenv' behavior and activate automatically
  source .venv/bin/activate
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

# $1 = name of the identity file
# $@ = ssh parameters
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

# create hash for ssh (public) keys, mainly for AWS
# see here: https://serverfault.com/a/603983, https://is.gd/OURGbO
ssh-key-hash() {
  if [ -z "$1" ]; then
    echo "USAGE: ssh-key-hash (PUB_)KEY_FILE"
    return
  fi
  if grep -q "OPENSSH PRIVATE KEY" "$1" ; then
    echo "ERROR: OPENSSH PRIVATE KEYs are not supported (yet)."
    echo "To convert the file IN PLACE to openSSL RSA format, use the command below."
    echo "AGAIN: this WILL CHANGE the saved file!"
    echo ""
    echo "    ssh-keygen -pN \"\" -m pem -f \"$1\""
    echo ""
  elif grep -q "RSA PRIVATE KEY" "$1" ; then
    # we have a private key :)
    echo "Found RSA private key."

    echo -n "PUBkey  MD5  openssl:     "
    openssl pkey -in "$1" -pubout -outform DER | openssl md5 -c \
      | grep --color=never -Eo '(([a-z0-9]{2}:)+[a-z0-9]{2})'

    echo -n "PRIVkey SHA1 openssl:     "
    openssl pkcs8 -in "$1" -inform PEM -outform DER -topk8 -nocrypt \
      | openssl sha1 -c 2>/dev/null \
      | grep --color=never -Eo '(([a-z0-9]{2}:)+[a-z0-9]{2})'

    echo -n "PRIVkey MD5 openssl:      "
    openssl rsa -in "$1" -pubout -outform DER \
      | openssl md5 -c \
      | grep --color=never -Eo '(([a-z0-9]{2}:)+[a-z0-9]{2})'
  else
    # we have a public key
    echo -n "PUBkey MD5 AWS hash (AWS):   "
    ssh-keygen -f "$1" -e -m PKCS8 \
      | openssl pkey -pubin -outform DER \
      | openssl md5 -c
    echo -n "PUBkey MD5 ssh-keygen hash:  "
    ssh-keygen -E md5 -lf "$1" | grep --color=never -Eo '(([a-z0-9]{2}:)+[a-z0-9]{2})'
  fi
}

# let's alias those
alias aws-ssh-fingerprint=ssh-key-hash
alias ssh-aws-fingerprint=ssh-key-hash
alias aws-fp=ssh-key-hash




# ###########################################################################
#
# git
#

# gitignore service :)
function giti() { curl -L -s https://www.gitignore.io/api/$@ ;}



# ###########################################################################
#
# AWS
#

# gat = Get Aws sessionToken
gat() {
  local TOKEN_DURATION=28800 # 8h

  # save existing AWS_* env vars
  local APRO_BACKUP
  local AKID_BACKUP
  local ASAK_BACKUP
  local ASET_BACKUP
  APRO_BACKUP=$AWS_PROFILE
  AKID_BACKUP=$AWS_ACCESS_KEY_ID
  ASAK_BACKUP=$AWS_SECRET_ACCESS_KEY
  ASET_BACKUP=$AWS_SESSION_TOKEN

  # check if we already have a session token active
  if [ -n "$AWS_SESSION_TOKEN" ] ; then
    if [ "$1" != "-f" ] ; then
      echo "Seems we are already using a session token, use -f to override."
      return
    else
      echo "Session token found, but '-f' set; proceeding."
    fi
  fi

  echo -n "AWS profile to use (ENTER for none): "
  read AWS_PROFILE
  if [ -z "$AWS_PROFILE" ] ; then
    echo "Not using specific AWS profile."
    unset AWS_PROFILE
  else
    echo "Using AWS profile '$AWS_PROFILE'"
    export AWS_PROFILE
  fi

  echo -n "Enter MFA token value (ENTER to abort): "
  read MFA_TOKEN
  if [ -z "$MFA_TOKEN" ] ; then
    echo "Abort."
    return
  fi

  # clean env variables, but only if a session token is active
  if [ -n "$AWS_SESSION_TOKEN" ] ; then
    echo "Cleaning existing ENV vars (already have a session token)"
    unset AWS_SESSION_TOKEN
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
  fi

  echo -n "Getting MFA ARN ... "
  MFA_ARN=$(aws iam list-mfa-devices | jq -r '.MFADevices[0].SerialNumber')
  if [ "$?" != "0" ] ; then
    echo "ERROR: something failed getting the session token."
    export AWS_PROFILE=$APRO_BACKUP
    export AWS_ACCESS_KEY_ID=$AKID_BACKUP
    export AWS_SECRET_ACCESS_KEY=$ASAK_BACKUP
    export AWS_SESSION_TOKEN=$ASET_BACKUP
    return
  fi
  echo $MFA_ARN

  echo -n "Getting session token ... "
  SESSION_TOKEN_JSON=$(aws sts get-session-token --serial-number $MFA_ARN --token-code $MFA_TOKEN --duration-seconds $TOKEN_DURATION)
  if [ "$?" != "0" ] ; then
    echo "ERROR: something failed getting the session token."
    export AWS_PROFILE=$APRO_BACKUP
    export AWS_ACCESS_KEY_ID=$AKID_BACKUP
    export AWS_SECRET_ACCESS_KEY=$ASAK_BACKUP
    export AWS_SESSION_TOKEN=$ASET_BACKUP
    return
  else
    echo "done."
  fi

  echo "Setting env variables:"
  export AWS_ACCESS_KEY_ID=$(echo $SESSION_TOKEN_JSON | jq -r '.Credentials.AccessKeyId')
  echo "  * (set) AWS_ACCESS_KEY_ID"
  export AWS_SECRET_ACCESS_KEY=$(echo $SESSION_TOKEN_JSON | jq -r '.Credentials.SecretAccessKey')
  echo "  * (set) AWS_SECRET_ACCESS_KEY"
  export AWS_SESSION_TOKEN=$(echo $SESSION_TOKEN_JSON | jq -r '.Credentials.SessionToken')
  echo "  * (set) AWS_ACCESS_KEY_ID"
  # just to be sure
  unset AWS_PROFILE
  echo "  * (*un*set) AWS_PROFILE"
  echo "... done.\n\nYou should be all set now."
}



# ###########################################################################
#
# file operations
#

# add trailing newlines to files of a certain type
# https://unix.stackexchange.com/a/161853
# $@ - the files to add a newline to
addtrailingnewline() {
  for file in "$@" ; do
    echo "Checking '$file' ..."
    tail -c1 < "$file" | read -r _ || echo >> "$file"
  done
}


# convert a file to utf8
# $1 - original encoding
# $2... - filename(s)
file2utf8() {
  if [[ -z "$2" || "$1" = "-h" ]] ; then
    echo "Convert a file from a given encoding to UTF-8."
    echo "USAGE: file2utf8 FROM_ENCODING FILENAME"
    return
  fi
  FROM_ENC="$1"
  shift
  for convfile in "$@" ; do
    if [ ! -f "$convfile" ] ; then continue ; fi
    echo "Converting: $convfile"
    iconv -f $FROM_ENC -t utf-8 "$convfile" > "$convfile.utf8" \
      && mv -f "$convfile.utf8" "$convfile"
    rm -f "$convfile.utf8"
  done
}

# trim trailing whitespaces in file
# $1 - filename
trim() {
  if [[ -z "$1" || "$1" = "-h" ]] ; then
    echo "Trim trailing whitespaces from each line in a file."
    echo "USAGE: trim FILENAME"
    return
  fi
  for trimfile in "$@" ; do
    if [ ! -f "$trimfile" ] ; then continue ; fi
    echo "Trimming: $trimfile"
    sed -Ei 's/^[ \t]+$//;s/[ \t]+$//' "$trimfile"
  done
}



# ############################################################################
#
# brew
#

# update dynamic paths after brew operations ...
brew() {
  command brew "$@"
  RES=$?
  if [ "$1" = "install" -a "$RES" = "0" ] ; then
    update_dynamic_paths
  fi
}

# brew - m1 vs. x86
ibrew() {
  if [ -x /usr/local/bin/brew ] ; then
    /usr/local/bin/brew "$@"
  else
    brew "$@"
  fi
}



# ###########################################################################
#
# path helpers
#

# mac os & homebrew - if the coreutils are installed, use them instead of the OS X ones.
# see "brew info coreutils". should not have an effect on linux ;)
# from: https://apple.stackexchange.com/a/371984
update_dynamic_paths() {
  local DYNPATH="$HOME/.shell/dynamic-paths.sh"
  echo "Purging $DYNPATH"
  echo "# Last update: $(date +%Y-%m-%d\ %H:%M:%S)" > "$DYNPATH"

  if [[ "$UNAME" = "Darwin" ]] ; then
    for a in \
      /opt/homebrew \
      /usr/local \
    ; do
      if [[ -d "$a" ]] ; then
        find "$a" -type d -name gnubin | while read gnu_dir; do
          echo "Adding bin dir: $gnu_dir"
          echo "   path=(\"$gnu_dir\" \$path)"                       >> "$DYNPATH"
          local MANPATH=${gnu_dir//gnubin/gnuman}
          echo "Adding man dir: $MANPATH"
          echo "manpath=(\"${gnu_dir//gnubin/gnuman}\" \$manpath)"   >> "$DYNPATH"
        done
      fi
    done
  else
    echo "Skipping homebrew path search (not on Mac)."
  fi

  # APPENDED to path
  for PATH_SEARCH in \
    "/var/lib/snapd/snap/bin" \
    "/snap/bin" \
    "$HOME/Dev/frameworks/flutter/bin" \
    "$HOME/Dev/frameworks/flutter/.pub-cache/bin" \
  ; do
    if [ -d "$PATH_SEARCH" ]; then
      echo "APpending path: $PATH_SEARCH"
      echo "path=(\$path \"$PATH_SEARCH\")" >> "$DYNPATH"
    fi
  done

  # PREpended to path (java - on mac ...)
  # later = higher preference
  for PATH_SEARCH in \
    "/usr/local/opt/openjdk/bin" \
  ; do
    if [ -d "$PATH_SEARCH" ]; then
      echo "PREpending path: $PATH_SEARCH"
      echo "path=(\"$PATH_SEARCH\" \$path)" >> "$DYNPATH"
    fi
  done

  # special keg-only-treatment
  local CHECK_PATH=""
  local CHECK_PATH_LIST="/usr/local/opt"
  for PATH_SEARCH in \
    "curl" \
  ; do
    for CHECK_PATH in $CHECK_PATH_LIST ; do
      CHECK_PATH="$CHECK_PATH/$PATH_SEARCH/bin"
      if [ -d "$CHECK_PATH" ]; then
        echo "adding keg-only binary: $PATH_SEARCH"
        echo "path=(\"$CHECK_PATH\" \$path)" >> "$DYNPATH"
      fi
    done
  done
}
