#!/bin/bash

# master list of things to install
dots=".ctags .ptconfig.toml .tmux.conf .tmux .vim .vimrc .zshenv"
deprecated_dots=".emacs.d"

# if first arg is '-f', it's force, save it and shift
force=0
if [[ $1 == '-f' ]]; then
  echo "Force enabled."
  force=1
  shift
fi

# both $1 and $2 are absolute paths
# returns $2 relative to $1
function relpath {
  base="$1"
  path="$2"

  common_part=$base
  back=
  while [ "${path#$common_part}" = "${path}" ]; do
    common_part=$(dirname "$common_part")
    back="../${back}"
  done

  echo ${back}${path#$common_part/}
}

function link {
  tgt="$1"
  tgt_dir=$(dirname "$tgt")
  abs_src="$2"
  src=$(relpath "$tgt_dir" "$abs_src")
  # Already pointing at the right place (regardless of how it was written)? Silently noop.
  if [[ -L "$tgt" && $(readlink -f "$tgt") == $(readlink -f "$abs_src") ]]; then
    return 0
  fi
  if [[ -e "$tgt" || -L "$tgt" ]]; then
    # dangling symlinks are always safe to replace
    if [[ $force == 1 || ! -e "$tgt" ]]; then
      rm -f "$tgt"
    else
      echo "$tgt already exists.  Please remove."
      return 1
    fi
  fi
  ln -vs "$src" "$tgt"
}

function main {
  # link all dotfiles/foo -> $HOME/foo
  for name in $dots; do
    link "$HOME/$name" "$PWD/$name"
  done

  # link dotfiles/config/* -> $HOME/.config/*
  # (only these -- the rest of ~/.config belongs to whatever else writes there)
  # an old install linked ~/.config itself into the repo; drop that link first
  [[ -L "$HOME/.config" ]] && rm -v "$HOME/.config"
  mkdir -p "$HOME/.config"
  for name in config/*; do
    link "$HOME/.$name" "$PWD/$name"
  done
  link "$HOME/.config/mise" "$PWD/mise"

  # link dotfiles/bin/* -> $HOME/bin/*
  mkdir -p $HOME/bin
  for name in bin/*; do
    link "$HOME/$name" "$PWD/$name"
  done

  # link only dotfiles/.ssh/rc -- the rest of ~/.ssh is private, per-machine material
  mkdir -pm 0700 "$HOME/.ssh"
  link "$HOME/.ssh/rc" "$PWD/.ssh/rc"

  # link dotfiles/claude/* -> $CLAUDE_CONFIG_DIR/* (defaults to ~/.claude)
  # (only these -- the rest of the config dir is per-machine state)
  claude_dir="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
  mkdir -p "$claude_dir"
  link "$claude_dir/CLAUDE.md" "$PWD/claude/CLAUDE.md"
  link "$claude_dir/skills" "$PWD/claude/skills"
  link "$claude_dir/settings.json" "$PWD/claude/settings.json"
  link "$claude_dir/statusline-command.sh" "$PWD/claude/statusline-command.sh"

  # install everything in the mise spec (dotfiles/mise), then link mise's shims
  # into ~/.local/bin -- mise itself only ever puts them in its own shims dir
  export PATH="$HOME/.local/bin:$PATH"
  if ! command -v mise >/dev/null; then
    echo "mise not found, skipping tool install."
    return 1
  fi
  mise install --yes
  mise reshim
  mkdir -p "$HOME/.local/bin"
  for shim in "${MISE_DATA_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/mise}"/shims/*; do
    [[ -e "$shim" ]] || continue
    link "$HOME/.local/bin/$(basename "$shim")" "$shim"
  done
}

main
