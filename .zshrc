# zsh init; ben

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

prefer() {
    PREFER=`which $1 2> /dev/null`
    [ $? -eq 0 ] && return 0
    [ $# -eq 2 ] && PREFER=`which $2`
    return 1
}

export PATH HOME TERM
export CVS_RSH=`which ssh`
export RSYNC_RSH=`which ssh`
export HISTSIZE=256
export LESS='-iFMRX'
export EXTENDED_GLOB

prefer less more; export PAGER=$PREFER
prefer vim vi; export EDITOR=$PREFER
prefer nvim $EDITOR; export EDITOR=$PREFER
export VISUAL=$EDITOR

export USERXSESSIONRC=$HOME/.xsession

# aliases
echo $EDITOR | grep -q vim && alias vi="vim"
echo $EDITOR | grep -q vim && alias view="vim -R"

alias webster="ssh monkey.org webster"
alias m=$PAGER
alias psg="ps ax | grep "
alias ip="ipython"
alias tman='tmux_attach_or_new'
alias gx='open -a GitX'

alias nech='nesh -c'

# history mgmt
HISTFILE=~/.zsh/history
SAVEHIST=10000
HISTSIZE=10000
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

##
# some bits stolen from: http://www.aperiodic.net/phil/prompt/prompt.txt
#
autoload colors zsh/terminfo
setopt promptpercent
setopt promptsubst
if [[ "$terminfo[colors]" -ge 8 ]]; then
    colors
fi
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
    eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
    eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
    (( count = $count + 1 ))
done
PR_RESET="%{$terminfo[sgr0]%}"

# export PS1='[%U%m%u] %B%~%b $ '
## preferred prompts; first is for white bg, second is for black bg (iterm)
set_prompt() {
    #export PROMPT='@%(?.$PR_LIGHT_GREEN$PROMPT_AT.$PR_RED$PROMPT_AT)$PR_RESET| $PR_BLUE%~$PR_RESET $ '
    export PROMPT='@$PR_LIGHT_GREEN$PROMPT_AT$PR_RESET%(?-| -|${PR_RED}X${PR_RESET}) $PR_BLUE%~$PR_RESET $ '
}
export PROMPT_AT="%m"
set_prompt

# backup dir for vim
mkdir -p /tmp/.backup

## Lang/Env setups -- eg go, python, SDKMAN, anaconda

# python
# leverage pyenv if installed
command -v pyenv >/dev/null && eval "$(pyenv init -)"

# rust
command -v cargo >/dev/null && PATH="$HOME/.cargo/bin:$PATH"

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

# use zsh-z [ https://github.com/agkozak/zsh-z ]
export ZSHZ_CMD=j
ZSH_Z="$HOME/src/zsh-z/zsh-z.plugin.zsh"
[ -r "$ZSH_Z" ] && . "$ZSH_Z"
zstyle ':completion:*' menu select


# load up all ze functions
[ -r $HOME/.zsh/functions ] && . $HOME/.zsh/functions

# load anything local to this machine
[ -r $HOME/.zsh/rc-local ] && . $HOME/.zsh/rc-local

# load anything local to this machine, by name
machine=$(uname -n | cut -d. -f1)
[ -r $HOME/.zsh/$machine ] && . $HOME/.zsh/$machine || true

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/benfleis/.sdkman"
[[ -s "/home/benfleis/.sdkman/bin/sdkman-init.sh" ]] && source "/home/benfleis/.sdkman/bin/sdkman-init.sh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

