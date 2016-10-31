#!/bin/bash

set -ex
shopt -s expand_aliases

origin=git@github.com:benfleis/dotfiles.git
clone="$HOME/src/dotfiles.git"
alias dotfiles='git --git-dir="$clone" --work-tree="$HOME"'

[[ -d "$clone/refs" ]] || git clone --bare "$origin" "$clone"

( cd $HOME
    dotfiles config --local status.showUntrackedFiles no
    dotfiles checkout master
)
