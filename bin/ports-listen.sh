#!/bin/bash

set -euo pipefail

if [ -t 1 ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m'
fi

function blue   { printf "${BLUE:-}$@${NC:-}"; }
function yellow { printf "${YELLOW:-}$@${NC:-}"; }

# in bash man page, see ":-word" and ":+word"
# will be "" or ":12345"
port_arg="${1:+":"}${1:-}"

lsof -nP -i "tcp$port_arg" -s tcp:listen -F pcnf | while read -r line || [[ -n $line ]]; do
    type=${line:0:1}
    datum=${line:1}
    case $type in
        p)  # pid ALWAYS comes first, afaict
            pid=$datum
            args=$(ps -p $pid -o args= | cut -b 1-40)
            ;;
        c) printf "$(yellow "$datum") -- $pid -- $(blue "$args")\n" ;;
        n) printf "    $datum\n" ;;
        f) ;; # always emitted, ignore it
        *) echo "UNKNOWN COMMAND: $type" >&2
    esac
done
