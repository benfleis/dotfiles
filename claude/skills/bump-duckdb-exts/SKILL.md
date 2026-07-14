---
name: bump-duckdb-exts
description: Bump out-of-tree duckdb extension refs (azure, delta, unity_catalog by default) in .github/config/extensions/*.cmake to the latest ref on a given duckdb branch. Checks for outstanding extension patches first and aborts if any can't be safely resolved. Use when asked to "bump extensions", "bump azure/delta/unity", or update out-of-tree extension pins in a duckdb checkout.
---

# Bump duckdb out-of-tree extension refs

Updates `GIT_TAG` pins in `duckdb/.github/config/extensions/<ext>.cmake` for a
set of out-of-tree extensions to the latest commit on the matching branch of
each extension's own repo, on a fresh branch. Mirrors the manual workflow
used for the azure/delta/unity_catalog bump.

## Arguments

Parse from `$ARGUMENTS` (both optional, either order):
- **duckdb branch** — the branch to bump against, e.g. `main` or
  `v1.5-variegata`. Default: `main`.
- **extension list** — comma-separated extension names matching
  `.github/config/extensions/<name>.cmake` (e.g. `azure,delta,unity_catalog`).
  Default: `azure,delta,unity_catalog`.

Duckdb repo location: use the current directory if it looks like a duckdb
checkout (has `.github/config/extensions/`), otherwise check
`/opt/workspace/src/d/duckdb`. If neither works, ask the user for the path.

## Procedure

### 1. Set up the duckdb branch

```
git fetch upstream <branch>            # or origin, whichever remote tracks duckdb/duckdb
git checkout -b bump-<ext1>-<ext2>-...[-<branch> if not main] upstream/<branch>
```

Only suffix the working branch name with `-<branch>` when `<branch>` isn't
`main` (matches the naming used for the v1.5-variegata bump).

### 2. Determine target refs — no extension-repo checkout

For each extension, read its current `GIT_URL` and `GIT_TAG` out of
`.github/config/extensions/<ext>.cmake`. Then find the target ref with
`git ls-remote` (or `git log` against an already-local clone) — never `git
checkout` inside the extension repo itself:

```
git ls-remote --heads <GIT_URL>          # list branches
```

- If `<branch>` is `main`: target ref is the extension repo's default branch
  HEAD (`git ls-remote <GIT_URL> HEAD`).
- Otherwise: look for a branch in the extension repo with the *same name* as
  `<branch>` (e.g. `v1.5-variegata`). If found, target ref is that branch's
  tip. If no matching branch exists, stop and ask the user how to proceed —
  don't guess a substitute ref.
- If the target ref equals the current pin, leave that extension's `.cmake`
  file untouched (no-op bump) and note it in the summary.

### 3. Precondition — reconcile outstanding patches

For every extension with a `.github/patches/extensions/<ext>/` directory
(most won't have one — that's fine, skip straight to step 4 for those):

For each `*.patch` file in that directory, check whether it still applies
cleanly against the *target* ref (fetch/clone the extension repo to a scratch
dir, checkout the target ref there, then `git apply --check <patch>`):

- **Applies cleanly** → keep the patch as-is, no action needed.
- **Fails to apply** → determine *why* before deciding what to do:
  - Diff the patch's "after" content against the actual file content at the
    target ref. If the file already contains the patch's intended change
    (verbatim, or an equivalent fix — e.g. same symptom resolved via a
    different but functionally equivalent code path, as happened with the
    azure logger-include patch), the patch is obsolete and safe to **remove**.
  - If the file does *not* already contain the intended fix, and the patch
    just fails due to unrelated upstream drift (context mismatch, moved
    code, etc.) — this is **not safe to auto-resolve**. Abort the whole bump
    for this extension (see below) rather than dropping or force-editing the
    patch.

**Abort condition:** if any patch fails to apply AND is not verifiably
already-incorporated upstream, stop before making any file changes for that
extension (other extensions in the set can still proceed independently) and
report to the user:
- which extension/patch failed
- the target ref and the extension's git log around the affected file, so
  the user can see what changed
- that the patch needs manual rebase/review before this bump can proceed

Do not push, force-apply with fuzz, or silently drop a patch whose fix isn't
independently confirmed present.

### 4. Apply changes

For each extension that passed step 3 (or had no patches to check):
- Update `GIT_TAG` in its `.cmake` file to the target ref.
- Delete any patch files confirmed obsolete in step 3.
- If deleting patches empties the extension's patches directory, also remove
  the `APPLY_PATCHES` flag from its `duckdb_extension_load(...)` block —
  `scripts/apply_extension_patches.py` errors if `APPLY_PATCHES` is set but
  the patch dir is empty.

### 5. Commit

One commit for the whole set (squash, don't leave a separate patch-cleanup
commit unless the user asks to keep them split). Message should list each
extension's old→new ref (short SHAs) and call out any no-op (already at
target) or dropped-patch extensions with a one-line reason each.

Do not push. Report the branch name and commit to the user when done.
