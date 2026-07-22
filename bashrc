
force_color_prompt=yes
export PATH=$HOME/bin:$HOME/src/git-cinnabar:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.atuin/bin:$PATH
export PATH=$HOME/.mozbuild/arcanist/bin:$HOME/.mozbuild/moz-phab:$PATH

force_color_prompt=yes
if [ "$color_prompt" = yes ]; then
    PS1='\[\e[1;34m\]\w\[\e[0m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

unset color_prompt force_color_prompt



set -o vi

# for running local web server for github pages.
# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"

export EDITOR=nvim
export VISUAL=nvim
