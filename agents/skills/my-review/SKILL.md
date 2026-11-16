---
name: my-review
description: The default skill for any bare "review" request ("review 413", "review delta#357", "review this PR/branch/diff") on DuckDB-related code - duckdb/duckdb core, extensions (delta, unity_catalog, azure, iceberg, ...), client drivers - including pre-PR local diffs. A review is always dual and blind - one by the best Claude model, one by the best GPT (Codex) model - merged into one consolidated report, unless the user asks for a single review. Reads the PR description first and reviews it with the code (does it sketch what and how, does it match the diff; suggests a better one). For delta and unity_catalog PRs, compares syntax, features and use cases with duckdb-iceberg. Checks PR feedback, finds correctness, design and API risks CI cannot catch, adds repros for breakages, and writes a local report; never posts to GitHub.
---

# Review DuckDB PR

"Review" means this whole skill: two blind reviews and one consolidated report. Run a single review only when the user asks for one ("single review", "just you", or one named model), or when the one starting it picks one for a trivial PR (see "Effort: when to go all-in").

## Two Blind Reviews, One Report

Every review is done twice, independently: once by the best Claude model and once by the best GPT model. The session that was asked for the review is the **consolidator**: it starts the reviews, waits for both reports, and writes the consolidated report. Everything below this section (Workflow, PR Description, Iceberg Comparison, Review Focus, prose rules, Final Summary) is what each reviewer does.

### Roles

- **Consolidator** (the invoking session, by default). Sets up the target and output paths, forks the reviews, writes the consolidated report, and talks to the user.
- **Reviewer.** Runs the Workflow below on the target and writes one report file. A forked reviewer is told it is a reviewer: it does not fork further, does not consolidate, and does not ask the user anything (Workflow step 10 becomes a "Questions for the owner" section at the end of its report).
- If the consolidator runs the chosen model of one side (below), it may be that side's reviewer and fork only the other side. Otherwise (another model, or its context already holds an opinion on the change, e.g. it wrote the branch) it forks both.

### Setup (consolidator)

1. Confirm the target as in Workflow step 1 (PR number and repo, or local diff and base). Record the head SHA; both reviewers review that same SHA.
2. Pick the output paths. In `/opt/workspace`: `state/tasks/reviews/<YYYY-MM-DD>/review-<pr>-<tag>/report.md` per reviewer, where `<tag>` is the short model name (`fable`, `astra`, ...), and `state/tasks/reviews/<YYYY-MM-DD>/review-<pr>-summary.md` for the consolidated report. For a local diff use the branch or topic name in place of `<pr>`. Elsewhere, ask the user for a directory, or use `./review-<pr>/<tag>/report.md` and `./review-<pr>/summary.md`.
3. Give each reviewer its own checkout so the two do not move each other's HEAD: a detached worktree per reviewer, e.g. `git fetch upstream pull/<pr>/head && git worktree add --detach <repo>/local/review-<pr>-<tag> FETCH_HEAD`. For a local diff, both may read the same tree, but neither edits it; a reproducer goes in the reviewer's own worktree.
4. Write one prompt and give it, unchanged except for the role's paths, to both reviewers:

       You are a reviewer, not the consolidator. Read <absolute path to this SKILL.md> and follow
       it in the reviewer role. Target: <repo> PR #<pr> (head <sha>) | local diff <base>...<branch>
       in <path>. Your worktree: <worktree>. Write your report to <report path>. Do not read
       <the other reviewer's directory> or any other review of this change. Do not fork other
       reviews and do not post anything to GitHub. Put questions for the owner at the end of
       the report. <Any focus the user asked for.>

   Pass the skill by absolute path: a headless run may not have the skill installed.

### Models and where they run

The strongest reviewer on each side, as of 2026-11-04 (top Bedrock price tier of each family; both smoke-tested in pi and Codex on the host), with the default level of each:

| side | model | default level | tag |
| --- | --- | --- | --- |
| Claude | `global.anthropic.claude-fable-5-1` (pi: `amazon-bedrock/...`) | `max` | `fable` |
| GPT | `openai.gpt-6-astra` (Codex) / `global.openai.gpt-6-astra` (pi) | `xhigh` | `astra` |

If a name is gone, take the top tier of the newest family from `pi --list-models claude` / `pi --list-models openai` (Claude: Fable above Opus above Sonnet; GPT: Astra above Sol above Terra/Luna) and name the model in the report header. Always pass the level: without `-c model_reasoning_effort`, Codex logs `reasoning effort: none` and the model runs at its own default (`medium`).

### Effort: when to go all-in

Depth costs wall time and money. On the first run Fable `max` took about 18 minutes and Astra
`xhigh` about 4, and Fable found more lower-severity issues. Depth pays off only where more
verification can find something. The one who starts the review (ATC, or the consolidator) picks
the shape from the **risk** of the change, not only its size. It writes the shape, the levels and
one line of why at the top of the consolidated report.

Take the first row that applies:

| the change | shape | levels |
| --- | --- | --- |
| **High risk.** Touches storage, transactions, concurrency, serialization or wire format, caching or invalidation, credentials or secrets. Or adds or changes public syntax, options, functions, defaults or errors. Or changes behaviour that its tests barely cover. Or is a design or architecture change. | all-in: both sides, full Workflow, probes and repros; iceberg comparison for delta/uc | Fable `max` + Astra `xhigh` (Astra `max` for design work) |
| **Normal.** Bug fix or feature whose behaviour change the added tests cover | both sides, full Workflow | Fable `max` + Astra `xhigh` (the default) |
| **Low risk.** Mechanical (bump, rename, generated code), docs or test-only, or a small change with no behaviour change | one side, Astra (fast; runs probes cheaply); skip probes unless something looks off | Astra `high` |
| **Re-review.** Fix-ups after an earlier review of the same PR | one side, the one that found the most; scope: the diff since the reviewed head, and whether each earlier finding is resolved | that side's level from the first review |

- **Raise the shape** for any of these:
  - a first PR from an outside author in that area;
  - a fix for a reported correctness bug;
  - a change the owner calls important;
  - a re-review whose fix-up touches a high-risk area or is larger than the original findings
    called for.
- **Escalate mid-review.** If a one-side review finds a correctness issue or anything that looks
  off, run the other side blind at the default level before writing the consolidated report. Say
  so in its header.
- **Design work: add to the prompt.** Ask the reviewers to weigh at least one alternative design
  and to write an explicit "Design" section (ownership, layering, API shape, migration). Set a
  time budget. At `max`, tell Fable not to draft the report twice in thinking.
- **The user's word wins.** "Full review", "single review", "just you" or a named model overrides
  this table.
- **Re-tune from data.** Every consolidated report logs level, wall time, cost and findings per
  side (below). After about 10 runs, compare findings per side and level against cost. If the
  table should change, file a `Kind: question` for the owner with the numbers. Do not drift from
  this table silently.

Log the cost of every run: Codex prints `tokens used` at the end of `run.log`; pi with `--mode json` writes `usage.cost` per message (`jq -s '[.[] | select(.type=="message_end" and .message.role=="assistant") | .message.usage.cost.total] | add' run.jsonl`). Put both in the consolidated report header.

Smoke-test each side before forking (`Reply with: ok`, `timeout 180`). A command that is on `PATH` but fails at once (auth, unknown model, region) counts as missing.

| where | Claude side | GPT side |
| --- | --- | --- |
| host pi (default) | `pi -p` with Fable | `codex exec` on Bedrock (flags below; host `~/.codex` has no provider, and its OpenAI login gives 401); fallback `pi -p` with Astra |
| iso pi (sandbox) | `pi -p` with Fable | `codex exec` (iso config sets Bedrock, us-east-1, `danger-full-access`); fallback `pi -p` with Astra |
| Claude Code | Task subagent or `claude -p --model <claude id>`; fallback `pi -p` | `codex exec`, fallback `pi -p` |
| Codex | `claude -p` or `pi -p` with Fable | itself, if on Astra |

Command shapes (run each in the background, log beside its report, and wait for the report file and the process exit):

    # GPT via Codex. On the host add: -c model_provider=amazon-bedrock
    #   -c model_providers.amazon-bedrock.aws.region=us-east-1 (gpt-6 404s in other regions)
    #   -s workspace-write -c sandbox_workspace_write.network_access=true (network for gh).
    # In iso, the config already sets the provider and danger-full-access (bubblewrap cannot start there).
    codex exec -m openai.gpt-6-astra -c model_reasoning_effort=xhigh \
        -C <worktree> --add-dir <report dir> \
        -o <report dir>/last-message.md "<prompt>" > <report dir>/run.log 2>&1 &

    # Claude via pi (GPT fallback: amazon-bedrock/global.openai.gpt-6-astra --thinking xhigh)
    pi -p --no-session --mode json --model amazon-bedrock/global.anthropic.claude-fable-5-1 \
        --thinking max "<prompt>" > <report dir>/run.jsonl 2>&1 &

    # Claude via Claude Code headless: prompt on stdin (--allowedTools/--add-dir take lists);
    # --dangerously-skip-permissions only inside iso-claude, never on the host.
    printf '%s\n' "<prompt>" | claude -p --model <model> --permission-mode acceptEdits \
        --add-dir <worktree> <report dir> \
        --allowedTools "Bash(git diff:*)" "Bash(git log:*)" "Bash(git show:*)" "Bash(git status:*)" \
            "Bash(gh pr view:*)" "Bash(gh pr diff:*)" \
            "Bash(gh api --method GET:*)" "Bash(grep:*)" "Bash(rg:*)" "Bash(ls:*)" \
        > <report dir>/run.log 2>&1 &

If Codex stops part-way (e.g. OpenAI's "high-risk cyber activity" flag) and writes no report, re-run that side with pi on the same model from a clean worktree.

**If one side cannot run** (no tool works, or it fails part-way and writes no report after the retry): do not wait for it and do not invent its view. Run the one review, write the consolidated report from it, and say at the top, in the verdict line: "Single review (<model>); the <Claude|GPT> review did not run: <reason>." Tell the user the same, with the command that would run the missing side.

### Blindness

- Neither reviewer sees the other's report, notes, worktree or log until both reports are written.
- If the consolidator is also a reviewer, it forks the other side first, then does and writes its own review, and only then reads the other report.
- The prompt carries the target and any user focus, never findings or a draft opinion.

### Consolidated report

Write it after both reports exist, next to them (`review-<pr>-summary.md`). Name both source reports, and the model, level, wall time and cost of each, at the top. Then, short:

1. **Verdict.** One line each if they differ, one line if they agree ("Both: mergeable after small fixes").
2. **Agreed findings.** Found by both, by severity, with file/line, crediting each ("both reviewers", or `Fable M1 / Astra P3`).
3. **Found by one reviewer only**, grouped per reviewer. For each, say whether you checked it and whether it holds; a finding the other reviewer contradicts is listed with both views, not dropped.
4. **PR description.** The merged verdict on it, and one suggested description if either reviewer found it short (pick or merge theirs; do not write a third).
5. **Iceberg comparison** (delta/uc only): merged, keeping each gap once.
6. **Behaviour changes** the change brings that a user or caller will notice, even when both call them correct.
7. **Decisions for the owner.** The open questions from both reports, merged, each with the reviewers' recommendations. **Each one is also filed** as a `Kind: question` entry in the topic TODO (`atc note`, then `Kind:` and `Parent:` on their own lines, `- [n]` options, the recommendation marked), whose first body line is `Blocks: <what cannot proceed until it is answered>` (e.g. `Blocks: merge uc#159-uc-ctas`, or `Blocks: nothing (follow-up)`). A decision that is only in the summary is invisible to the owner's view.

Keep the detail in the reviewer reports and link them; the consolidated report is the one the owner reads first. The prose rules below apply to it too. Do not post it.

## Workflow

1. Confirm the target PR number and URL. If the URL and requested checkout number disagree, inspect both PR headers and ask or infer conservatively before changing the worktree.
   - Pre-PR / local-diff case: if there is no PR number (a not-yet-pushed branch or working-tree change), skip the `gh` checkout steps and review the local diff directly with `git diff` / `git diff <base>...HEAD`. All Review Focus, Investigation, and Final Summary sections still apply.
2. Read the PR description first, before the diff, and write down what it claims (see "PR Description" below). Then read the commits, changed files, top-level comments, submitted reviews, and inline review comments. Use `gh pr view` for supported fields and `gh api repos/<owner>/<repo>/pulls/<pr>/comments` plus `gh api repos/<owner>/<repo>/issues/<pr>/comments` for comments not exposed by `gh pr view` — use the PR's actual owner/repo (`gh repo view --json nameWithOwner`), don't assume `duckdb/duckdb`. For a local diff, the branch's commit messages (or the user's summary) stand in for the description.
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

## PR Description

The description is an input and a review target. A good one sketches the feature at a high level: **what** it does for a user or caller (new syntax, behaviour, fixed bug) and, when the change is not obvious from the diff, **how** (approach, the layer it touches, notable trade-offs or limits). It does not walk the code line by line.

Judge, and report under its own heading:

- **Sketch.** Does it say what, and how where that is needed? Is it short enough to read in a minute?
- **Match.** Does it match the diff: claimed behaviour that the code does not do, code that changes behaviour the description does not mention (new options, defaults, errors, removed paths), stale text from an earlier revision.
- **Feedback.** Point out what is missing or wrong. If it falls short, write a suggested description (a few lines, the author's voice, no review jargon) the author can paste.

For our own PRs, the author runs one Codex tightening pass on the description after the last code change and before hand-off (`config/agents/AGENTS.md`, "PR descriptions"); this review's feedback is input to that pass, not a replacement for it.

A mismatch between description and diff is a finding, ranked like any other: it is often the first sign that the code does something the author did not intend.

## Iceberg Comparison (delta and unity_catalog)

For a duckdb-delta or unity_catalog PR that adds or changes user-facing syntax, options, functions, catalog/secret behaviour, or a scan/write feature, compare it with duckdb-iceberg. Skip it (say "not applicable" in one line) for internal fixes with no user-visible surface.

Checkout (read-only, shared): use `/opt/workspace/src/d/iceberg` or, if that is absent, `/opt/workspace/src/d/ice`; if neither exists, `git clone https://github.com/duckdb/duckdb-iceberg /opt/workspace/src/d/iceberg` (no submodules). Run `git -C <dir> fetch origin` at the start of each review, then read `origin/main` with `git grep origin/main -- src test` and `git show origin/main:<path>`. Never check out, build or edit there: other agents read the same tree.

Report, in a short table or list:

- **Name and syntax.** What iceberg calls the same thing (function, `ATTACH`/`TYPE` option, secret field, setting, pragma), and how the spelling, defaults and argument shapes differ.
- **Behaviour.** Semantics in edge cases: errors, time travel, snapshot pinning, credential refresh, pushdown, partitioning, write and commit rules.
- **Gaps either way.** What iceberg has that delta/uc lacks, and the reverse, with the iceberg file/test that shows it.
- **Use case.** Whether a user moving between the two formats would be surprised, and whether the PR should align its name or behaviour with iceberg (a recommendation, not a blocker unless the mismatch is a correctness or API-consistency issue).

Cite iceberg at its `origin/main` short SHA.

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
- PR description verdict (sketch, match), with a suggested description if it falls short.
- Iceberg comparison for delta/uc PRs, or "not applicable".
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
