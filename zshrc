# zsh init; ben

PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin

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
export VISUAL=$EDITOR

export USERXSESSIONRC=$HOME/.xsession

# aliases
prefer vim && alias vi="vim"
prefer vim && alias view="vim -R"

alias webster="ssh monkey.org webster"
alias m=$PAGER
alias psg="ps ax | grep "
alias ip="ipython"

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

autoload -U compinit
compinit -u

autoload zmv

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

bindkey -a "Q" push-line

# ulimits
ulimit -c unlimited
ulimit -d unlimited
ulimit -s unlimited

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
PR_NO_COLOUR="%{$terminfo[sgr0]%}"

# export PS1='[%U%m%u] %B%~%b $ '
## preferred prompts; first is for white bg, second is for black bg (iterm)
export PROMPT='[%(?.$PR_LIGHT_GREEN%m.$PR_RED%m)$PR_NO_COLOUR] $PR_LIGHT_GREEN%~$PR_NO_COLOUR $ '
#export PROMPT='[%(?.$PR_LIGHT_GREEN%m.$PR_RED%m)$PR_NO_COLOUR] $PR_LIGHT_BLUE%~$PR_NO_COLOUR $ '
#export PROMPT='[%(?.$PR_GREEN%m.$PR_RED%m)$PR_WHITE] $PR_BLUE%~$PR_NO_COLOUR $ '

# backup dir for vim
mkdir -p /tmp/.backup

# load up all ze functions
[ -r $HOME/.zsh/functions ] && . $HOME/.zsh/functions

# load anything local to this machine
[ -r $HOME/.zsh/local ] && . $HOME/.zsh/local

# load anything local to this machine, by name
machine=$(uname -n | cut -d. -f1)
[ -r $HOME/.zsh/$machine ] && . $HOME/.zsh/$machine || true
