# This file is sourced on login shells only (responsible for setting up the
# initial environment)

set -gx PATH /bin
append-to-path /sbin
append-to-path /usr/bin
append-to-path /usr/sbin

# prepend-to-path /usr/local/share/npm/bin
prepend-to-path /usr/local/sbin
prepend-to-path /usr/local/bin

prepend-to-path ~/.nvm/v0.10.26/bin
prepend-to-path ~/bin

# Set locale
set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8
