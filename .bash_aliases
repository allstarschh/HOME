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

alias phl="phlay"
alias ph1="phlay HEAD~1..HEAD"
alias ph2="phlay HEAD~2..HEAD"
alias ph3="phlay HEAD~3..HEAD"
alias ph4="phlay HEAD~4..HEAD"
alias ph5="phlay HEAD~5..HEAD"

alias phb="moz-phab"
alias pb1="phb HEAD~1 HEAD"
alias pb2="phb HEAD~2 HEAD"
alias pb3="phb HEAD~3 HEAD"
alias pb4="phb HEAD~4 HEAD"
alias pb5="phb HEAD~5 HEAD"
