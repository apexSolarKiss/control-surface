# AGENTS Template

Use this as a starter for `AGENTS.md` in a downstream ASK repo.

This template is agent-agnostic. Whoever executes (Codex, Claude Code, or another agent) follows the same rules. Replace bracketed `[...]` placeholders with project-specific values.

---

# AGENTS.md

This file defines repo-local workflow rules for whoever executes work on this repository.

It applies to both supported operating models:

- **Model A:** ChatGPT compiles prompts, Codex executes inside the repo, Claude Code is optional advisor.
- **Model B:** Claude Code is the single control surface and executor, GPT is optional advisor.

The same rules apply regardless of which agent does the executing.

For repo-external context (project intent, audience, philosophy, foundational premises, durable loose threads), read the grounding note maintained outside this repository.

For project state (artifacts, decisions, current navigation), read the repo itself.

This file owns workflow rules. It does not track project state, current direction, or recommended next paths.

---

## Source-of-Truth Boundaries

- **Repo** = project truth: artifacts, decisions, findings, architecture docs, navigation.
- **`AGENTS.md`** (this file) = workflow rules for repo execution.
- **Grounding note** (external) = repo-external context: intent, audience, philosophy, foundational premises, durable loose threads.
- **Per-conversation memory** (operator-side: Claude Code's MEMORY.md, ChatGPT thread history, task lists) = ephemeral session state that does NOT belong in the grounding note.
- `[project-specific live truth surfaces, e.g. a database, an external service, direct visual evidence]`

### Aging-Rate Principle

The split is separation by *aging rate*. A doc that tracks state ages fast; a doc that points to state ages slowly. If a statement would become stale when a PR lands, a chain closes, or a next path changes, it does not belong in this file or in the grounding note.

---

## Required Reading Before Meaningful Work

Before any meaningful repo work, read:

- `README.md`
- `AGENTS.md` (this file)
- `[primary architecture doc]`
- `[repo-specific entry-point doc]`

Then read the latest milestone or finding artifact relevant to the task.

For external context, read the grounding note.

---

## Repo Workflow Discipline

### Branch Freshness

For repo implementation work, follow this sequence:

1. verify local repo attachment
2. verify clean working tree
3. `git fetch origin --prune`
4. `git checkout main`
5. `git pull --ff-only origin main`
6. create task branch from refreshed `main`
7. stop if any verification fails

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

Use explicit terminal states:

```text
exact scoped diff ready for approval
committed locally only
pushed branch only
PR created
merged
merged branches cleaned up
```

### Exact Scoped Diff Gate

Stop at exact scoped diff unless ASK has already approved commit / push / PR. Once approved in the executor session, the executor may complete the remaining git workflow without separate manual GitHub UI ceremony.

### Structured Change Summary

Meaningful changes require:

- why this change exists
- what changed
- what did not change
- what remains out of scope

If a PR is used, this belongs in the PR description. If no PR is used, the same summary belongs in the executor handoff or approval record.

### Default: Carry Through to Merged + Cleanup

When ASK approves the scoped diff and there is no explicit batching reason, carry through commit → push → PR → merge → branch cleanup. Do not stop at "PR created" and ask whether to merge unless the PR is intentionally queued, stacked, or under external review.

### PR Creation

When creating a PR, report: branch name, commit SHA, PR number, PR URL, actual base branch, actual head branch, validation performed, terminal state.

### Direct Push to Main

Branch plus PR is the default for meaningful structure or rule changes. Narrow low-risk edits or explicitly scoped bootstrap tasks may allow direct push to `main` when scope is made explicit and approved.

---

## Session Topology / Single-Writer Discipline

Multiple operator sessions can mutate the same repo files concurrently. Rules:

- One writer at a time per branch.
- Treat repo and remote as the audit trail when sessions disagree.
- Stop on suspected concurrent mutation. Re-orient against the repo before continuing.

---

## Scope Discipline

For implementation, prefer the smallest honest unit. For conceptual architecture, prefer the largest tractable structural question. Do not let "smallest unit" prevent zooming out to architecture scale.

Do not bundle unrelated work. Do not widen scope mid-task unless explicitly chosen. Do not create artifacts merely because a process pattern exists.

---

## Plan-Before-Execute Rule

Before executing a meaningful repo change, state: files in scope, scope in vs out, non-actions, expected terminal state.

This applies whether the executor is a separate process (Codex) or the same agent doing the planning (Claude Code). The plan-before-execute step preserves the explicit reasoning surface that prompt-compilation provides in Model A.

---

## Comments, Docs, and PR Roles

- Comments belong in implementation artifacts only when local clarity needs them.
- Docs hold durable repo-local truth, boundary definitions, and architecture framing.
- PRs hold change-specific explanation, reviewer guidance, tradeoffs.

---

## Project-Specific Defaults

Fill in local expectations here:

- `[testing or verification commands]`
- `[protected paths or high-risk areas]`
- `[external systems with their own mutation discipline, e.g. a live database, a CMS, a workflow tool]`
- `[terminology to preserve]`
- `[domain-specific creative or governance acts that should be modeled as first-class — see Architecture-Specific Rules below]`

---

## Architecture-Specific Rules (optional, project-by-project)

If the project's information architecture has a load-bearing creative or governance act (e.g. curation, capture, ratification, selection), model it as first-class in the schema and in the rules. Generic process rules cannot stand in for domain-specific structural decisions.

If the project has a prototype surface, decide whether the prototype is a pressure surface for studying the architecture or a deliverable in its own right. Document the answer.

If the project has external systems (databases, CMSs, workflow tools), decide how mutations to those systems are governed (Plan-Before-Execute applies; Structured Change Summary applies; per-action authorization may or may not be required depending on reversibility).

---

## Refresh Cadences

### Grounding Note

Refresh the grounding note only when external handoff context changes:

- new strategic direction
- philosophical reframing
- audience or positioning shift
- foundational premises change
- operating model changes

Do not refresh for routine repo chronology. Possible future directions belong in the grounding note only as durable loose threads, not as recommended next paths.

### `AGENTS.md`

Refresh this file only when a workflow rule is added, removed, or materially revised.

Do not refresh because project state changed. Do not refresh because a PR landed. Do not refresh because the next direction changed.

---

## Short Version

- Verify repo state before meaningful work.
- Read repo-local truth and grounding note before responding.
- Stop at exact scoped diff before commit; carry through to merged + cleanup once approved.
- State the plan before executing.
- Single-writer per branch. Repo is the audit trail.
- Match unit of work to level of question.
- Keep this file workflow-only. Repo holds state. Grounding note holds external context.
