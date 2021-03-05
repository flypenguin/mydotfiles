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
