# unfortunately, the rvm plugin should be loaded here. meh.
# load rvm
if [ -d "$HOME/.rvm" ]; then
    # this is a WEIRD zgen workaround, at least on Mac. super weird.
    # it does actually seem that the PATH variable is unset here.
    # WTF??
    BPATH=$PATH
    export PATH="/usr/local/bin:/usr/bin:/bin"
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
    export PATH="$BPATH"
fi
