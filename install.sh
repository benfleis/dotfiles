#!/bin/sh

function install {
    target="$1"
    source="$2"
    if [[ -e "$target" && ! -L "$target" ]]; then
        echo "Real file \"$target\" already exists.  Please remove."
    else
        echo "$target -> $PWD/$source"
        ln -sf "$PWD/$source" "$target"
    fi
}

# link all dotfiles/foo -> $HOME/.foo; skip bin dir and install.sh
nothing_to_do=true
for name in *; do
    [[ "$name" = "README.md" || "$name" = "install.sh" || "$name" = "bin" ]] && continue
    install "$HOME/.$name" "$name" 
done

# link dotfiles/bin/* -> $HOME/bin/*
for script in bin/*; do
    install "$HOME/$script" "$script"
done
