## ALL SYSTEMS #############################################


# $HOME/clis
if [ -d "$HOME/clis" ] ; then
  for p in "$HOME/clis/"* ; do
    [ -d "$p/bin" ] && p="$p/bin"
    path=("$p" $path)
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
    path=($path "$PATH_SEARCH")
    break
  fi
done




## LINUX ###################################################


# linux homebrew (yes, this is a thing ;) path settings
# should not have an effect on mac.
[ -d $HOME/.linuxbrew ] && path=("$HOME/.linuxbrew/bin" $path)




## MAC OS ##################################################


# mac os & homebrew - if the coreutils are installed, use them instead of the OS X ones.
# see "brew info coreutils". should not have an effect on linux ;)
# from: https://apple.stackexchange.com/a/371984
for gnu_dir in /usr/local/opt/*/libexec/gnubin; do
  path=("$gnu_dir" $path)
  manpath=("${gnu_dir/gnubin/gnuman}" $manpath)
done
