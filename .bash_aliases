# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias fd=fdfind

# mach cmds
alias mb="./mach build"
alias mt="./mach try fuzzy"
alias mf="./mach format"
alias mfh="./mach format -r HEAD"
alias mfh1="./mach format -f HEAD~1"
alias mfh2="./mach format -f HEAD~2"
alias mr="./mach run"
alias mg="./mach gtest"
alias mx="./mach xpcshell-test"
alias mxh="./mach xpcshell-test --headless"
alias mm="./mach mochitest"
alias mmh="./mach mochitest --headless"
alias mji="./mach jit-test"
alias mjs="./mach jstests"
alias mja="./mach jsapi-tests"
alias mw="./mach wpt"
alias mwh="./mach wpt --headless"
alias mrh="./mach reftest --headless"
alias mjh="./mach jstestbrowser --headless --filter"

alias gd="git d"
alias gds="git ds"
alias gau="git au"
alias gcm="git cm"
alias gl="git lg"
alias gcp="git cp"
alias gcb="git cb"
alias gb="git br"
alias gso="git so"
alias gst="git st"
alias grv="git rv"
alias gft="git ft"
alias grb="git rb"

alias rrd="rr record --num-cores=12"
alias rps="rr ps"
alias rry="rr replay"
