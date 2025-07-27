PATH="$(bash --norc -ec 'IFS=:; paths=($PATH); 
for i in ${!paths[@]}; do 
if [[ ${paths[i]} == "''/Users/ben/.pyenv/shims''" ]]; then unset '\''paths[i]'\''; 
fi; done; 
echo "${paths[*]}"')"
export PATH="/Users/ben/.pyenv/shims:${PATH}"
export PYENV_SHELL=zsh
PYENV_VERSION=$(pyenv --version | cut -d' ' -f2)
source "/opt/homebrew/Cellar/pyenv/$PYENV_VERSION/libexec/../completions/pyenv.zsh"
command pyenv rehash 2>/dev/null
pyenv() {
  local command
  command="${1:-}"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  activate|deactivate|rehash|shell)
    eval "$(pyenv "sh-$command" "$@")"
    ;;
  *)
    command pyenv "$command" "$@"
    ;;
  esac
}

