# zsh init; ben
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export PATH HOME TERM
export RSYNC_RSH=`which ssh`
export LESS='-iFMRX'
export EXTENDED_GLOB

export XDG_CONFIG_HOME=$HOME/.config

alias ip="ipython"
alias zi="$HOME/bin/tmux-zoom in"
alias zo="$HOME/bin/tmux-zoom out"

# history mgmt
HISTFILE=~/.zsh/history
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

# Each matching set is tried in order, which means: first try direct match,
# then try case insensitive + . -> small subset, then casei + . -> anything
zstyle ':completion:*' matcher-list \
    '' \
    'm:{a-zA-Z}={A-Za-z} m:.=[.,_ -]' \
    'm:{a-zA-Z}={A-Za-z} m:.=?' \
    'm:{a-zA-Z}={A-Za-z} m:.=? r:|[.,_-]=* r:|=*'
    #
    # NOTE: 'r:|[.,_-]=* r:|=*' by itself does very.c -> veryverylong.c, but
    # also has odd '....' behavior that i dislike.
    #

# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o'

zstyle ':completion:*:vi:*' ignored-patterns '*.(o|a|so|aux|dvi|log|swp|fig|bbl|blg|bst|idx|ind|out|toc|class|pdf|ps|pyc|pyo)'
zstyle ':completion:*:vim:*' ignored-patterns '*.(o|a|so|aux|dvi|log|swp|fig|bbl|blg|bst|idx|ind|out|toc|class|pdf|ps|pyc|pyo)'
zstyle ':completion:*:gvim:*' ignored-patterns '*.(o|a|so|aux|dvi|log|swp|fig|bbl|blg|bst|idx|ind|out|toc|class|pdf|ps|pyc|pyo)'

# http://www.linux-mag.com/id/1106
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

export _compdir=$HOME/.zsh/completion
autoload -U compinit
compinit -u

autoload zmv

autoload edit-command-line
bindkey -M vicmd V edit-command-line

# theoretical preexec sweetness.  no worky, but worth checking later.
# http://forums.macosxhints.com/archive/index.php/t-6493.html
#preexec ()
#{
#    print -Pn "\e]0;%n@%m < %20>...>$1%<< > (%y)\a"
#}

# other options
setopt autocd nobeep
setopt extendedglob
umask 022

# special key bindings
bindkey -v
bindkey "\M-b" vi-backward-word
bindkey "\M-f" vi-forward-word
bindkey "\M-d" kill-word
bindkey "^P" history-beginning-search-backward
bindkey "^N" history-beginning-search-forward
bindkey "^[^M" self-insert-unmeta


# XXX need to figure out how avail history-search-end to the zsh here.
#zle -N history-beginning-search-backward-end history-search-end
#zle -N history-beginning-search-forward-end history-search-end
#bindkey '^P' history-beginning-search-backward-end
#bindkey '^N' history-beginning-search-forward-end

bindkey -a "Q" push-input

# ulimits
ulimit -c unlimited
ulimit -d unlimited
ulimit -s unlimited
ulimit -n 8192

# backup dir for vim
mkdir -p /tmp/.backup

# load ZIM before local stuff
export ZIM_HOME=$HOME/.cache/zim
if [[ ! -r $ZIM_HOME/zimfw.zsh ]]; then
    mkdir -p $ZIM_HOME ;
    ln -s $HOME/src/zimfw/zimfw.zsh $ZIM_HOME ;
fi
[[ -r $ZIM_HOME/zimfw.zsh ]] || unset ZIM_HOME

if [[ -n "$ZIM_HOME" ]]; then
    # Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
    if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
        source ${ZIM_HOME}/zimfw.zsh init -q
    fi
    source ${ZIM_HOME}/init.zsh
fi


# load anything local to this machine
[ -r $HOME/.zsh/rc-local ] && . $HOME/.zsh/rc-local

# load anything local to this machine, by name
machine=$(uname -n | cut -d. -f1)
[ -r $HOME/.zsh/$machine ] && . $HOME/.zsh/$machine || true

## Lang/Tool/Env setups -- eg go, python, SDKMAN, anaconda

# python / pyenv
# leverage pyenv if installed
[[ -x $HOME/.pyenv/bin ]] && export PATH="$HOME/.pyenv/bin:$PATH"
if ( command -v pyenv >/dev/null ); then
    source $HOME/.zsh/pyenv-init.zsh
    export PATH="$HOME/.pyenv/shims:$PATH"
fi

# rust / rustup
[[ -x $HOME/.cargo/bin ]] && PATH="$HOME/.cargo/bin:$PATH"
[[ -r "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# haskell cabal
[[ -x $HOME/.cabal/bin ]] && PATH="$HOME/.cabal/bin:$PATH"
[[ -r "$HOME/.cabal/env" ]] && . "$HOME/.cabal/env"

# go, presumed to be installed via brew
if command -v gofmt >/dev/null; then
    export GOPATH="$HOME/go"
    export PATH="$GOPATH/bin:$PATH"
fi

# get JAVA_HOME as right as possible
# use javac instead of java, since using java can get stuck under jre path
# instead of main (for header/includes)
uname -a | grep -q Linux && {
    export JAVA_HOME=$(update-alternatives --query javac | sed -n 's#^Value: \(.*\)/bin/javac$#\1#p') ;
}

#   # use zsh-z [ https://github.com/agkozak/zsh-z ]
#   export ZSHZ_CASE=ignore
#   export ZSHZ_CMD=j
#   export ZSHZ_NO_RESOLVE_SYMLINKS=1
#   ZSH_Z="$HOME/src/zsh-z/zsh-z.plugin.zsh"
#   [ -r "$ZSH_Z" ] && . "$ZSH_Z"
#   zstyle ':completion:*' menu select
#   alias jc="j -c"

#   # use z [ https://github.com/agkozak/zsh-z ], to also use fz
#   export _Z_CASE=ignore
#   export _Z_CMD=_j
#   export _Z_NO_RESOLVE_SYMLINKS=1
#   Z_SRC="$HOME/src/z/z.sh"
#   [ -r "$Z_SRC" ] && . "$Z_SRC"
#   zstyle ':completion:*' menu select
#   # alias jc="j -c"

zstyle ':completion:*' menu select

# init fzf first, so z.lua && fz see it

# Preview file content using bat (https://github.com/sharkdp/fd)
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# CTRL-/ to toggle small preview window to see the full command
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

# Print tree structure in the preview window
export FZF_ALT_C_OPTS="--preview 'tree -C -L 2 {}'"
export FZF_COMPLETION_TRIGGER=',,'

[[ -r ~/.fzf.zsh ]] && source ~/.fzf.zsh

# use z.lua [ https://github.com/skywind3000/z.lua ], to also use fz
export _ZL_CMD=j
export _ZL_DATA=$HOME/.z
export _ZL_CASE=ignore
export _ZL_HYPHEN=1
export _ZL_NO_RESOLVE_SYMLINKS=1
ZL_SRC="$HOME/src/z.lua/z.lua"
[[ -r "$ZL_SRC" ]] && eval "$(lua $ZL_SRC --init zsh)"

# fz [ https://github.com/changyuheng/fz.sh ]
export FZ_CMD=jj
export FZ_SUBDIR_CMD=j
export FZ_HISTORY_CD_CMD=_zlua
FZ_SRC="$HOME/src/fz.sh/fz.plugin.zsh"
[[ -r "$FZ_SRC" ]] && source "$FZ_SRC"

# load up all ze functions
[[ -r $HOME/.zsh/functions ]] && . $HOME/.zsh/functions


# always $HOME/bin atop path
export PATH="$HOME/bin:$PATH"

# -U uniqifies, keeping first entry
typeset -U path


## EDITOR and related prefs, need to be after PATH setup
prefer() {
    PREFER=`which $1 2> /dev/null`
    [ $? -eq 0 ] && return 0
    [ $# -eq 2 ] && PREFER=`which $2`
    return 1
}

prefer less more; export PAGER=$PREFER
prefer vim vi; export EDITOR=$PREFER
prefer nvim $EDITOR; export EDITOR=$PREFER
export VISUAL=$EDITOR

[[ "$EDITOR" == */nvim ]] && \
    export MANPAGER='nvim +Man!'

# aliases -- vimlike editors get aliases for vi and view
echo $EDITOR | grep -q vim && alias vi="$EDITOR"
echo $EDITOR | grep -q vim && alias view="$EDITOR -R"
echo $EDITOR | grep -q vim && alias vimdiff="$EDITOR -d"

# XXX hacky prompt update
_ps1="$PS1"
_rps1="$RPS1"
unset RPS1
export PROMPT_AT=${PROMPT_AT:-$(hostname -s)}
export PS1="[%F{white}%*·${PROMPT_AT}%f $_rps1]"$'\n'"$_ps1"
