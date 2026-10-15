# Machine-local Claude settings (env, hooks) layer over the shared ~/.claude/settings.json.
# Only one --settings counts, so a --settings typed here replaces this layer.
claude() {
    local s=${XDG_CONFIG_HOME:-$HOME/.config}/claude-local/settings.json
    if [[ -r $s ]]; then
        command claude --settings "$s" "$@"
    else
        command claude "$@"
    fi
}
