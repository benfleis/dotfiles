_PREFIX=/opt/homebrew
[[ -x "$_PREFIX/bin/brew" ]] && {
  # direct from brew shellenv
  export HOMEBREW_PREFIX="/opt/homebrew";
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
  export HOMEBREW_REPOSITORY="/opt/homebrew";
  eval "$(/usr/bin/env PATH_HELPER_ROOT="/opt/homebrew" /usr/libexec/path_helper -s)"
  [ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}";
  export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";

  # found elsewhere, many opts to remove updates
  export HOMEBREW_NO_ANALYTICS=1
  # export HOMEBREW_NO_AUTO_UPDATE=1
  # export HOMEBREW_NO_INSTALL_UPGRADE=1
  # export HOMEBREW_NO_INSTALL_CLEANUP=1
  # export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1
  export PATH="$_PREFIX/bin:$_PREFIX/sbin:$PATH"
  fpath=( "$_PREFIX/share/zsh/site-functions" "$_PREFIX/share/zsh-completions" $fpath )
  typeset -U fpath # uniquify
}
