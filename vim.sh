#!/bin/sh

# Vim packages
mkdir -p ~/.vim/pack/plugins/start/
cd ~/.vim/pack/plugins/start/
git clone https://github.com/itchyny/lightline.vim
git clone git://github.com/jiangmiao/auto-pairs.git
git clone https://github.com/easymotion/vim-easymotion
git clone https://github.com/bronson/vim-trailing-whitespace

mkdir -p ~/.vim/bundle
cd ~/.vim/bundle
git clone git://github.com/godlygeek/tabular.git
git clone git://github.com/mkitt/tabline.vim.git