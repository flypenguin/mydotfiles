#!/usr/bin/env bash

case $1 in
    git2home)
        cd $(dirname $0)
        cd ..
        pwd
        rsync -rli --exclude=".git" ./ $HOME
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
        if [ -f "$HOME/.ssh/config_base" ] ; then
            touch "$HOME/.ssh/config"
            echo '#BASESTART' > "$HOME/.ssh/config-new"
            cat "$HOME/.ssh/config_base" >> "$HOME/.ssh/config-new"
            echo '#BASEEND' >> "$HOME/.ssh/config-new"
            cat "$HOME/.ssh/config" \
              | sed -r '/#BASESTART/,/#BASEEND/d' \
              >> "$HOME/.ssh/config-new"
            mv -f "$HOME/.ssh/config-new" "$HOME/.ssh/config"
        fi
        ;;
    home2git)
        cd $(dirname $0)
        rsync -rli "$HOME/" ../ --existing --exclude-from="exclude-update-git"
        ;;
    *)
        echo "USAGE: $(basename $0) [update-home|update-git]"
        echo "       git2home: populates the home directory"
        echo "       home2git:  copies changed files back to git repo"
        exit -1
        ;;
esac
