# use z.lua [ https://github.com/skywind3000/z.lua ], to also use fz
export _ZL_CMD=j
export _ZL_DATA=$XDG_STATE_HOME/z
export _ZL_CASE=ignore
export _ZL_HYPHEN=1
export _ZL_NO_RESOLVE_SYMLINKS=1

ZL_SRC=${ZL_SRC:-"$HOME/src/z.lua/z.lua"}
[[ -r "$ZL_SRC" ]] || {
  echo 'z.lua not found! git -C "$HOME/src" clone https://github.com/skywind3000/z.lua.git' >&2
  return 1
}
eval "$(lua $ZL_SRC --init zsh enhanced once fzf)"
