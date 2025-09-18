# file contains useful common prompt functions and named specific prompt configs
#

IAM=ben

[[ $SSH_CONNECTION ]] && {
  local user_at_host='%F{#FFC000}%n%F{#FF7F50}@%M%f'
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
local pwd="%F{#AA5A18}%4~%f"
local prev="%(?.%F{green}--%f.%B%F{red}!!%b%f)"
local tail="%(!.%B%F{yellow}#.%F{green}>)%f"

function use_prompt_basic {
  PS1="$time ${acct_spc}$pwd ${prev}$tail "
}
