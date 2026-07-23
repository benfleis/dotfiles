---
name: archive
description: "Archive session learnings, debugging solutions, build/deploy notes to a central ARCHIVE_DIR as dated, tagged markdown with a searchable MEMORY.md index. Use when completing a significant task, resolving a tricky bug, finishing a build/deploy, or when the user says \"archive this\". Consult before repeating past work or debugging a recurring error."
---

# Archive Skill

Capture, index, and reuse project knowledge across sessions and repos in one
central store. Multi-session safe: filenames are reserved atomically and the
index is a self-healing rebuild — concurrent sessions never clobber each other.

## Store layout

Everything lives under `ARCHIVE_DIR` (resolved by the helper):

```
ARCHIVE_DIR/
  MEMORY.md                      # generated index, grouped by category
  YYYY-MM-DD/
    <project>--<slug>.md         # one archive per learning
```

`ARCHIVE_DIR` resolves as: `$ARCHIVE_DIR` → `$XDG_STATE_HOME/agents/archive`
→ `~/.local/state/agents/archive`. Print the resolved path with
`python3 <skill>/helpers/archive.py dir`.

`<project>` is auto-detected from the git repo basename (falls back to cwd).

## When to archive

- After a significant task (build fix, migration, deploy, major feature)
- After resolving a tricky debugging session
- When the user says "archive this"
- After any multi-step process with reusable learnings

## When to consult archives

- Before debugging a build, CI, infra, or deploy issue
- Before repeating a process done in a past session
- When hitting an error that may have been solved before

**Index**: read `ARCHIVE_DIR/MEMORY.md`
**Search**: `grep -ri "keyword" "$(python3 <skill>/helpers/archive.py dir)"`

## Archive workflow

Let `H=<skill-dir>/helpers/archive.py` (adjust to the real skill path).

1. **Reserve a file** (atomic; never collides across sessions):
   ```
   python3 "$H" new <slug> --category <cat> --tags <a,b> \
       --title "<title>" --summary "<one-liner>"
   ```
   Prints the reserved path, pre-filled with a frontmatter skeleton. Omit
   `--project` unless you need to override the auto-detected repo.
2. **Read** the reserved file, then **Edit** it: fill Summary, Context,
   Problem & Fix, Key Commands, Lessons. Keep it concise and reproducible —
   focus on **problems, exact commands, and fixes**.
3. **Rebuild the index** (atomic, self-healing):
   ```
   python3 "$H" index
   ```

Do not hand-edit `MEMORY.md` — it is regenerated from frontmatter on every
`index` and your edits will be overwritten. If it ever looks stale or wrong,
just run `index` again.

## Lookup workflow

1. Read `ARCHIVE_DIR/MEMORY.md` to find relevant entries by category/tag.
2. Read the specific archive file for detail.
3. Apply the learnings; grep the store for anything the index misses.

## Categories & tags

Two axes — pick both:

- **category** — the *kind* of learning (coarse, used for index grouping):
  `build`, `infrastructure`, `release`, `debugging`, `feature`, `design`,
  `ops`, `research`.
- **tags** — free-form domain/topic labels (used for grep + relevance):
  e.g. `duckdb`, `vcpkg`, `ci`, `azure`, `delta`, `unity_catalog`,
  `delta-kernel`, `databricks`, `ducktest`. Add whatever fits — new tags
  need no registration.

Rule of thumb: the extension or product you're working on is a **tag**; what
kind of problem it was is the **category**.

## Notes

- No git tracking needed — the store is local state under `ARCHIVE_DIR`.
- There is intentionally **no** SessionStart auto-load hook: this store is
  consulted on demand (native memory already covers always-on recall).
- See `references/TEMPLATE.md` for the archive file shape.
