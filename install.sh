#!/bin/ksh

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
    if [[ -e "$tgt" && ! -L "$tgt" ]]; then
        echo "Real file \"$tgt\" already exists.  Please remove."
    else
        echo "LINK $tgt -> $src"
        # if linux, use T
        ln -sf "$src" "$tgt"
    fi
}

# link all dotfiles/foo -> $HOME/.foo; skip bin dir and install.sh
for name in *; do
    [[ "$name" = "README.md" || "$name" = "install.sh" ]] && continue
    [[ "$name" = "bin" || "$name" = "launchbar-scripts" ]] && continue
    install "$HOME/.$name" "$PWD/$name"
done

# link dotfiles/bin/* -> $HOME/bin/*
for script in bin/*; do
    install "$HOME/$script" "$PWD/$script"
done

# link lb scripts
for script in launchbar-scripts/*; do
    install "$HOME/Library/Application Support/LaunchBar/Actions" "$PWD/$script"
done

