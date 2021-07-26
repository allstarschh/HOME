#!/bin/sh

# Vim packages
mkdir -p ~/.vim/pack/plugins/start/
git clone https://github.com/itchyny/lightline.vim ~/.vim/pack/plugins/start/
git clone git://github.com/jiangmiao/auto-pairs.git ~/.vim/pack/plugins/start/

mkdir -p ~/.vim/bundle
cd ~/.vim/bundle
git clone git://github.com/godlygeek/tabular.git
git clone git://github.com/mkitt/tabline.vim.git
