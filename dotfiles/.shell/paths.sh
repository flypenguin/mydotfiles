# $HOME/clis

if [ -d "$HOME/clis" ] ; then
  for p in "$HOME/clis/"* ; do
    [ -d "$p/bin" ] && p="$p/bin"
    path=("$p" "$path[@]")
  done
fi

# snaps :)

for PATH_SEARCH in \
  "/var/lib/snapd/snap/bin" \
  "/snap/bin" \
  "$HOME/Dev/frameworks/flutter/bin" \
  "$HOME/Dev/frameworks/flutter/.pub-cache/bin" \
  ; do
  if [ -d "$PATH_SEARCH" ]; then
    path=("$path[@]" "$PATH_SEARCH")
    break
  fi
done
