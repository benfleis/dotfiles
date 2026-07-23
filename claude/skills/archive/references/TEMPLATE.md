# Archive Template

`archive.py new` writes this skeleton for you. Edit the reserved file to fill
it in; then run `archive.py index`.

```markdown
---
title: Short human title
date: YYYY-MM-DD
project: repo-basename
category: build | infrastructure | release | debugging | feature | design | ops | research
tags: [duckdb, vcpkg, ci]
summary: One-line summary used verbatim in the MEMORY.md index.
related: [other-archive-filename-without-ext]
---

# {title} — {date}

## Summary
One-line description of what was accomplished.

## Context
- **Project**: {repo}
- **Branch**: {branch}
- **Related Issue/PR**: {if applicable}

## Problem & Fix

### 1. {Issue title}
- {What went wrong}
- **Fix**: {How it was resolved}

## Key Commands / Changes
{Exact commands, config diffs, or snippets that mattered}

## Lessons Learned
{Optional: insight for future sessions}
```

## Frontmatter fields (all parsed by `archive.py index`)

- **title** — index heading for the entry.
- **date** — `YYYY-MM-DD`; also the day directory. Auto-filled.
- **project** — repo basename; auto-detected. Distinguishes cross-repo entries.
- **category** — coarse *kind*; drives index grouping/order. One value.
- **tags** — `[a, b, c]` domain/topic labels for grep + relevance. Free-form.
- **summary** — one line shown next to the entry in `MEMORY.md`. Keep it tight.
- **related** — optional; filenames (no `.md`) of related archives.

The index is derived entirely from frontmatter, so keep `summary` and `tags`
accurate — they are what makes an entry findable later.
