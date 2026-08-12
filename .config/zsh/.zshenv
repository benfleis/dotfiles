# ZDOTDIR=$HOME/.config/zsh
# . $ZDOTDIR/.zshenv

# Fixed path for SSH_AUTH_SOCK, repointed at each connection's real agent socket:
# tmux panes and pre-sleep processes hold the fixed path, so relinking resurrects them.
sock="$HOME/.ssh/ssh_auth_sock"
if [[ -S "$SSH_AUTH_SOCK" && "$SSH_AUTH_SOCK" != "$sock" ]]; then
    mkdir -pm 0700 "${sock:h}"
    ln -sfn "$SSH_AUTH_SOCK" "$sock"
fi
# Unconditional, even while the link dangles: falling back to the dead per-connection
# path pins the shell to a value no later reconnect can repair.
export SSH_AUTH_SOCK="$sock"
unset sock
