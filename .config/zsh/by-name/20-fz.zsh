# fz [ https://github.com/changyuheng/fz.sh ]
export FZ_CMD=jj
export FZ_SUBDIR_CMD=j
export FZ_HISTORY_CD_CMD=_zlua

FZ_SRC=${FZ_SRC:-"$HOME/src/fz.sh/fz.plugin.zsh"}
[[ -r "$ZL_SRC" ]] || {
  echo 'z.lua not found! git -C "$HOME/src" clone https://github.com/changyuheng/fz.sh.git' >&2
  echo "fz not found! https://github.com/changyuheng/fz.sh" >&2
  return 1
}
source "$FZ_SRC"
