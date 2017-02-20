# unfortunately, the rvm plugin should be loaded here. meh.
# load rvm
ttime rvm_0
if [ -d "$HOME/.rvm" ]; then
    path=("$HOME/.rvm" $path)
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
fi
ttime rvm_1
