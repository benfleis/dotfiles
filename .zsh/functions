# get list of files in git conflict state
function conflicts {
    git diff --name-only --diff-filter=U --relative $@
}

# get list of files in git updated
function updates {
    git diff --name-only --relative HEAD $@
}

# get original branch base
function branch-base {
    git reflog show --format=format:%h $@ | tail -1
}

# get list of files in git updated since branch creation pt
function branch-updates {
    base=$(branch-base)
    git diff --name-only --relative HEAD..$base
}

# -----------------------------------------------------------------------------

# wipeout all known ssh-agent instances, and attempt to start over
function new-ssh-agent
{
    pkill ssh-agent || killall ssh-agent
    eval `ssh-agent`

    SOCK="/tmp/ssh-$USER/agent"
    ORIG="$SSH_AUTH_SOCK"
    mkdir -pm 0700 "$(dirname $SOCK)"
    ln -sf "$ORIG" "$SOCK"
    export SSH_AUTH_SOCK="$SOCK"
}

##
# like wait, but not required to be own child.  accepts (and passes through)
# args to pgrep
#
function wait_for_all
{
    while pgrep $@ >/dev/null; do
        sleep 1
    done
}

##
# given paths C and N, convert N to path relative to C
#
# from: http://www.zsh.org/mla/users/2002/msg00263.html
#
function relpath {
    emulate -L zsh
    local up=.. down
    # ! -d $up/$down accounts for symlinks in $PWD
    while [[ ${PWD#$1} == $PWD || ! -d $up/$down ]]; do
        up=../$up
        if [[ -n $1:t ]]; then
            down=$1:t${down:+/$down}
            1=$1:h
        fi
    done
    print $up/$down
}


##
# if node_modules/.bin exists, append it to path
#
function add-node-module-bin {
}

# from https://groups.google.com/forum/#!topic/golang-nuts/XPQ51DIYQac
XXXgo() {
    GOCMD=`/usr/bin/which go`
    if [ "$1" == "cd" ]; then
        shift
        cd $( $GOCMD list -f '{{.Dir}}' $@ || echo . )
    elif [ "$1" == "less" ]; then
        shift
        $GOCMD doc $@ | $PAGER
    else
        $GOCMD $@
    fi
}

# args [-q] <HH[:MM[:SS]]> [more days]
sleep-until() {
    local slp tzoff now quiet=false
    [ "$1" = "-q" ] && shift && quiet=true
    local -a hms=(${1//:/ })
    printf -v now '%(%s)T' -1
    printf -v tzoff '%(%z)T\n' $now
    tzoff=$((0${tzoff:0:1}(3600*${tzoff:1:2}+60*${tzoff:3:2})))
    slp=$((
       ( 86400+(now-now%86400) + 10#$hms*3600 + 10#${hms[1]}*60 + 
         ${hms[2]}-tzoff-now ) %86400 + ${2:-0}*86400
    ))
    $quiet || printf 'sleep %ss, -> %(%c)T\n' $slp $((now+slp))
    sleep $slp
}
