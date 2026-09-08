# ZDOTDIR=$HOME/.config/zsh
# . $ZDOTDIR/.zshenv

# Use fixed path for SSH_AUTH_SOCK, bound to the first connection that finds it dead.
# tmux panes and pre-sleep processes hold the fixed path, so rebinding resurrects them.
# ~/.ssh/rc relinks on every ssh connection, including ones that never reach a login
# shell; this is the fallback for logins sshd doesn't run that file for.
# NOTE: If this doesn't suffice, next step: https://github.com/jmmv/ssh-agent-switcher
sock="$HOME/.ssh/ssh_auth_sock"
if [[ -S "$SSH_AUTH_SOCK" && "$SSH_AUTH_SOCK" != "$sock" && ! -S "$sock" ]]; then
    mkdir -pm 0700 "${sock:h}"
    ln -sfn "$SSH_AUTH_SOCK" "$sock"
fi
# Unconditional, even while the link dangles: falling back to the dead per-connection
# path pins the shell to a value no later reconnect can repair.
export SSH_AUTH_SOCK="$sock"
unset sock
