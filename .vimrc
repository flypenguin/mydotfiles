" you have to intall vundle first.
" see here:   http://bit.ly/1tDs7nR
" $> git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" DEFINE ALL PLUGINS AFTER THIS LINE

" DEFINE ALL PLUGINS BEFORE THIS LINE
call vundle#end()            " required
filetype plugin indent on    " required


" now my personal settings.

set backspace=indent,eol,start
set number
set expandtab
set sw=2
set sts=2
set ffs=unix

set showmatch
set noerrorbells
set laststatus=2
set vb t_vb=
set ruler


if has("mouse")
    set mouse=a
    set mousehide
endif

set wildmode=longest,list
set wildmenu

