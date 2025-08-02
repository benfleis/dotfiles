# file contains useful common prompt functions and named specific prompt configs
#

IAM=ben

[[ $SSH_CONNECTION ]] && {
  local user_at_host='%F{#999999}%n@%M%f'
  local host='%F{#999999}b@%M%f'
  [[ $USERNAME = $IAM ]] && {
    local acct="$host"
    local acct_spc="$host "
  } || {
    local acct="$user_at_host"
    local acct_spc="$user_at_host "
  }
}

local time="%F{#88aaff}%*%f"
local pwd="%F{#AA5A18}%4~"
local stat="%(!.%F{red}R#.%F{green}->)%f"

function use_prompt_basic {
  PS1="$time ${acct_spc}$pwd $stat "
}
