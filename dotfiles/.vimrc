" you have to intall vundle first.
" see here:   http://bit.ly/1tDs7nR
" $> git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" DEFINE ALL PLUGINS AFTER THIS LINE

Plugin 'bling/vim-airline'
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-fugitive'
Plugin 'easymotion/vim-easymotion'

" DEFINE ALL PLUGINS BEFORE THIS LINE
call vundle#end()            " required
filetype plugin indent on    " required


" now my personal settings.

syntax on
filetype plugin indent on

" set search highlighting on, but use ENTER in normal mode to clear
" http://is.gd/lUkBFh
set hlsearch
nnoremap <CR> :noh<CR><CR>

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

set wildmode=longest,list
set wildmenu


"
" PLUGIN CONFIGURATIONS
"

" ctrlp, from https://github.com/kien/ctrlp.vim
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_user_command = 'find %s -type f'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

