# leverage pyenv if installed
[[ -x $HOME/.pyenv/bin ]] && {
  export PATH="$HOME/.pyenv/bin:$PATH"
}
if ( command -v pyenv >/dev/null ); then
  [[ -r $ZDOTDIR/pyenv-init.zsh ]] && source $ZDOTDIR/pyenv-init.zsh
fi
