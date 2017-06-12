#!/bin/bash

# lsof -nP -i4tcp -s tcp:listen | sort -k1b,9
lsof -nP -i 4tcp -s tcp:listen -F pcfn | while read -r line || [[ -n $line ]]; do
    type=${line::1}
    datum=${line:1}
    case $type in
        p) pid=$datum ;; # pid ALWAYS comes first, afaict
        c) printf "$datum [$pid]:\n" ;;
        f) ;; # NOOP; always included
        n) printf "    $datum\n"; nl=1 ;;
        *) echo "UNKNOWN COMMAND: $type" >&2
    esac
done
