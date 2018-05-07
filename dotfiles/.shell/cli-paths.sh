# $HOME/clis

if [ -d "$HOME/clis" ] ; then
  for p in "$HOME/clis/"* ; do
    [ -d "$p/bin" ] && p="$p/bin"
    path=("$p" "$path[@]")
  done
fi

# snaps :)

for SNAP in "/var/lib/snapd/snap/bin" "/snap/bin" ; do
  if [ -d "$SNAP" ]; then
    path=("$path[@]" "$SNAP")
    break
  fi
done
