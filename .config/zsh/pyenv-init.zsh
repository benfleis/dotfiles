PATH="$(bash --norc -ec 'IFS=:; paths=($PATH); 
for i in ${!paths[@]}; do 
if [[ ${paths[i]} == "''$HOME/.pyenv/shims''" ]]; then unset '\''paths[i]'\''; 
fi; done; 
echo "${paths[*]}"')"
export PATH="$HOME/.pyenv/shims:${PATH}"
export PYENV_SHELL=zsh
source "$HOME/.pyenv/completions/pyenv.zsh"
command pyenv rehash 2>/dev/null
pyenv() {
  local command=${1:-}
  [ "$#" -gt 0 ] && shift
  case "$command" in
  activate|deactivate|rehash|shell)
    eval "$(pyenv "sh-$command" "$@")"
    ;;
  *)
    command pyenv "$command" "$@"
    ;;
  esac
}

export PATH="$HOME/.pyenv/plugins/pyenv-virtualenv/shims:${PATH}";
export PYENV_VIRTUALENV_INIT=1;
_pyenv_virtualenv_hook() {
  local ret=$?
  if [ -n "${VIRTUAL_ENV-}" ]; then
    eval "$(pyenv sh-activate --quiet || pyenv sh-deactivate --quiet || true)" || true
  else
    eval "$(pyenv sh-activate --quiet || true)" || true
  fi
  return $ret
};
typeset -g -a precmd_functions
if [[ -z $precmd_functions[(r)_pyenv_virtualenv_hook] ]]; then
  precmd_functions=(_pyenv_virtualenv_hook $precmd_functions);
fi
