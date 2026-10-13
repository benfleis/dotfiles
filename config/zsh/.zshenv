# ZDOTDIR=$HOME/.config/zsh
# . $ZDOTDIR/.zshenv

# Fixed path for SSH_AUTH_SOCK, rebound to a live agent socket on every zsh. fpath and
# the call live here, not .zshrc: `ssh host cmd` and `ssh -t tmux attach` read only this.
# NOTE: If this doesn't suffice, next step: https://github.com/jmmv/ssh-agent-switcher
typeset -U fpath
fpath=( "${ZDOTDIR:-$HOME/.config/zsh}/functions" $fpath )
autoload -Uz fix-ssh-agent _ssh_agent_alive
# fix-ssh-agent -q

[[ -f "$ZDOTDIR/env-local.zsh" ]] && . "$ZDOTDIR/env-local.zsh"
