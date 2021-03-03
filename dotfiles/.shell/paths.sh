## ALL SYSTEMS #############################################


# APPENDED to path
for PATH_SEARCH in \
  "/var/lib/snapd/snap/bin" \
  "/snap/bin" \
  "$HOME/Dev/frameworks/flutter/bin" \
  "$HOME/Dev/frameworks/flutter/.pub-cache/bin" \
  ; do
  if [ -d "$PATH_SEARCH" ]; then
    path=($path "$PATH_SEARCH")
    break
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
    path=("$PATH_SEARCH" $path)
  fi
done
