---
name: html-bundle
description: "Bundle related files, diffs and Markdown commentary into ONE self-contained HTML page (tabs, light/dark, highlighted code). Use when the user should compare or walk through several files side by side: alternatives of one file, a review walkthrough, \"show X in each format/style\", old vs new of a file. Not for a single file or a plain text report."
---

# html-bundle

`/opt/workspace/config/dotfiles/bin/html-bundle` (also `html-bundle` where dotfiles `bin/` is on PATH) makes one
HTML page: one tab per file or diff, a top note and a note per tab, in Markdown. The page has no
external resources and opens from `file://`. Needs only `uv`.

## When

- Alternatives of one thing: the same conf in three styles, two designs of one API.
- A review walkthrough: the files a change touches, each with what to look at.
- "Show X in each format": one test as `.test`, Python and YAML.
- Old vs new of a file, as a diff tab.

Not for: one file (show it in the reply), prose-only reports (Markdown), anything the user asked as
plain text.

## Where the output goes

Next to the report it belongs to, with the same stem:
`/opt/workspace/state/tasks/reviews/<YYYY-MM-DD>/<topic>.html` beside `<topic>.md`, or in the task's
dir under `/opt/workspace/state/tasks/<task>/`. Keep the manifest beside it (`<topic>.toml`) so the
page can be rebuilt. Never in the session scratchpad: the user opens these.

## How

Quick, without per-file notes:

```sh
/opt/workspace/config/dotfiles/bin/html-bundle -t "Title" --note "what to compare" a.py b.py c.py -o <dir>/<topic>.html
/opt/workspace/config/dotfiles/bin/html-bundle -t "Title" old.py new.py --diff old.py new.py -o <dir>/<topic>.html
```

With labels, per-file notes or diff options, write a TOML manifest:

```toml
title = "…"
note = """What the page shows and the one thing to take from it."""
root = "/abs/path/of/the/checkout"   # file paths below are relative to it
output = "<topic>.html"

[[file]]
path = "src/x.py"
label = "today"
note = """What differs here, and why it matters."""

[[file]]
old = "src/x.py"
new = "src/y.py"
label = "today → (b)"
ignore_space = true   # when the change re-indents
```

```sh
/opt/workspace/config/dotfiles/bin/html-bundle <dir>/<topic>.toml
```

Example: `/opt/workspace/state/tasks/html-bundle/examples/ducktest-oo-conf.toml`.

## Notes are the value

- The top note says what is compared and the conclusion; a tab's note says what to see in that file.
  Do not repeat the file's own comments.
- Short labels: `today`, `(a) Project(...)`, `today → (c)`.
- Language comes from the extension; `.test` is sqllogictest. Override: `lang = "sql"` per file,
  `[lang] ext = "…"` in the manifest, or `--lang ext=lang`.
- Point the user at the file with its full path; the hash opens a tab: `<topic>.html#today`.

Manifest format and options: `README.md` beside this file.
