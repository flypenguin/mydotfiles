if [ -d "$HOME/clis" ] ; then
  for p in "$HOME/clis/"* ; do
    [ -d "$p/bin" ] && p="$p/bin"
    path=("$p" "$path[@]")
  done
fi
