#!/usr/bin/env bash
# Claude Code statusLine — derived from ~/.config/zsh/prompts.zsh use_prompt_basic
#
# Original zsh PS1: $time ${acct_spc}$pwd ${prev}$tail
#   time  = %F{#88aaff}%*%f           → blue-ish HH:MM:SS
#   acct  = %F{#CCB040}@%m%f          → gold @hostname (when user == ben)
#   pwd   = %F{#AA5A18}%4~%f          → rust-colored, last 4 path components
#   tail  = >                          (no exit-status indicator available here)

input=$(cat)
raw_cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // ""')

# Collapse $HOME to ~, then take last 4 path components (mimics zsh %4~)
home="$HOME"
display_cwd="${raw_cwd/#$home/~}"

# Take up to 4 trailing components
IFS='/' read -ra parts <<< "$display_cwd"
count="${#parts[@]}"
if [ "$count" -le 4 ]; then
  short_cwd="$display_cwd"
else
  short_cwd="${parts[$((count-4))]}"
  for i in $((count-3)) $((count-2)) $((count-1)); do
    short_cwd="$short_cwd/${parts[$i]}"
  done
  # preserve leading ~ or /
  if [[ "$display_cwd" == ~* ]]; then
    short_cwd="~/$short_cwd"
  else
    short_cwd="/$short_cwd"
  fi
fi

host_str=$(hostname -s)

# ANSI colors matching the zsh %F{#rrggbb} values
# Note: status line is rendered dimmed, so colors are intentionally present
GOLD='\033[38;2;204;176;64m'    # #CCB040
RUST='\033[38;2;170;90;24m'     # #AA5A18
RESET='\033[0m'

printf "${GOLD}@%s${RESET} ${RUST}%s${RESET}" \
  "$host_str" "$short_cwd"
