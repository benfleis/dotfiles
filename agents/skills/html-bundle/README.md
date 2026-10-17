# html-bundle: files + commentary → one HTML page

One Python script that puts a set of files, diffs and Markdown notes into one self-contained HTML
page: tabs, light/dark theme with a switch, highlighted code with line numbers, a unified or side
by side diff. The page has no external resources (inline CSS/JS) and works offline from `file://`.

Needs only `uv`: the script carries PEP 723 metadata (Pygments, Python-Markdown), so running
`html-bundle …` gets them.

## Quick: the CLI

```sh
html-bundle -t "Title" --note "top comment, **Markdown**" a.py b.sql -o out.html
html-bundle -t "v1 vs v2" old/conf.py new/conf.py --diff old/conf.py new/conf.py -o out.html
html-bundle --note @notes.md --lang test=sql x.test -o out.html
```

- Each file is one tab, labelled with its file name. `--diff OLD NEW` adds a diff tab (repeatable).
- `--note` is the top comment (Markdown); `@FILE` reads it from a file.
- `--lang EXT=LANG` overrides the language for an extension (any Pygments name, or `sqllogictest`).
- Paths show as you typed them.

Per-file notes, labels and diff options need a manifest.

## The manifest (TOML)

```toml
title = "ducktest_conf.py: three object styles"
note = """
The top comment, in **Markdown**.
"""
root = "/opt/workspace/src/ducktest/driver-v0.5-oo-conf"  # file paths are relative to this; default: the manifest's dir
output = "ducktest-oo-conf.html"                          # relative to the manifest; default: <manifest>.html

[lang]           # optional: extension → language
test = "sqllogictest"

[[file]]         # a file tab
path = "examples/httpfs/ducktest_conf.py"
label = "today"  # default: the file name
lang = "python"  # default: from the extension
render = false   # Markdown files (.md) are rendered by default; false shows the source (CLI: --md-source)
note = """Markdown shown above the code."""

[[file]]         # a diff tab
old = "examples/httpfs/ducktest_conf.py"
new = "experiments/oo-conf/c/httpfs_conf.py"
label = "today → (c)"
ignore_space = true   # compare lines with whitespace normalized (like `git diff -w`)
context = 3           # unchanged lines around each change; -1 shows the whole file
note = """..."""
```

```sh
html-bundle examples/ducktest-oo-conf.toml          # writes examples/ducktest-oo-conf.html
html-bundle examples/ducktest-oo-conf.toml -o x.html
```

`-t` and `--note` on the command line override the manifest's.

**Why TOML, not Markdown front matter:** `tomllib` is in the standard library (no YAML parser to
add), `[[file]]` is a list of entries with no extra syntax, and `"""` strings hold multi-line
Markdown notes as they are. Front matter would put the per-file notes either in YAML strings
(same thing, plus a dependency) or in a body with heading conventions to parse.

## Languages

From the file extension through Pygments: Python, SQL, shell, TOML, YAML, JSON, C++, Rust,
Markdown and the rest. `.test` (also `.test_slow`, `.test_coverage`) uses a small built-in
sqllogictest lexer: runner directives (`statement ok`, `query II`, `require`, `loop` …), SQL
bodies, and the expected results after `----`. Unknown extensions show as plain text.

## The page

- Tabs; `←`/`→` move between them; the URL hash names the tab (`out.html#today`), so a link opens it.
- `◐` cycles the theme: auto (follows the OS), light, dark. Remembered per browser.
- Diff tabs: `unified` / `side by side`, remembered; the default is side by side on wide windows.
- Line numbers and diff `+`/`−` marks are not copied with the code.

## Checks

`check/` holds the checks used on the example (`npm i jsdom` once, in `check/`):

```sh
uv run --with html5lib check/static.py out.html   # strict HTML5 parse; no src/href/url()/@import/fetch
node check/check.mjs out.html                     # runs the page's JS in jsdom: no console errors, no
                                                  # resource loads, tabs, theme switch, diff toggle
```
