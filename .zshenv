# link a static SSH_AUTH_SOCK to the real thing
if [ ! -z "$SSH_AUTH_SOCK" -a -z "$_SSH_AUTH_SOCK" ]; then
    # make private dir to store it
    SOCK="/tmp/ssh-$USER/agent"

    if [[ `readlink "$SOCK"` = "$SOCK" ]]; then
        echo "Recursive SSH_AUTH_SOCK agent link discovered!  Cleaning up." >&2
        rm -f "$SOCK"
    fi

    # link it
    mkdir -pm 0700 "$(dirname $SOCK)"
    ln -sf "$SSH_AUTH_SOCK" "$SOCK"
    export _SSH_AUTH_SOCK="$SSH_AUTH_SOCK"
    export SSH_AUTH_SOCK="$SOCK"
fi
