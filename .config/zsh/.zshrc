# zsh init; ben
umask 022

# ulimits
ulimit -c unlimited
ulimit -d unlimited
ulimit -s unlimited
ulimit -n 8192

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export PATH HOME TERM
export LESS='-iFMRX'
export EXTENDED_GLOB

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_BIN_HOME="$HOME/.local/bin" # non standard?
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_DIRS="/opt/homebrew/share"

# assert setup is good 
[[ -z "$ZDOTDIR" ]] && {
  echo "\$ZDOTDIR unset! Using \$HOME/.zsh ; zsh loading may fail." >&2
  echo >&2
  ZDOTDIR="$HOME/.zsh"
}

# TODO: figure this out
fpath=( "${ZDOTDIR}/completions" "${ZDOTDIR}/functions" "${fpath[@]}" )
(($+commands[brew])) && {
  fpath=( $(brew --prefix)/share/zsh-completions "${fpath[@]}" )
}
autoload -Uz compinit
compinit
# TODO check .zcompdump?
# autoload -Uz "${ZDOTDIR}/functions/"**
# functions.zsh

_ZSTATE="$XDG_STATE_HOME/zsh"
mkdir -p "$_ZSTATE"

# history mgmt
HISTFILE=${_ZSTATE}/history
SAVEHIST=100000
HISTSIZE=100000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt HIST_VERIFY
setopt EXTENDED_HISTORY

setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

# other options
setopt autocd
setopt nobeep
setopt extendedglob

zstyle ':completion:*:vi:*' ignored-patterns '*.(o|a|so|aux|dvi|log|swp|fig|bbl|blg|bst|idx|ind|out|toc|class|pdf|ps|pyc|pyo)'
zstyle ':completion:*:vim:*' ignored-patterns '*.(o|a|so|aux|dvi|log|swp|fig|bbl|blg|bst|idx|ind|out|toc|class|pdf|ps|pyc|pyo)'
zstyle ':completion:*:nvim:*' ignored-patterns '*.(o|a|so|aux|dvi|log|swp|fig|bbl|blg|bst|idx|ind|out|toc|class|pdf|ps|pyc|pyo)'

# Case-insensitive matches and "segment" matching across separators [._- ]
zstyle ':completion:*' matcher-list \
  'm:{a-z}={A-Z}' \
  'l:|[._ -]=** r:|[._ -]=**'

export _compdir=$ZDOTDIR/completions
autoload -U compinit
autoload zmv
autoload edit-command-line

# special key bindings
bindkey -v
bindkey -M vicmd V edit-command-line
bindkey "\M-b" vi-backward-word
bindkey "\M-f" vi-forward-word
bindkey "\M-d" kill-word
bindkey "^P" history-beginning-search-backward
bindkey "^N" history-beginning-search-forward
bindkey "^[^M" self-insert-unmeta

bindkey -a "Q" push-input

# always $HOME/bin atop path
# -U uniqifies, keeping first entry
export PATH="$HOME/bin:$PATH"
typeset -U path

# load RC local to this machine from both .config (in git) and .local/state (e.g. secrets)
machine=$(uname -n | cut -d. -f1)
[[ -r $ZDOTDIR/by-machine/zshrc-$machine.zsh ]] && . $ZDOTDIR/by-machine/zshrc-$machine.zsh
[[ -r $_ZSTATE/by-machine/zshrc-$machine.zsh ]] && . $_ZSTATE/by-machine/zshrc-$machine.zsh

# and source "topics" by name; use classic '/etc/fooconf.d' style inside
for rc in $ZDOTDIR/by-name/*; do 
  source "$rc"
done

## EDITOR and related prefs, need to be after PATH setup
prefer() {
  while true; do
    (($+commands[$1])) && {
      echo "$1"
      return 0
    }
    shift
  done
  return 1
}

 export PAGER=$(prefer less more)
 export EDITOR=$(prefer nvim vim vi)
 export VISUAL=$EDITOR

[[ "$EDITOR" == */nvim ]] && {
    export MANPAGER='nvim +Man!'
}

. $ZDOTDIR/aliases.zsh

# TODO: make these autoload functions
. $ZDOTDIR/prompts.zsh
use_prompt_basic
