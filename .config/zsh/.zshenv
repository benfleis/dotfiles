# ZDOTDIR=$HOME/.config/zsh
# . $ZDOTDIR/.zshenv

# link a static SSH_AUTH_SOCK to the real thing
if [ ! -z "$SSH_AUTH_SOCK" -a -z "$_SSH_AUTH_SOCK" ]; then
    # make private dir to store it
    sock="/tmp/ssh-$USER/agent"

    if [[ `readlink "$sock"` = "$sock" ]]; then
        echo "Recursive SSH_AUTH_SOCK agent link discovered!  Cleaning up." >&2
        rm -f "$sock"
    fi

    # link it
    mkdir -pm 0700 "$(dirname $sock)"
    ln -sf "$SSH_AUTH_SOCK" "$sock"
    export _SSH_AUTH_SOCK="$SSH_AUTH_SOCK"
    export SSH_AUTH_SOCK="$sock"
fi

. "$HOME/.cargo/env"
