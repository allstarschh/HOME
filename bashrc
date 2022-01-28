export PATH=$HOME/bin:$HOME/src/git-cinnabar:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.mozbuild/arcanist/bin:$HOME/.mozbuild/moz-phab:$PATH

source $HOME/.cargo/env
set -o vi

# for running local web server for github pages.
# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"
