# babashka bbin
[[ -n "$XDG_DATA_HOME" ]] && command -v bbin >/dev/null && {
    export BABASHKA_BBIN_FLAG_XDG=true
    export PATH="$XDG_BIN_HOME:$PATH"
}


