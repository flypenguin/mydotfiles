## ALL SYSTEMS #############################################


# $HOME/clis
if [ -d "$HOME/clis" ] ; then
  for p in "$HOME/clis/"* ; do
    [ -d "$p/bin" ] && p="$p/bin"
    path=("$p" $path)
  done
fi

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



## MAC OS ##################################################


# mac os & homebrew - if the coreutils are installed, use them instead of the OS X ones.
# see "brew info coreutils". should not have an effect on linux ;)
# from: https://apple.stackexchange.com/a/371984
find /opt/homebrew /usr/local -type d -name gnubin | while read gnu_dir; do
  path=("$gnu_dir" $path)
  manpath=("${gnu_dir/gnubin/gnuman}" $manpath)
done
