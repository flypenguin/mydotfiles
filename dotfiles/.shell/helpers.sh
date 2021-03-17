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



# ###########################################################################
#
# python
#

# $1 - optional - work on WHAT. default: current path name
wo() { if [ -z "$1" ] ; then workon "$(basename "$PWD")" ; else workon "$1" ; fi }



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



# ###########################################################################
#
# git
#

# gitignore service :)
function giti() { curl -L -s https://www.gitignore.io/api/$@ ;}

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
  if [ "$1" = "install" ] ; then
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
    "$HOME/linuxbrew/bin" \
    "/usr/local/bin" \
    "/opt/homebrew/bin" \
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
