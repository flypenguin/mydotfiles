# unfortunately, the rvm plugin should be loaded here. meh.
# load rvm
if [ -d "$HOME/.rvm" ]; then
    path=("$HOME/.rvm" $path)
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
fi
