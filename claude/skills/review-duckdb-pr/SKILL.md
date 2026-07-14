---
name: review-duckdb-pr
description: Review DuckDB-related pull requests or PR-like diffs — duckdb/duckdb core, out-of-tree extensions (azure, delta, unity_catalog, etc.), or client drivers. Use when asked to inspect a PR, check out a PR branch, read PR descriptions/comments/reviews, verify reviewer feedback, find correctness issues not already covered by CI, identify structural/API/design risks and maintainability issues CI cannot catch, add targeted repros for found breakages, collaborate before finalizing, and produce a reviewer-ready summary without posting through GitHub. Also applies to a pre-PR local diff (a branch/working tree not yet opened as a PR).
---

# Review DuckDB PR

## Workflow

1. Confirm the target PR number and URL. If the URL and requested checkout number disagree, inspect both PR headers and ask or infer conservatively before changing the worktree.
   - Pre-PR / local-diff case: if there is no PR number (a not-yet-pushed branch or working-tree change), skip the `gh` checkout steps and review the local diff directly with `git diff` / `git diff <base>...HEAD`. All Review Focus, Investigation, and Final Summary sections still apply.
2. Read the PR description, commits, changed files, top-level comments, submitted reviews, and inline review comments. Use `gh pr view` for supported fields and `gh api repos/<owner>/<repo>/pulls/<pr>/comments` plus `gh api repos/<owner>/<repo>/issues/<pr>/comments` for comments not exposed by `gh pr view` — use the PR's actual owner/repo (`gh repo view --json nameWithOwner`), don't assume `duckdb/duckdb`.
3. Treat later PR feedback as more important than earlier feedback because author changes or reviewer decisions may supersede older comments. Explicitly note when there is no feedback to verify.
4. Check `git status --short` before checkout or edits. Never discard unrelated local changes. Checkout the requested PR with `gh pr checkout <pr>` unless the worktree is already on the exact PR head.
5. Run builds/tests only when the user asks, when local inspection requires a built artifact, or when a targeted probe is needed to confirm a suspected issue. Do not spend review time proving that the existing test suite or formatter passes; CI already checks that.
6. Review changed code with this priority order: correctness risks not covered by existing tests first, structural/API/design issues second, implementation quality third. Prefer local patterns and surrounding invariants over broad redesigns.
   Do not drop non-blocking structural/API/design or implementation-quality concerns from the initial review summary just because a higher-severity correctness finding exists. If a concern is worth mentioning when asked later, include it in the first summary as a lower-severity finding, quality note, residual risk, or explicit "not a blocker" note.
7. Verify whether PR feedback has been implemented. Quote or summarize the relevant feedback and point to the current code/test state that addresses or misses it.
8. Use existing tests as documentation for expected behavior and coverage gaps. Run focused tests or ad hoc SQL only when they exercise a newly suspected edge case, validate a minimal repro, or cover behavior that CI is unlikely to exercise.
9. If a breakage is found, add a minimal reproducer before reporting it, unless the user asks for a different location. In duckdb/duckdb core the convention is `test/temp.test`; for extensions/drivers, use an equivalent scratch/temp test location if the repo has one, or ask the user where to put it. Keep the reproducer concise and runnable.
10. Collaborate before finalizing: ask the user for their opinion on one or two specific uncertain code points, especially where judgment rather than proof drives the review.
11. Do not post a PR review, comments, or summary via the GitHub API. Produce a local summary only.

## GitHub Read-Only Access

Autonomous review depends on reading GitHub PR metadata. The commands below are read-only and safe to allowlist so they stop prompting — add them under `permissions.allow` in `.claude/settings.json` (project) or `~/.claude/settings.json` (personal):

- `Bash(gh pr view:*)` — PR metadata, descriptions, commits, files, checks, comments, and reviews exposed by `gh pr view`.
- `Bash(gh pr diff:*)` — read-only PR diffs.
- `Bash(gh pr checkout:*)` — only after the target PR is confirmed and `git status --short` is checked.
- `Bash(gh api --method GET:*)` — read-only GitHub API calls. Always put `--method GET` immediately after `gh api`, e.g. `gh api --method GET repos/<owner>/<repo>/pulls/<pr>/comments`, so the command stays read-only.

Never run or request write/mutating commands: `gh pr review`, `gh pr comment`, `gh issue comment`, `gh pr merge`, or `gh api --method POST/PATCH/PUT/DELETE`. Do not allowlist broad prefixes such as `Bash(gh:*)` or `Bash(gh pr:*)` that would also permit those.

## Review Focus

Look for issues CI is unlikely to find. Do not report pure formatting, generated-file style, or routine suite failures unless the user specifically asks; those belong to CI.

- Correctness beyond existing coverage: focus on the invariants of the subsystem actually touched (parsing/binding, execution, catalog/scan integration, protocol/wire format, type conversion — whichever apply) and boundary cases not exercised by added tests. See the duckdb/duckdb-core-specific list below for engine-internal risk areas.
- Structural/API/design: whether the change introduces duplicate sources of truth, unclear ownership, leaky layering, inconsistent contracts across callers, unsafe defaults, missing invalidation, confusing names, or behavior that future contributors can easily misuse.
- Implementation quality: whether the approach is scoped to the intended subsystem, preserves invariants, has safe bailouts, uses existing DuckDB (or driver-toolkit) helper APIs, and avoids unrelated churn.
- Duplication: when new code mirrors existing logic elsewhere in the repo (e.g. core parser/binder/execution, or an extension's existing scan/catalog code), cite the source and duplicate locations. Decide whether it is acceptable local repetition, a shared-helper candidate, or a maintenance risk, and report that judgment in the first review summary if non-trivial.
- Near-duplicate control flow: when two or more paths perform the same operation with small local variations, compare their side effects as well as their main result. Look for drift in invalidation, logging, metrics, cleanup, error wrapping, retry bounds, locks, and state updates. Prefer a shared core with thin adapters when the behavior is meant to stay identical.
- Helper shape and ownership: when a new helper needs many callbacks, boolean switches, or loosely related parameters, check whether it is carrying multiple responsibilities. Consider whether a small request/context struct, policy object, or existing local abstraction would make the contract clearer.
- Header/API exposure: review newly added declarations for visibility and grouping. Keep overrides and public APIs easy to find, move implementation helpers to private/protected scope where possible, and avoid exporting helpers only because they were convenient during implementation.
- Test quality: whether added tests prove the risky behavior rather than only the happy path. Prefer suggesting missing targeted cases over running tests that CI already runs.

## Investigation Heuristics

- Trace every caller of new or changed public/internal APIs and verify the contract is interpreted consistently.
- Compare new state flags, caches, or validity/exactness markers against existing invalidation paths, where the subsystem has any.
- When reviewing iterative fixes, do a final shape pass over the full diff instead of only the last patch. Check whether earlier fixes introduced now-unnecessary helpers, duplicate branches, awkward names, parameter bloat, or exposed APIs that can be simplified after later changes.
- For shared behavior extracted from duplicated code, re-check every old caller against the new shared path. Confirm that the extraction preserved secondary behavior such as cache invalidation, cleanup, logging, error messages, and retry limits.
- Check behavior across the states/environments this subsystem actually distinguishes (e.g. in-memory vs. persisted, single vs. multi-connection, local vs. remote storage) — see the core-specific list below for the full storage/transaction state matrix.
- Use targeted probes to answer a concrete question. If a probe finds a breakage, add the minimal repro (see Workflow step 9) before reporting it unless the user asks otherwise.
- If no correctness bug is found, still report structural concerns that create maintenance risk or make future correctness bugs likely.

## Final Summary

Lead with findings, ordered by severity, using file/line references. If no issues are found, say that clearly. Include non-blocking structural/code-quality observations that affected your recommendation; do not wait for a follow-up question to mention them.

Include:

- PR number/title and branch/head checked (or "local diff, no PR" for the pre-PR case).
- Build/test/probe commands run and outcomes, only if they were run.
- PR feedback status, including "no PR feedback found" when applicable.
- Any repro test added (see Workflow step 9 for where it goes).
- Open questions or residual risk.
- A concise overall recommendation.

Avoid long narrative. Keep the summary reviewer-ready and do not include instructions to post it.

## DuckDB Core (duckdb/duckdb) Specifics

Apply these *in addition to* the general Review Focus / Investigation Heuristics above, only when reviewing duckdb/duckdb core itself (not extensions or drivers):

- Correctness: SQL semantics, transaction/storage guarantees, concurrency, serialization/deserialization, prepared/reused plans, verification-only behavior, optimizer rewrites across projections/aliases/unions, unsupported plan shapes.
- State coverage: check behavior across in-memory, checkpointed, restarted, local-storage, transaction-local, and rollback states when the subsystem distinguishes them.
- Validity/exactness markers: statistics "exactness" flags and similar cache-validity markers are a core-engine concept — compare against existing invalidation paths specifically.
- Skip-mask config: check whether PR-added config skips mask behavior instead of testing it directly.
- Duplication example subsystems: parser, binder, execution engine.
