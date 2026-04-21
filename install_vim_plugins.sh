#!/usr/bin/env bash
# Vim plugin setup

set -euo pipefail

STEP() { echo; echo "==> $*"; }

mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

PLUGINS=(
  https://github.com/itchyny/lightline.vim
  https://github.com/easymotion/vim-easymotion
  https://github.com/bronson/vim-trailing-whitespace
  https://github.com/preservim/nerdcommenter.git
)

STEP "Vim native pack plugins"
mkdir -p ~/.vim/pack/plugins/start
for repo in "${PLUGINS[@]}"; do
  dir=~/.vim/pack/plugins/start/$(basename "$repo" .git)
  if [[ ! -d "$dir" ]]; then
    git clone "$repo" "$dir"
  else
    echo "  already cloned: $dir"
  fi
done

STEP "vim-plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo
echo "==> Done. Run :PlugInstall inside vim to install plug.vim plugins."
