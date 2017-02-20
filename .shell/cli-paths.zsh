ttime cli_paths_0
if [ -d "$HOME/clis" ] ; then
  for p in "$HOME/clis/"* ; do
    [ -d "$p/bin" ] && p="$p/bin"
    path+=($p)
  done
fi
ttime cli_paths_1
