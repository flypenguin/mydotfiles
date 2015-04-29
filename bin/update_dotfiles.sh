#!/usr/bin/env bash

case $1 in
    update-home)
        cd $(dirname $0)
        cd ..
        pwd
        rsync -rl --exclude=".git" ./ $HOME
        cd "$HOME"
        if [ ! -d .oh-my-zsh ]; then
            git clone --depth 1 https://github.com/robbyrussell/oh-my-zsh.git .oh-my-zsh
        fi
        if [ ! -d .solarized ]; then
            git clone https://github.com/seebi/dircolors-solarized.git .solarized
        else
            (cd .solarized && git pull)
        fi
        if [ ! -d .vim/bundle/Vundle.vim ]; then
            mkdir -p .vim/bundle
            git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
        else
            (cd .vim/bundle/Vundle.vim && git pull)
        fi
        ;;
    update-git)
        cd $(dirname $0)
        rsync -rl "$HOME/" ../ --existing --exclude-from="exclude-update-git"
        ;;
    *)
        echo "USAGE: $(basename $0) [update-home|update-git]"
        echo "       update-home: populates the home directory"
        echo "       update-git:  copies changed files back to git repo"
        exit -1
        ;;
esac

