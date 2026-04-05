# vimlike editors get aliases for vi and view
[[ "$EDITOR" == *vim ]] && {
  alias vi="$EDITOR"
  alias vim="$EDITOR"
  alias view="$EDITOR -R"
  alias vimdiff="$EDITOR -d"
}

# --- ripgrep and fd ----------------------------------------
# ripgrepd-all + follow links
alias rgi='rg -i'
alias rga='rg --follow --hidden --no-ignore'
alias rgai='rg --follow --hidden --no-ignore --ignore-case'

((! $+commands[fd])) && (($+commands[fdfind])) && {
  alias fd=fdfind
}
alias fda='fd --hidden --follow --no-ignore'

# --- git stuff ----------------------------------------
alias gco='git checkout'
alias gcp='git cherry-pick'
alias gcl='git clone'
alias gd='git diff'
alias gf='git fetch'
alias gl='git log'
alias gpf='git pull --ff-only'
alias gpm='git pull --rebase=false'
alias gpr='git pull --rebase=true'
alias gs='git status'
alias gsub-up='git submodule update --init --recursive'

alias gb='git branch'

# alias gbm='git branch '
function gbm {
  local since_br=${1:-main}
  local current_ref=$(git rev-parse --abbrev-ref HEAD)
  local since_ref=$(git merge-base "$since_br" "$current_ref")
  git diff --name-only "$since_ref" "$current_ref"
}

# use uppercase to increase the speedbump to mistakes
alias gP='git push'

alias gr-branch=rebase-since.sh

# cmake
alias cmake-list-targets='cmake --build . --target help'

# XXX: uv helpers temp
alias pydoc='uv run -m pydoc'

