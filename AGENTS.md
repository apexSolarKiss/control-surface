# AGENTS.md

This file defines repo-local workflow rules for whoever executes work on this `control-surface` execution-protocol repo.

The operating model is single-node: Claude Code is both control surface and executor.

An earlier split-execution model — ChatGPT as prompt compiler, Codex as executor, Claude Code as optional advisor (referred to historically as **Model A**) — shaped this repo's design and is retained as legacy reference. It is no longer active here. `apexSolarKiss/mazeASK` is the retained legacy Model A reference (currently dormant) — the working example for any project that still needs that model.

The rules below are agent-agnostic — they apply to whoever is executing.

For repo-external context (project intent, audience, philosophy, foundational premises, durable loose threads), read the grounding note maintained outside this repository.

For project state (artifacts, decisions, current navigation), read the repo itself.

This file owns workflow rules. It does not track project state, current direction, or recommended next paths.

---

## Source-of-Truth Boundaries

- **Repo** = project truth: artifacts, docs, templates, examples, decisions.
- **`AGENTS.md`** (this file) = workflow rules for repo execution.
- **Grounding note** (external) = repo-external context: intent, audience, philosophy, foundational premises, durable loose threads.
- **Per-conversation memory** (operator-side: Claude Code's MEMORY.md, ChatGPT thread history, task lists) = ephemeral session state that does NOT belong in the grounding note.

### Aging-Rate Principle

The split between repo, `AGENTS.md`, grounding note, and per-conversation memory is not just separation of concerns — it is separation by *aging rate*.

- A doc that *tracks state* ages fast and must be refreshed often.
- A doc that *points to state* ages slowly and stays useful across many sessions.
- A rules doc that contains rules only ages slowly.
- A context doc that contains context only ages slowly.
- A doc that mixes rules, context, and state ages at the rate of its fastest-aging contents — usually badly.

If a statement would become stale when a PR lands, a chain closes, or a next path changes, it does not belong in this file or in the grounding note.

---

## Required Reading Before Meaningful Work

Before any meaningful repo work, read:

- `README.md`
- `AGENTS.md` (this file)
- `docs/architecture.md`

Then read whatever templates, prompts, examples, or legacy docs are relevant to the task.

For external context, read the grounding note.

---

## Inbound Handoff TBI Marker

When an inbound handoff memo in `control-surface-EXTERNAL/sources of intent/` carries the `-TBI.md` suffix, treat the suffix as ASK ingestion-state only: to be ingested, not to be absorbed. When ASK feeds that memo into the active surface, the first action is to rename the file in place to remove `-TBI`; do not edit the memo body. Then classify the memo and record any absorption / hold / rejection in a separate scratch derivative under `control-surface-EXTERNAL/scratch/`. Copy + suffix do not authorize implementation.

Method-altitude articulation: `method-ASK/docs/source-of-intent.md` §Inbound handoff TBI marker.

---

## Cross-Surface Change Routing

Before choosing direct operation or `-TBI` routing, classify both the change's authority and the surface's write jurisdiction.

- **Candidate source-of-intent, project-specific direction, or other material whose recipient must classify** → preserve the origin record, route a recipient copy through `sources of intent/` with `-TBI`, and let the recipient surface own ingestion and absorption.
- **ASK-authorized conformance to a protocol owned upstream** → propagate directly only where the active surface has write jurisdiction over the consumer. Apply the change through the consumer repo's own branch, diff, PR, review, and merge gates. Do not create a `-TBI` handoff merely to carry an already-authoritative protocol update.
- **No direct write jurisdiction** → route to the owning surface even when the upstream protocol is authoritative. Protocol ownership does not pierce a wall, create a grant, or bypass a surface boundary.

Write jurisdiction may be standing or explicitly granted by ASK for the scoped conformance change. Neither protocol ownership, connector capability, nor this rule itself creates write jurisdiction over another surface.

Direct propagation authorizes only the scoped conformance change. It does not authorize unrelated changes to the consumer's project truth, architecture, source of intent, or implementation.

Method-altitude articulation: `method-ASK/docs/source-of-intent.md` §Scope guard: handoff routing vs protocol conformance.

---

## Repo Workflow Discipline

### Session-Start Discipline

Before any new repo work in a session:

1. Confirm the working directory is the session-owned worktree. Cross-worktree absolute paths are a known failure surface; verify before any edit, write, or cross-root `git -C` command.
2. Verify `HEAD` is attached to a named branch. Detached `HEAD` is a stop condition.
3. Verify the working tree is clean.
4. If the working tree is not clean, stop. Identify whether the changes belong to the current thread before touching anything. Inheriting another thread's uncommitted state is a stop condition until provenance is established.

This does not replace Branch Freshness or Default Verification. It is the session-entry gate before meaningful repo work begins.

### Branch Freshness

For repo implementation work, follow this sequence:

1. verify local repo attachment
2. verify clean working tree
3. `git fetch origin --prune`
4. `git checkout main`
5. `git pull --ff-only origin main`
6. create task branch from refreshed `main`
7. stop if any verification fails

Do not start meaningful repo work from a stale, dirty, detached, or ambiguous branch.

### Default Verification

Before meaningful work, verify:

```text
pwd
git rev-parse --show-toplevel
git remote get-url origin
git branch --show-current
git status --short
```

Stop if repo root, remote, branch, or working tree does not match the task requirements.

### Terminal-State Discipline

Do not conflate:

- local edits
- exact scoped diff
- local commit
- pushed branch
- PR created
- merged PR
- branch cleanup

Use explicit terminal states:

```text
exact scoped diff ready for approval
committed locally only
pushed branch only
PR created
merged
merged branches cleaned up
```

### Explicit Artifact-Lifecycle Verbs

Do not use `cut` as an operation verb for drafts, changes, files, versions, snapshots, handoffs, releases, or other artifacts. It is ambiguous between creation and destruction.

Name the actual operation instead: draft, write, revise, save, create a version, create a snapshot, copy at byte parity, rename, route, supersede, retire, or delete.

This rule applies to plans, instructions, handoffs, change summaries, and status reports. Historical quotations, provenance records, frozen artifacts, and unambiguous domain terms such as a film's rough cut are not rewritten solely to enforce it.

### Exact Scoped Diff Gate

Stop at exact scoped diff unless ASK has already approved commit / push / PR.

The default implementation terminal state is:

```text
exact scoped diff ready for approval
```

Exact scoped diff review is the mandatory approval checkpoint before meaningful write actions complete. Approval may be given inside the executor session after the diff is reviewed; once given, the executor may complete the remaining git workflow without separate manual GitHub UI ceremony.

### Structured Change Summary

Meaningful changes require a structured change summary covering:

- why this change exists
- what changed
- what did not change
- what remains out of scope

If a PR is used, this belongs in the PR description. If no PR is used, the same summary must be produced in the executor handoff or approval record before write actions complete.

### PR Creation

When creating a PR, report:

- branch name
- commit SHA
- PR number
- PR URL
- actual base branch
- actual head branch
- validation performed
- terminal state: `PR created`

### Default: Hold or Carry Through Per Adversarial-Collaboration Preconditions

When ASK has approved the scoped diff, the workflow continues through commit and push to PR creation.

If the project meets the preconditions for adversarial collaboration (per [*Adversarial Collaboration*](https://atomicspacekitten.substack.com/p/adversarial-collaboration)) — hardened backbone, active architectural uncertainty, configured advisor surface — hold at `PR created` until the advisor relay returns approval, then continue to merge. The pushed-not-merged PR is the advisor's structural review window.

ASK forwarding an advisor approval to the executor is the relay. Forwarding may be done by pasting the advisor's approval, summary, or equivalent review result. No additional approval phrase is required after the forwarding act.

Forwarding advisor notes that contain required fixes, blocking concerns, or open questions is not approval relay; it is fix-direction or question-forwarding.

If no advisor surface is configured, carry through to merged + cleanup once diff approval is given. The pattern is proportional to architectural uncertainty live at any moment.

### Post-Merge Cleanup

After merge, verify `main`, delete merged task branches where safe, verify remote branch state, and report:

- current main HEAD
- whether merge commit is present
- whether expected changes are present
- local branch cleanup
- remote branch cleanup
- final branches
- final working tree status
- terminal state: `merged branches cleaned up`

### Direct Push to Main

Branch plus PR is the default for meaningful structure or rule changes. Narrow low-risk edits or explicitly scoped bootstrap tasks may allow direct push to `main` when scope is made explicit and approved.

---

## Session Topology / Single-Writer Discipline

Multiple operator sessions (multiple Claude Code threads, parallel Codex sessions, ChatGPT thread plus Codex thread) can mutate the same repo files concurrently. This is a real failure mode, not a hypothetical.

Rules:

- **One writer at a time per branch.** A second operator session on the same branch must verify state freshly, treat the working tree as authoritative over its own memory, and not assume mid-flight context from another session.
- **Treat repo and remote as the audit trail.** When two sessions disagree about state, prefer `git status`, `git log`, and remote-branch state over either session's recollection.
- **Stop on suspected concurrent mutation.** If a working tree contains changes the current session did not make, do not overwrite. Re-orient against the repo before continuing.

This rule applies whether the second session is the same agent, a different agent, or a human editor.

---

## Scope Discipline

Match the unit of work to the level of the question.

For implementation and repo hygiene, prefer the smallest honest unit. Small bounded PRs are usually best. Avoid bundling, widening, or design-in-advance.

For conceptual architecture, prefer the largest tractable structural question. The smallest honest unit at the architecture layer is often a structural question or a model attempt against a concrete example, not another local prototype probe.

Do not let "smallest unit" become a rule that prevents zooming out to the right scale. A series of small honest units at the wrong layer can add up to ceremony without architectural progress.

Do not bundle unrelated work.

Do not widen scope mid-task unless the widening is explicitly chosen.

Do not create artifacts merely because a process pattern exists.

---

## Plan-Before-Execute Rule

Before executing a meaningful repo change, state the plan: what files will change, what scope is in vs out, what non-actions apply, what terminal state is expected.

This applies whether the executor is a separate process (Codex) or the same agent doing the planning (Claude Code).

The plan-before-execute step preserves the explicit reasoning surface that prompt-compilation provides when execution is split across a prompt-compiler and an executor. In a single-node model, plan-before-execute is the rule that restores it. Do not collapse plan and execution into a single opaque step.

---

## Why These Rules Exist

The single-node model collapses several functions that the earlier split-execution model (Model A) handled by default. Most of the rules above are calibrated compensations for what gets lost when a single agent is both compiler and executor:

- A split model has a natural prompt-compilation step (ChatGPT framing work for Codex). A single-node model collapses it into the executor. **Plan-Before-Execute** is the rule that restores the reasoning surface.
- A split model has natural model separation, which surfaces disagreements as visible artifacts. A single-node model runs in one head, so disagreements become invisible. **Structured Change Summary** and **exact-scoped-diff approval** are the rules that compensate.
- A single-node model has stronger session-topology pressure (Claude Code easily spawns parallel threads). **Single-Writer Discipline** is the compensation.

When proposing rule changes, ask which failure mode the rule is compensating for and whether the compensation is still load-bearing.

---

## Comments, Docs, and PR Roles

- Comments belong in implementation artifacts only when local clarity needs them.
- Docs describe architecture, boundaries, operating contracts, and reusable guidance.
- Structured change summaries and PR descriptions hold change-specific framing.

Do not push PR-only explanation into permanent repo docs, and do not hide durable operating rules inside a PR or approval record.

---

## Refresh Cadences

### `AGENTS.md`

Refresh this file only when a workflow rule is added, removed, or materially revised.

Do not refresh because project state changed.
Do not refresh because a PR landed.
Do not refresh because the next direction changed.

If a proposed update says "the project currently should do X," it does not belong in this file.

### Templates

Refresh `templates/` only when the corresponding live rule has changed and the change is intended to flow to downstream ASK projects.

A rule that lives in this repo's `AGENTS.md` but is project-specific to control-surface itself does not need to flow to the templates.

### Legacy Docs

Legacy docs (Model-A-specific control-surface artifact, workflow-boundary doc, ChatGPT/Codex-specific prompts) are not refreshed. They are kept as historical reference for the operating model they documented.

---

## Defaults

- Prefer ASK reuse over world-scale abstraction.
- Prefer explicit structure over clever indirection.
- Prefer updating root docs and a small set of templates over adding systems around them.
- Prefer the smallest coherent scaffold that clarifies the workflow boundary.
- Tailor docs to this repo's job as an execution-protocol repo. Do not write as if this repo were an application repo.
- Use clean technical language. Avoid manifesto phrasing, speculative systems, or generic process bloat.

---

## Short Version

- Verify repo state before meaningful work.
- Read repo-local truth and grounding note before responding.
- Stop at exact scoped diff before commit; carry through to merged + cleanup once approved.
- State the plan before executing.
- Single-writer per branch. Treat repo as audit trail.
- Match the unit of work to the level of the question.
- Refresh `AGENTS.md` only for rule changes; refresh templates only for downstream-relevant rule changes.
- Keep this file workflow-only. Repo holds state. Grounding note holds external context.
