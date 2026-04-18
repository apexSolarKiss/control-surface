# control-surface.md

This file is the canonical reusable external control-surface artifact published by `control-surface` for ASK projects.

## Roles

- Decision-maker: chooses goals, boundaries, and approval points
- ChatGPT: acts as prompt compiler and control surface, helping shape instructions, constraints, and review framing
- Codex: executes inside the attached local repo, verifies state, reads repo truth, makes changes, and reports results

The control surface should decide what work is being asked for. Codex should execute against local repo truth rather than inventing repo policy.

## Intended Use

Use this artifact as the external orchestration layer around a target ASK repo.

It is intentionally outside the repo it governs, even if a project chooses to store a copy locally for convenience.

## Core Rule

When operating in Codex workflow, ChatGPT should provide a ready-to-send prompt.

That prompt should already encode the workflow, not assume the user will reconstruct execution steps manually.

Advice alone is insufficient once the next step is ready for Codex execution.

## Boundary Model

Keep a clear separation between:

- external control-surface rules in this document
- repo-local execution rules in the target repo's `AGENTS.md`
- runnable startup prompts used to attach ChatGPT or Codex
- explanatory docs that describe the workflow system
- examples that show how a project maps onto the model

Those categories are related, but they are not interchangeable.

## Repo Attachment Defaults

- expected local repo root: `[absolute local repo root]`
- canonical GitHub repo: `[owner/name]`
- default base branch: `[branch]`
- repo entry points to read first: `[README.md, AGENTS.md, docs/... ]`
- protected paths or constraints: `[constraints]`

## Execution Defaults

- verify repo attachment before meaningful work
- stop on mismatch
- report the exact working directory, git toplevel, origin remote URL, current branch, and working-tree state
- read repo-local files first after verification
- treat repo-local files as the source of truth for work inside the attached repo

## Default Repo-attachment Verification

Before meaningful Codex work, prompts should usually verify:

- `pwd`
- `git rev-parse --show-toplevel`
- `git branch --show-current`
- `git status --short`

If the prompt depends on a specific branch or clone, state the expected branch and expected repo root explicitly, then stop on mismatch rather than improvising.

## Branch Freshness Rule

When work should begin from current `main`, prefer:

1. switch or checkout `main`
2. `git fetch origin`
3. `git pull origin main`
4. show current `HEAD`
5. show a short recent log
6. branch from updated `main`

Prefer this refresh path when implementation is starting after planning, a previously used branch may be stale, or GitHub may have advanced since the last local action.

## Green-path Vs Recovery Mode

Use green-path mode when all of the following are true:

- same repo
- same task chain
- working tree was previously clean
- base branch is still `main`
- no branch-topology ambiguity
- no failed checkout, pull, ref-lock, or dirty-tree interruption since the last verified step

In green-path mode, ChatGPT should not restart the full verification ceremony on every normal step.

- when the repo, branch lineage, and working tree were already verified in the immediately preceding step, ChatGPT should use the smallest next prompt that is still safe
- after planning -> implementation from fresh `main`: full verification is still reasonable
- after implementation review -> review / write: compact verification is enough
- after explicit merge verification -> branch cleanup: compact cleanup prompt is enough
- compact review / write verification in the same task chain usually requires only:
  - `git branch --show-current`
  - `git status --short`
  - the requested test command or verification command for that step
- compact post-merge cleanup in the same task chain usually requires only:
  - `git fetch origin --prune`
  - `git checkout main`
  - `git pull origin main`
  - confirm the merged branch exists and is merged into `main`
  - delete the local merged task branch if present
  - delete the remote merged task branch if present
  - report final local and remote branch lists

Use recovery mode only when something failed or became ambiguous, including:

- branch mismatch
- dirty working tree
- failed checkout
- failed fast-forward
- ref-lock issue
- PR base/head mismatch
- ancestry ambiguity
- local branch not merged but possibly content-obsolete

Default to green-path compact prompts and escalate to recovery prompts only on explicit failure or ambiguity.

This split does not relax:

- PR-created vs merged distinction
- explicit base/head branch naming
- stopping on mismatch
- smallest-honest-scope discipline
- exact scoped diff + `git status --short` approval stop before commit, push, or PR creation

### Tiny-docs Green Path

Use tiny-docs green path when all of the following are true:

- docs-only
- one or two files maximum
- no code
- no architecture rewrite
- same repo
- same task chain
- no dirty-tree ambiguity except the intended file
- no branch-topology ambiguity

This is a rule-based classification. ChatGPT should not ask the user to decide when the scope is already clear.

- resume the existing task branch if it already contains the intended scoped work
- make the narrow docs or example change
- show the exact scoped diff and `git status --short`, then stop for explicit approval before commit, push, or PR creation
- after approval, produce the structured change summary and commit locally
- treat that local commit as the default content-complete state
- only continue into push, PR creation, or cleanup when transport is explicitly requested, operationally easy, or required by the task boundary
- do not recreate from `main` by default when the expected task branch already exists locally and the working tree contains only the intended scoped artifact
- use fresh-branch-from-`main` flow only when there is real ambiguity about branch state, scope, or lineage
- code or structural architecture work should use the stricter existing workflow
- tiny docs or example artifacts should use compact single-pass workflow when tiny-docs green-path conditions are met

## Phase Guidance

### Planning

- clarify goal, scope, constraints, and deliverable format
- prefer the smallest honest scaffold or change
- do not treat templates or examples as live policy unless the task explicitly says so
- identify which repo-local files are authoritative before proposing changes
- stop after the planning recommendation

### Implementation

- branch from the current base when the workflow calls for implementation
- keep changes scoped to one coherent intent
- show the exact diff and resulting repo state before final handoff when requested
- package the task so Codex knows the exact files, constraints, and expected verification output
- require exact scoped diff, `git status --short`, and stop before commit or push
- do not drift into write-stage language until the implementation result has been reviewed

### Review And Handoff

- keep durable repo truth in repo files
- keep migration framing and review context in a structured change summary
- keep comments for local clarification rather than policy storage
- state whether the handoff is planning-only, implementation, review, or PR-stage
- include commit message, structured change summary, and exact Codex prompt in review-stage output
- require one exact terminal state for every review-stage or PR-stage workflow:
  - `committed locally only`
  - `pushed branch only`
  - `compare page only`
  - `PR created`
  - `merged`
  - `merged branches cleaned up`
- When a PR path is intended and direct GitHub PR creation is available, prefer: commit, push, create the PR directly, report post-PR verification, and use terminal state `PR created`.
- Use `compare page only` as a fallback only when direct PR creation is unavailable, repo or tool context blocks it, or the user explicitly wants manual PR opening.
- do not report vague terminal states such as `opened PR workflow`, `done`, or `landed` unless the exact state is explicitly verified
- require PR title + PR description only when a PR path is actually being used
- require exact expected base branch + exact expected head branch for any PR-path handoff
- stop if the actual PR base/head differs from the expected base/head
- treat PR creation and merge as separate states
- report `merged` only after explicit verification
- if a PR path is not used, the same structured change summary should still appear in the Codex handoff or approval record before meaningful write actions complete
- after merge is explicitly verified, keep merged-branch cleanup available and recommended, but defer or batch it by default unless the user explicitly wants cleanup now or branch hygiene is operationally necessary
- prefer compact green-path review / handoff prompts first, and escalate to recovery prompts only on failure or ambiguity
- green-path and tiny-docs green-path reduce verification and GitHub ceremony, but they do not bypass the diff-approval checkpoint
- tiny-docs green-path work should not be split into separate high-ceremony phases for implementation, review, write, merge verification, and cleanup unless scope drift or ambiguity appears
- default tiny-docs flow:
  - resume the existing task branch if appropriate
  - make the narrow docs change
  - use the same exact scoped diff + `git status --short` approval stop before commit, push, or PR creation
  - after approval, produce the structured change summary
  - commit locally
  - stop at `committed locally only` unless transport is explicitly requested, operationally easy, or required by the task boundary
- stop early if:
  - multiple files changed unexpectedly
  - scope widened
  - wording became architecturally meaningful
  - branch state is ambiguous
  - the working tree is dirty beyond the intended docs artifact
- for same-thread, same-repo, same-task-chain tiny-docs work, full repo verification should happen once at task-chain start
- after that, compact checks are enough unless something failed:
  - current branch
  - `git status --short`
  - optionally `git fetch origin --prune` before PR creation or cleanup
- for tiny-docs green-path work, distinguish clearly between:
  - content completion: approved diff, structured change summary, and local commit
  - transport completion: push, compare page, PR creation, merge verification, or cleanup
- for tiny-docs green-path work, the structured change summary is the primary anti-drift artifact and local commit is the default completion boundary
- use transport only when it is explicitly requested, operationally easy, or required by the task boundary
- when transport is needed, prefer:
  - direct PR creation if available
  - otherwise `gh pr create` if available and authenticated
  - otherwise `compare page only`
  - otherwise defer transport
- require post-PR verification fields whenever Codex creates or updates a PR:
  - PR number
  - draft or ready state
  - actual base branch
  - actual head branch
  - mergeable state
  - PR URL

### Post-merge Cleanup

- if a task stopped at `committed locally only`, there is no merge or cleanup phase yet and ChatGPT should not invent one
- cleanup happens only after explicit merge verification
- never infer cleanup from:
  - `committed locally only`
  - `PR created`
  - `pushed branch only`
  - `compare page only`
  - `done`
  - `looks merged`
- after merge is explicitly verified, ChatGPT may provide an immediate ready-to-send Codex prompt to clean up the merged branch or branches, but cleanup does not need to become a separate conversational phase by default
- in the same repo and task chain, prefer a compact cleanup prompt first and escalate to recovery prompts only if checkout, pull, merge verification, or branch topology becomes ambiguous
- for tiny-docs green-path work, post-merge cleanup should be treated as best-effort tail work or deferred batch hygiene rather than a separate conversational phase
- surface cleanup as a separate step only if:
  - deletion fails
  - branch state is ambiguous
  - the local branch is content-obsolete but ancestry-unmerged
  - the working tree is dirty
  - checkout, pull, or ref state is blocked
- cleanup prompts must verify before deletion:
  - repo attachment again
  - refreshed `main`
  - branch merged into `main`
  - branch is not `main`
  - branch is not intentionally being kept
  - branch belongs to the verified attached repo
- cleanup actions must include:
  - delete local merged task branch if present
  - delete remote merged task branch if present
  - prune refs
  - show final local and remote branch state
- if multiple stale merged task branches exist, one cleanup pass may remove all of them, but merged-state verification must still be required per branch

## Merge Verification

Report `merged` only when merge has been explicitly verified.

PR creation, compare-page generation, or push completion do not count as merge verification.

If merge is expected, prompts should require Codex to verify that the branch landed on the intended base before reporting `merged`.

## Branch / State Discipline

- if the checked-out branch is not the intended one for the current task, stop and redirect to the correct branch workflow
- if a planning branch is active when implementation should begin, create a fresh implementation branch from updated `main`
- if the user says a branch, compare page, or PR has already been merged, prefer checking current `main` state before inferring what still needs to happen
- when merge history is messy, current `main` file content is the operational truth

## GitHub / Compare-url Discipline

When a PR path is intended, prompts should target the canonical GitHub repo and explicit expected base branch already named in the task framing.

If the actual PR base/head differs, stop and report the mismatch rather than continuing.

If a follow-up commit is added after a PR was already merged, treat the next step as a new small PR rather than as part of the already-merged PR.

## Scope Discipline

- prefer the smallest honest unit of work
- do not mix docs cleanup, architecture revision, and code changes unless that combined scope is deliberate and clearly justified
- do not invent broader abstractions when a local seam is enough

## Docs Vs Code Comments

- source comments = local truth
- docs = architectural truth
- structured change summaries and PR descriptions = change-specific framing

## Handoff Packaging

When sending work to Codex, package:

- repo root, canonical repo, and base branch
- task goal and success criteria
- exact files or artifact classes to inspect
- explicit constraints, protected paths, or out-of-scope areas
- expected diff, verification, and PR-stage output
- for PR-path handoff:
  - commit message
  - structured change summary
  - PR title
  - PR description
  - exact expected base branch
  - exact expected head branch
  - exact terminal state to report back
- include one explicit stacked-PR sentence:
  - `This PR is intentionally stacked on top of [branch] and should not target main yet.`
  - or `This PR must target main directly.`
- after explicit merge verification, keep cleanup available as follow-on work, but allow it to be deferred or batched by default unless cleanup is needed now
- for normal same-repo same-task-chain progress, prefer green-path compact prompts and reserve recovery prompts for checkout, pull, status, ancestry, or branch-topology failure or ambiguity
- tiny-docs green-path work should package the smallest safe single-pass handoff after approval
- this usually means:
  - current branch
  - `git status --short`
  - exact scoped diff
  - commit message
  - structured change summary
  - PR title and PR description if a PR path is used
  - explicit expected base and head
  - exact terminal state to report back
- compact workflow means compact verification and compact transport after approval, not automatic continuation past approval
- tiny-docs green-path work should not automatically be split into separate implementation and write handoffs unless ambiguity or scope drift appears

## Structured Change Summary

For meaningful repo updates, require a structured change summary with:

- why this change exists
- what changed
- what did not change
- what remains out of scope

## Branch Topology Recovery

Use these recovery defaults when branch topology drifts:

- if local `main` was accidentally fast-forwarded, stop and re-establish the intended feature branch before continuing PR work
- if a PR was opened against the wrong base, stop, restate the expected base/head, and correct the PR target before reporting success
- if a stacked seam needs clean integration back onto `main`, restate whether the branch should remain stacked or be rebased or merged for direct-to-main targeting before continuing

## Adaptation Notes

Adapt this artifact by filling the repo attachment defaults first, then replacing the project slots with repo-specific constraints and response expectations.

Keep repo-local execution rules in the target repo, and keep this artifact focused on external orchestration and handoff quality.

## Project Slots

Fill or adapt these project-specific fields when using this artifact:

- project-specific defaults: `[defaults]`
- protected paths or constraints: `[constraints]`
- required verification steps: `[checks]`
- preferred response format: `[format]`

## Short Version

In practice, the workflow should default to:

- green-path compact prompts for normal same-repo same-task-chain progress
- recovery prompts only when checkout, pull, status, ancestry, or branch topology fail or become ambiguous
- tiny-docs green path for tiny docs or example-only work in the same repo and task chain
- ready-to-send prompts rather than advice that still needs manual translation
- repo attachment verification before meaningful Codex work
- exact scoped diff + `git status --short` approval stop before commit, push, or PR creation
- full review-stage packaging when a write-stage handoff is needed
