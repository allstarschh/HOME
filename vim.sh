#!/bin/sh

# Vim packages
mkdir -p ~/.vim/pack/plugins/start/
cd ~/.vim/pack/plugins/start/
git clone https://github.com/itchyny/lightline.vim
git clone https://github.com/easymotion/vim-easymotion
git clone https://github.com/bronson/vim-trailing-whitespace
git clone https://github.com/preservim/nerdcommenter.git

mkdir -p ~/.vim/bundle
cd ~/.vim/bundle
#git clone git://github.com/godlygeek/tabular.git
#git clone git://github.com/mkitt/tabline.vim.git

# install vimplug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
