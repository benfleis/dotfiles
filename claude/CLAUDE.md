# Claude Rules for Me

## Basis

- In all interactions and messages, be concise; when necessary to be extremely
  concise sacrifice grammar for the sake of concision.
- Prefer ASD-STE100 Simplified Technical English when you speak. (Avoid jargon!)
- Avoid "daily positive affirmations" and simply leading with "Good
  idea", etc. When you have concrete feedback, share it; skip the fluff.
- When editing user code, preserve cosmetic/UX choices (emojis, sigils like
  ✅/❌, decorative markers). These are intentional.
- When communicating results to me, please use utf8/emoji where clarifying,
  e.g., ✅/❌.

## Feedback and Code Review

When responding to feedback or review comments, push back on suggestions that don't add clear value.
Don't implement a change just to satisfy a comment -- if a suggestion is weak or the existing code
is already correct, say so.

## Plans

At the end of a planning, share the list of unresolved questions to answer, if there are any.

## Language

"landed" code means "committed to git" (or similar if not using git). When referring to code that
Claude has added to the file system, please say that code has been "added by me/Claude" instead of
saying "landed".

## Compilation

Never use '-j$(sysctl -n hw.ncpu)' with [c]make -- let make (and ninja) handle that.

Before creating a build tree, check the env for a compiler cache and its root (`SCCACHE_BASEDIR(S)`,
`CCACHE_BASEDIR`, `SCCACHE_DIR`, `CCACHE_DIR`). If one names a directory, put the tree underneath it
-- cache entries are only portable within the basedir, so a tree outside shares nothing and rebuilds
cold. This outranks convenience: throwaway/review checkouts belong there too, not in the session
scratchpad under `/tmp`.

## Code references

When referencing a specific line or range of lines in code, always use `file_path:line_number`
format. Never give a bare line number without the file path.

## Comments

Comment the non-obvious, not the visible. Aim for outcome-level comments, over step-by-step
mechanism, and trust the reader to read the adjacent code when called for. Before writing a comment,
ask whether the line beside it already says it -- if so, drop it. Reserve comments for a surprising
idiom, a gotcha, or a *why* (not a *what*), and keep even those to one line where possible. Don't
write absence-rationale for something that never belonged; only note an absence a reader would
expect and be surprised by. Dial density down further in small scripts; when in doubt, delete the
comment. Write for a reader who has only the adjacent code: no references to prior iterations or
session-internal handles (finding IDs, "add on top").

## Commit messages

Say what the change does and the occasional why; skip the how. Shape and altitude matter more than
length.

**Shape.** The goal is payload on every line -- long prose blocks are hard to keep reading because
there's nothing to land on. Bullets are the most direct way there and a fine default: one claim
each, a line or two, grouped under plain headers. But not everything should be a bullet. Write them,
then step back and rebalance -- a sentence that frames a group, or a section short enough that it
would be a lone bullet, reads better as prose.

**Altitude.** Describe observable behavior and contract in the reader's vocabulary, not the
implementation's: "handles sync and async file lists" beats naming the poll function and its
timeouts. Internal identifiers, tuning values and call sequences live in the code, and the reader
has the diff. That extends to session-internal handles a cold reader never saw: finding or ticket
IDs ("C2"), cross-references to your own surrounding work ("add on top", "swapped from", "keep only
what we add"), and in-house jargon -- name the change by what it does, not where it came from. Spend
the why on decisions someone could reverse by accident -- a scope boundary, a deliberate omission, a
constraint that isn't obvious. Findings recorded nowhere else are worth a line each. For a squashed
commit describe the final state, not the journey -- the *internal* journey, that is: drafts,
reworks, false starts, intermediate states that never landed. Fixes the commit actually carries are
final-state facts and usually noteworthy; keep them, even when the section reads as a list of what
used to be broken. See `## Git` for trailers.

## Tooling

Prefer jq >> python -m json.tool.

Prefer `rg` (ripgrep) over grep and `fd` over find — both are installed. Use rg's type filters and
gitignore-awareness; use fd's glob/extension flags.

## Git

Never add a `Co-Authored-By: Claude ...` trailer to commit messages. Omit it by default -- I own the
outcomes, so attribution to the assistant adds nothing.

Branch names and commit leads: use conventional-commit prefixes -- `feat/`, `fix/`, `chore/` for
branches; `feat:`, `fix:`, `chore:` for commit leads. Others: `build`, `ci`, `docs`, `style`,
`refactor`, `perf`, `test`.

## DuckDB projects (core, extensions, etc.)

In sqllogictest (.test) files, separate logical segments with a labeled section header in this
style:

```
# -----------------------------------------------------------------------------
# Section Name
#
```

The separator is `#` followed by 77 dashes. The trailing lone `#` line always closes the header
block. Use this consistently when writing or editing test files in any DuckDB project.

Each `require` statement must be separated from adjacent `require` statements by a blank line.

In test files, reference environment variables with the bare-brace `{FOO}` form only -- never the
shell-style `${FOO}` form.

When a DuckDB/SQL test is written in Python, SQL stays the language of the test. Write it for a
reader of the SQL, not of the Python: whole statements in the source, the expected result next to
the query, and a visible difference between setup statements and the statements under test, as
sqllogictest gives with `statement ok` / `query`. Python supplies parameters and templates around
the SQL, and what SQL cannot do (servers, clocks, concurrency).

## Workspace rules

@/opt/workspace/config/agents/CLAUDE.md
