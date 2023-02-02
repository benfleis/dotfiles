_pyenv_base="/opt/homebrew/Cellar/pyenv/"
_pyenv_version="$(ls -1d $_pyenv_base/*.*.*)"
_pyenv_count=$(echo $_pyenv_version | wc -l | xargs) # xargs is quick and dirty space trimmer

if [[ "$_pyenv_count" = 0 ]]; then
    # echo "pyenv not found" >&2
elif [[ "$_pyenv_count" -gt 1 ]]; then
    echo "multiple pyenv versions found, see $_pyenv_base" >&1
else
    export PYENV_SHELL=zsh
    source "$_pyenv_version/libexec/../completions/pyenv.zsh"
    command pyenv rehash 2>/dev/null

    pyenv() {
        local command
        command="${1:-}"
        if [ "$#" -gt 0 ]; then
            shift
        fi

        case "$command" in
        rehash|shell)
            eval "$(pyenv "sh-$command" "$@")"
            ;;
        *)
            command pyenv "$command" "$@"
            ;;
        esac
        }
fi
