---
name: review-duckdb-pr
description: Review DuckDB-related pull requests or PR-like diffs — duckdb/duckdb core, out-of-tree extensions (azure, delta, unity_catalog, etc.), or client drivers. Use when asked to inspect a PR, check out a PR branch, read PR descriptions/comments/reviews, verify reviewer feedback, find correctness issues not already covered by CI, identify structural/API/design risks and maintainability issues CI cannot catch, add targeted repros for found breakages, collaborate before finalizing, and produce a reviewer-ready summary without posting through GitHub. Also applies to a pre-PR local diff (a branch/working tree not yet opened as a PR). Every review runs as two blind reviews, one by a Claude model and one by a GPT (Codex) model, merged into one consolidated report.
---

# Review DuckDB PR

## Two Blind Reviews, One Report

Every review is done twice, independently: once by a Claude model and once by a GPT model (Codex or pi). The session that was asked for the review is the **consolidator**: it starts the reviews, waits for both reports, and writes the consolidated report. Everything below this section (Workflow, Review Focus, prose rules, Final Summary) is what each reviewer does.

### Roles

- **Consolidator** (the invoking session, by default). Sets up the target and output paths, forks the reviews, writes the consolidated report, and talks to the user.
- **Reviewer.** Runs the Workflow below on the target and writes one report file. A forked reviewer is told it is a reviewer: it does not fork further, does not consolidate, and does not ask the user anything (Workflow step 10 becomes a "Questions for the owner" section at the end of its report).
- If the consolidator is itself a Claude or a GPT model, it may also be that side's reviewer and fork only the other side. Otherwise (or if its own context already holds an opinion on the change, e.g. it wrote the branch) it forks both.

### Setup (consolidator)

1. Confirm the target as in Workflow step 1 (PR number and repo, or local diff and base). Record the head SHA; both reviewers review that same SHA.
2. Pick the output paths. In `/opt/workspace`: `state/tasks/reviews/<YYYY-MM-DD>/review-<pr>-<tag>/report.md` per reviewer, where `<tag>` is the short model name (`fable`, `sol`, `astra`, ...), and `state/tasks/reviews/<YYYY-MM-DD>/review-<pr>-summary.md` for the consolidated report. For a local diff use the branch or topic name in place of `<pr>`. Elsewhere, ask the user for a directory, or use `./review-<pr>/<tag>/report.md` and `./review-<pr>/summary.md`.
3. Give each reviewer its own checkout so the two do not move each other's HEAD: a detached worktree per reviewer, e.g. `git fetch upstream pull/<pr>/head && git worktree add --detach <repo>/local/review-<pr>-<tag> FETCH_HEAD`. For a local diff, both may read the same tree, but neither edits it; a reproducer goes in the reviewer's own worktree.
4. Write one prompt and give it, unchanged except for the role's paths, to both reviewers:

       You are a reviewer, not the consolidator. Read <absolute path to this SKILL.md> and follow
       it in the reviewer role. Target: <repo> PR #<pr> (head <sha>) | local diff <base>...<branch>
       in <path>. Your worktree: <worktree>. Write your report to <report path>. Do not read
       <the other reviewer's directory> or any other review of this change. Do not fork other
       reviews and do not post anything to GitHub. Put questions for the owner at the end of
       the report. <Any focus the user asked for.>

   Pass the skill by absolute path: a headless run may not have the skill installed.

### Starting the reviews

Detect what is available, in this order, and use the first that works for each side. A command that is on `PATH` but fails at once (no auth, unknown model) counts as missing: smoke-test it first with a one-line prompt (`timeout 120 codex exec --skip-git-repo-check -s read-only 'Reply with: ok'`, same for `claude -p` / `pi -p`). On this box's host, `codex` is installed but may not be logged in (401 from api.openai.com); then use pi.

| side | first choice | fallback |
| --- | --- | --- |
| GPT | `codex exec` (`command -v codex`) | `pi -p --model amazon-bedrock/global.openai.gpt-6.1-sol` |
| Claude | from Claude Code: a subagent (Task tool) with the prompt above; otherwise `claude -p` (`command -v claude`) | `pi -p --model amazon-bedrock/global.anthropic.claude-fable-5-1` |

If a pinned model name is gone, pick the newest model of that family from `pi --list-models gpt` / `pi --list-models claude`. Name the model in the report header.

Command shapes (run each in the background, log beside its report, and wait for the report file and the process exit):

    # GPT via Codex: needs network for gh; -o keeps its last message as a fallback report
    codex exec [-m <model>] -s workspace-write -c sandbox_workspace_write.network_access=true \
        -C <worktree> --add-dir <report dir> -o <report dir>/last-message.md "<prompt>" \
        > <report dir>/run.log 2>&1 &

    # GPT or Claude via pi
    pi -p --no-session --model amazon-bedrock/<model> "<prompt>" > <report dir>/run.log 2>&1 &

    # Claude via Claude Code headless. --allowedTools and --add-dir take lists, so the prompt goes
    # on stdin. Add build/test commands if the review needs probes; inside iso-claude,
    # --dangerously-skip-permissions is fine (the container is the boundary), never on the host.
    printf '%s\n' "<prompt>" | claude -p --model <model> --permission-mode acceptEdits \
        --add-dir <worktree> <report dir> \
        --allowedTools "Bash(git diff:*)" "Bash(git log:*)" "Bash(git show:*)" "Bash(git status:*)" \
            "Bash(gh pr view:*)" "Bash(gh pr diff:*)" \
            "Bash(gh api --method GET:*)" "Bash(grep:*)" "Bash(rg:*)" "Bash(ls:*)" \
        > <report dir>/run.log 2>&1 &

Per environment:

- **Claude Code (host or iso-claude sandbox).** The session is the Claude reviewer, or forks a subagent for it. GPT: `codex exec` if installed, otherwise pi with the GPT model.
- **pi.** Check `$PI_MODEL`: a Claude model is the Claude reviewer, a GPT model the GPT reviewer. The other side: `pi -p --model ...` with the other family (works everywhere pi has Bedrock), or `codex exec` / `claude -p`.
- **Codex.** The session is the GPT reviewer. Claude: `claude -p` if installed, otherwise pi with the Claude model.
- **Sandbox (iso-claude).** `config/` is read-only, but the skill only needs to read it; reports go under `state/`. Codex may not be installed there yet: use pi with the GPT model. If Codex's own sandbox cannot start inside the container, run it with `-s danger-full-access`; the container is the boundary.

**If one side cannot run** (neither tool works, or it fails part-way and does not write a report): do not wait for it and do not invent its view. Run the one review, write the consolidated report from it, and say at the top, in the verdict line: "Single review (<model>); the <Claude|GPT> review did not run: <reason>." Tell the user the same, with the command that would run the missing side.

### Blindness

- Neither reviewer sees the other's report, notes, worktree or log until both reports are written.
- If the consolidator is also a reviewer, it forks the other side first, then does and writes its own review, and only then reads the other report.
- The prompt carries the target and any user focus, never findings or a draft opinion.

### Consolidated report

Write it after both reports exist, next to them (`review-<pr>-summary.md`). Name both source reports, and the model of each, at the top. Then, short:

1. **Verdict.** One line each if they differ, one line if they agree ("Both: mergeable after small fixes").
2. **Agreed findings.** Found by both, by severity, with file/line, crediting each ("both reviewers", or `Fable M1 / sol P3`).
3. **Found by one reviewer only**, grouped per reviewer. For each, say whether you checked it and whether it holds; a finding the other reviewer contradicts is listed with both views, not dropped.
4. **Behaviour changes** the change brings that a user or caller will notice, even when both call them correct.
5. **Decisions for the owner.** The open questions from both reports, merged, each with the reviewers' recommendations.

Keep the detail in the reviewer reports and link them; the consolidated report is the one the owner reads first. The prose rules below apply to it too. Do not post it.

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
- Comments and commit messages: review the prose the diff adds, not just the code. This is not formatting — it is the part CI cannot check at all, and it decays fastest. See the dedicated section below.

## Comments, Commit Messages, and Jargon

Review added prose against the repo's own comment/commit conventions (a CLAUDE.md `## Comments` / `## Commit messages` section, if present, is the authority — read it before judging). The recurring defects, roughly in order of how often they slip through:

- **Unresolvable handles.** Finding IDs, ticket numbers, review-thread labels (`C2`, `H3`, `issue 4`) and in-house shorthand that names something a reader of this repo cannot look up. A comment is written for someone holding only the adjacent code.
- **Unanchored references to outside documents.** "the report", "the reporter", "their repro", "as discussed", "per the spec" — where nothing identifies the document. Either state the substance, or cite something checked in.
- **Traces of how the change was produced.** "add on top", "swapped from X", "keep only what we add", "now fixed", references to prior iterations or intermediate states that never landed. The reader has the final code and the diff, not the journey.
- **Comments restating the adjacent line.** If the line beside it already says it, delete it. Reserve comments for a surprising idiom, a gotcha, or a *why*.
- **A *what* clause welded onto an earned *why*.** The most common shape in practice, and the one the bullet above reads past: the comment opens with a genuine reason, then keeps going and paraphrases the code ("...so leave the null absent here" above an `if (!IsNull())`). Judge each sentence, not each comment — the first one earning its place says nothing about the last.
- **The same fact stated twice.** Two call sites in different files each explaining the shared contract they implement. Keep it where the decision is made; the second copy drifts.
- **Absence-rationale for something that never belonged** — only note an absence a reader would expect and be surprised by.
- **Commit-message altitude.** Describe observable behavior and contract in the reader's vocabulary rather than naming internal identifiers, tuning values, or call sequences. For a squashed commit, describe the final state, not the drafts and reworks that preceded it.

Apply this to **newly added prose specifically** — pre-existing comments are out of scope unless the change makes them wrong. Test files count: a `.test` description or a driver docstring is read far more often than the code under it.

Cheap mechanical sweep before the judgment pass, over added lines only:

    git diff <base>...HEAD | grep -E "^\+" | grep -inE "\b(C[0-9]|H[0-9]|M[0-9])\b|the report|reporter|their (repro|criterion|step)|as discussed|add on top|swapped from"

Run the same audit against the commit messages (`git log <base>..HEAD --format=%B`); they leak the same handles and are harder to fix later.

Two questions settle most individual cases faster than re-reading the rules:

- **Could a reader derive this from the adjacent code plus this repo?** If yes, cut it. This is what catches the welded-*what* clause.
- **Can the comment name a source outside the diff?** A spec section, an upstream library's behavior, a measured quirk of a tool. Comments that can cite something are usually the ones worth keeping; comments that cannot are often paraphrasing the line below. Not a rule — a sorting heuristic.

Do not assume volume is the defect. Measure added prose against the repo's own comparable files (comment lines vs. code lines) before claiming a file is over-commented; suites vary widely, and a file at the top of the local range is not automatically wrong. The defects above are about content, and a file can hit every one of them at perfectly ordinary density.

Three failure modes worth naming, because they are easy to fall into while reviewing:

- These defects hide in prose you skim. A correctness- and structure-focused pass reads straight past a docstring's first line. Make the sweep an explicit step rather than trusting it to surface.
- When the author is you, or the branch was written in the same session as the review, the jargon reads as meaningful because the context is still loaded. Re-read it as someone who has only the repo.
- Prose defects are not reliably caught by re-reading your own work, however carefully. They are caught by a dedicated pass, run separately, after the code work is finished. Treat the sweep as a step you execute, not a standard you hold yourself to.

## Investigation Heuristics

- Trace every caller of new or changed public/internal APIs and verify the contract is interpreted consistently.
- Compare new state flags, caches, or validity/exactness markers against existing invalidation paths, where the subsystem has any.
- When reviewing iterative fixes, do a final shape pass over the full diff instead of only the last patch. Check whether earlier fixes introduced now-unnecessary helpers, duplicate branches, awkward names, parameter bloat, or exposed APIs that can be simplified after later changes.
- For shared behavior extracted from duplicated code, re-check every old caller against the new shared path. Confirm that the extraction preserved secondary behavior such as cache invalidation, cleanup, logging, error messages, and retry limits.
- Check behavior across the states/environments this subsystem actually distinguishes (e.g. in-memory vs. persisted, single vs. multi-connection, local vs. remote storage) — see the core-specific list below for the full storage/transaction state matrix.
- Use targeted probes to answer a concrete question. If a probe finds a breakage, add the minimal repro (see Workflow step 9) before reporting it unless the user asks otherwise.
- If no correctness bug is found, still report structural concerns that create maintenance risk or make future correctness bugs likely.
- Run the added-prose sweep (see "Comments, Commit Messages, and Jargon") as its own step, not as a side effect of reading the diff for correctness.

## Final Summary

Lead with findings, ordered by severity, using file/line references. If no issues are found, say that clearly. Include non-blocking structural/code-quality observations that affected your recommendation; do not wait for a follow-up question to mention them.

Include:

- PR number/title and branch/head checked (or "local diff, no PR" for the pre-PR case).
- Build/test/probe commands run and outcomes, only if they were run.
- PR feedback status, including "no PR feedback found" when applicable.
- Any repro test added (see Workflow step 9 for where it goes).
- Comment/commit-message findings, quoting the offending text and its file/line. Report these even when nothing else is wrong; they are not the "pure formatting" the preamble excludes, and they are the one class no CI job will ever raise.
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
