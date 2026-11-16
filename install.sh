#!/bin/bash

# master list of things to install
dots=".ctags .ptconfig.toml .tmux.conf .tmux .vim .vimrc .zshenv"

# if first arg is '-f', it's force, save it and shift
force=0
if [[ $1 == '-f' ]]; then
    echo "Force enabled."
    force=1
    shift
fi

# root for src/, state/, cache/ -- same on every box
WORKSPACE="${WORKSPACE:-/opt/workspace}"

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

function link {
    tgt="$1"
    tgt_dir=$(dirname "$tgt")
    abs_src="$2"
    src=$(relpath "$tgt_dir" "$abs_src")
    # Already pointing at the right place (regardless of how it was written)? Silently noop.
    if [[ -L "$tgt" && $(readlink -f "$tgt") == $(readlink -f "$abs_src") ]]; then
        return 0
    fi
    if [[ -e "$tgt" || -L "$tgt" ]]; then
        # dangling symlinks are always safe to replace
        if [[ $force == 1 || ! -e "$tgt" ]]; then
            rm -f "$tgt"
        else
            echo "$tgt already exists.  Please remove."
            return 1
        fi
    fi
    ln -vs "$src" "$tgt"
}

# Agent skills. The one real dir is $XDG_CONFIG_HOME/agents/skills/<name>, and it holds only links:
# to dotfiles/agents/skills/* (every box) and $WORKSPACE/config/agents/skills/* (box config, where
# present); on a name clash the dotfiles one wins. The herdr skill is a thin one that runs
# `herdr --skill`, so it always matches the installed herdr. No harness looks in that dir by
# itself: pi and Codex read ~/.agents/skills (the Agent Skills convention), which links to it; Claude reads only $claude_dir/skills, which gets one link per
# skill (that dir stays real: Claude and skill installers write their own entries into it).
# $WORKSPACE/config/agents/bin/check-skills verifies the result.
function install_skills {
    local skills_dir="${XDG_CONFIG_HOME:-$HOME/.config}/agents/skills"
    local skill name entry seen=" "
    mkdir -p "$skills_dir"

    for skill in "$PWD"/agents/skills/*/ "$WORKSPACE"/config/agents/skills/*/; do
        skill="${skill%/}"
        name=$(basename "$skill")
        [[ -f "$skill/SKILL.md" ]] || continue # no match, or a dangling SKILL.md
        if [[ $seen == *" $name "* ]]; then
            echo "WARNING: skill $name: $skill is shadowed by an earlier source; skipped."
            continue
        fi
        seen="$seen$name "
        # the dir is ours: a link to another source (a skill moved) is replaced, not refused
        if [[ -L "$skills_dir/$name" && $(readlink -f "$skills_dir/$name") != $(readlink -f "$skill") ]]; then
            rm "$skills_dir/$name"
        fi
        link "$skills_dir/$name" "$skill"
    done

    # pi and Codex
    mkdir -p "$HOME/.agents"
    link "$HOME/.agents/skills" "$skills_dir"

    # Claude; an older install made a whole-dir link, or herdr a real dir holding one SKILL.md link
    [[ -L "$claude_dir/skills" ]] && rm "$claude_dir/skills"
    mkdir -p "$claude_dir/skills"
    for entry in "$skills_dir"/*; do
        [[ -e $entry ]] || continue
        name=$(basename "$entry")
        if [[ -d "$claude_dir/skills/$name" && ! -L "$claude_dir/skills/$name" && -L "$claude_dir/skills/$name/SKILL.md" ]]; then
            rm "$claude_dir/skills/$name/SKILL.md" && rmdir "$claude_dir/skills/$name"
        fi
        link "$claude_dir/skills/$name" "$entry"
    done

    # drop links to skills that are gone (removed or renamed at the source)
    for entry in "$skills_dir"/* "$claude_dir/skills"/*; do
        if [[ -L $entry && ! -e $entry ]]; then
            rm -v "$entry"
        fi
    done
}

function main {
    # link all dotfiles/foo -> $HOME/foo
    for name in $dots; do
        link "$HOME/$name" "$PWD/$name"
    done

    # link dotfiles/config/* -> $HOME/.config/*
    # (only these -- the rest of ~/.config belongs to whatever else writes there)
    # an old install linked ~/.config itself into the repo; drop that link first
    [[ -L "$HOME/.config" ]] && rm -v "$HOME/.config"
    mkdir -p "$HOME/.config"
    for name in config/*; do
        [[ $name == config/herdr ]] && continue
        link "$HOME/.$name" "$PWD/$name"
    done
    # link only config/herdr/config.toml -- herdr keeps logs, sockets, session state beside it
    mkdir -p "$HOME/.config/herdr"
    link "$HOME/.config/herdr/config.toml" "$PWD/config/herdr/config.toml"

    # link dotfiles/bin/* -> $HOME/bin/*
    mkdir -p $HOME/bin
    for name in bin/*; do
        link "$HOME/$name" "$PWD/$name"
    done

    # link only dotfiles/.ssh/rc -- the rest of ~/.ssh is private, per-machine material
    mkdir -pm 0700 "$HOME/.ssh"
    link "$HOME/.ssh/rc" "$PWD/.ssh/rc"

    # link dotfiles/claude/* -> $CLAUDE_CONFIG_DIR/* (defaults to ~/.claude)
    # (only these -- the rest of the config dir is per-machine state)
    claude_dir="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
    mkdir -p "$claude_dir"
    link "$claude_dir/CLAUDE.md" "$PWD/claude/CLAUDE.md"
    link "$claude_dir/settings.json" "$PWD/claude/settings.json"
    link "$claude_dir/statusline-command.sh" "$PWD/claude/statusline-command.sh"
    link "$claude_dir/keybindings.json" "$PWD/claude/keybindings.json"

    # per-box settings layers, passed via --settings by the claude() wrapper and iso-claude;
    # seeded, never linked, since their content is machine-local
    for local_settings in claude-local/settings.json iso-claude/settings.json; do
        local_settings="${XDG_CONFIG_HOME:-$HOME/.config}/$local_settings"
        if [[ ! -e "$local_settings" ]]; then
            mkdir -p "$(dirname "$local_settings")"
            echo '{"comment": "this file exists for your extended settings."}' >"$local_settings"
        fi
    done

    install_skills

    # install everything in the mise spec (dotfiles/config/mise); its shims_dir
    # setting puts the shims in ~/.local/bin
    export PATH="$HOME/.local/bin:$PATH"
    if ! command -v mise >/dev/null; then
        echo "mise not found, skipping tool install."
        return 1
    fi
    # run from / -- mise finds itself by PATH lookup and accepts a *directory* named
    # mise, so a ./mise dir plus an empty (cwd) PATH entry gives shims pointing at it
    (cd / && mise install --yes && mise reshim -f)
}

main
