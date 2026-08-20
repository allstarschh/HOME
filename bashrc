
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

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac



unset color_prompt force_color_prompt



set -o vi

[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
eval "$(atuin init bash)"

# Shift+Up: like the plain Up-arrow atuin search, but scoped to this shell
# session only (--filter-mode session). Reuses atuin-bind's accept-line machinery.
atuin-bind -m vi-insert  '\e[1;2A' '__atuin_history --shell-up-key-binding --filter-mode session --keymap-mode=vim-insert'
atuin-bind -m vi-command '\e[1;2A' '__atuin_history --shell-up-key-binding --filter-mode session --keymap-mode=vim-normal'


# for running local web server for github pages.
# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"

export EDITOR=nvim
export VISUAL=nvim
