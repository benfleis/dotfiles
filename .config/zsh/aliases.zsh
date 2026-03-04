# vimlike editors get aliases for vi and view
[[ "$EDITOR" == *vim ]] && {
  alias vi="$EDITOR"
  alias vim="$EDITOR"
  alias view="$EDITOR -R"
  alias vimdiff="$EDITOR -d"
}

# ripgrepd-all + follow links
alias rgi='rg -i'
alias rga='rg --follow --hidden --no-ignore'
alias rgai='rg --follow --hidden --no-ignore --ignore-case'

((! $+commands[fd])) && ((! $+commands[fdfind])) && {
  alias fd=fdfind
}
alias fda='fd --hidden --follow --no-ignore'

# git stuff
alias gco='git checkout'
alias gcl='git clone'
alias gd='git diff'
alias gl='git log'
alias gpf='git pull --ff-only'
alias gpm='git pull --rebase=false'
alias gpr='git pull --rebase=true'
alias gs='git status'

alias gP='git push'

alias gr-branch=rebase-since.sh

# cmake
alias cmake-list-targets='cmake --build . --target help'
