_PREFIX=/opt/homebrew
[[ -x "$_PREFIX/bin/brew" ]] && {
  # found elsewhere, many opts to remove updates
  export HOMEBREW_NO_ANALYTICS=1
  # export HOMEBREW_NO_AUTO_UPDATE=1
  # export HOMEBREW_NO_INSTALL_UPGRADE=1
  # export HOMEBREW_NO_INSTALL_CLEANUP=1
  # export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1
  export PATH="$_PREFIX/bin:$_PREFIX/sbin:$PATH"
  fpath=( "$_PREFIX/share/zsh/site-functions" $fpath )
}
