#!/bin/bash

# master list of things to install
dots=".config .ctags .nvim .ptconfig.toml .tmux.conf .tmux .vim .vimrc .zimrc .zsh .zshenv .zshrc"
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

function install {
    tgt="$1"
    tgt_dir=$(dirname "$tgt")
    src="$2"
    src=$(relpath "$tgt_dir" "$src")
    if [[ $(readlink "$tgt") == $src ]]; then
        return 0
    fi
    if [[ -e "$tgt" || -L "$tgt" ]]; then
	if [[ $force == 1 ]]; then
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
        install "$HOME/$name" "$PWD/$name"
    done
    
    # link dotfiles/bin/* -> $HOME/bin/*
    mkdir -p $HOME/bin
    for name in bin/*; do
        install "$HOME/$name" "$PWD/$name"
    done
}

main
