#!/bin/ksh

# both $1 and $2 are absolute paths
# returns $2 relative to $1
function relpath {
    base="$1"
    path="$2"

    common_part=$base
    back=
    while [ "${path#$common_part}" = "${path}" ]; do
        common_part=$(dirname $common_part)
        back="../${back}"
    done

    echo ${back}${path#$common_part/}
}

function install {
    target="$1"
    source="$2"
    source_dir=$(dirname $source)
    source_base=$(basename $source)
    source=$(relpath "$HOME" "$source")
    if [[ -e "$target" && ! -L "$target" ]]; then
        echo "Real file \"$target\" already exists.  Please remove."
    else
        echo "LINKING $target -> $source"
        # if linux, use T
        ln -sf "$source" "$target"
    fi
}

# link all dotfiles/foo -> $HOME/.foo; skip bin dir and install.sh
nothing_to_do=true
for name in *; do
    [[ "$name" = "README.md" || "$name" = "install.sh" || "$name" = "bin" ]] && continue
    install "$HOME/.$name" "$PWD/$name"
done

# link dotfiles/bin/* -> $HOME/bin/*
for script in bin/*; do
    install "$HOME/$script" "$PWD/$script"
done
