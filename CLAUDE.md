# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository structure

This is a dotfiles repo. Dotfiles here correspond 1:1 to paths under `$HOME`, except `config/`, which maps to `~/.config/` — `config/zsh/.zshrc` here lives at `~/.config/zsh/.zshrc` on disk — and `mise/` (global mise tool spec), which maps to `~/.config/mise/`.

Two deployment mechanisms exist:

- **Bare clone** (`bootstrap.bash`): clones to `~/src/dotfiles.git` as a bare repo with `--work-tree=$HOME`. This is the primary method for bootstrapping a new machine.
- **Symlink installer** (`install.sh`): creates relative symlinks from `$HOME/foo` → `dotfiles/foo` for the dotfiles listed at the top of `install.sh`, plus `$HOME/.config/foo` → `dotfiles/config/foo` per entry (never `~/.config` itself). It then runs `mise install` and links mise's shims into `~/.local/bin`. Run with `-f` to force-overwrite existing files.

There are no build steps, tests, or linting commands.

## Key config areas

### zsh (`config/zsh/`)

Uses `ZDOTDIR` redirection: `~/.zshenv` sets `ZDOTDIR=$HOME/.config/zsh` and sources `config/zsh/.zshenv`, which contains SSH agent socket stabilization. `config/zsh/.zshrc` is the main interactive config.

Config is split into:

- `by-machine/zshrc-HOSTNAME.zsh` — sourced if hostname matches (checked in git for some machines, also checked from `$XDG_STATE_HOME/zsh/by-machine/` for secrets)
- `by-name/*.zsh` — topic files, loaded in sort order (numeric prefixes control order)

### neovim (`config/nvim/`)

LazyVim base. Customizations live in:

- `lua/config/` — `options.lua`, `keymaps.lua`, `autocmds.lua` (LazyVim lifecycle hooks)
- `lua/plugins/` — plugin overrides/additions, one file per concern
- `lua/keylib.lua` — shared keymap helpers used across config files
- `lua/plugins/base.lua` — extra plugins; `core.lua` sets colorscheme to `modus`

Leader is `;`, local leader is `,`.

### tmux (`.tmux.conf`)

Prefix is `C-z` (not the default `C-b`). Vi mode everywhere.

### bin/

Personal scripts, installed via `install.sh` symlinks to `~/bin/`. Notable: `tmux-sesh`, `tzoom` (tmux zoom helper used in `.tmux.conf`), `rebase-since.sh` (aliased in zsh as `gr-branch`).

### git (`config/git/`)

Hooks path points to `config/git/hooks/` (pre-push hook). Global gitignore at `gitignore_global`.

## General Preferences

- vi modes everywhere reasonable
