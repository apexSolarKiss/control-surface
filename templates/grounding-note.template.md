# Grounding Note Template

Use this as a starter for the **external** grounding note that travels with an ASK project. Replace bracketed `[...]` placeholders with project-specific values.

The grounding note lives outside the repo by design. It carries repo-external context that operators (Claude Code, Codex, ChatGPT, future-you) need before they can usefully act on the repo's project state. It is the slow-changing companion to the repo's fast-changing artifacts.

## What Belongs In The Grounding Note

- **Project intent** — what the project is trying to do and what it is explicitly not trying to do
- **Audience** — who this work is for; who reads its outputs; who needs to be able to operate it later
- **Philosophy** — the foundational stance the project is taking; the things treated as given
- **Foundational premises** — assertions the project is built on that are no longer up for re-derivation
- **Durable loose threads** — open questions or pressure points that span many conversations and have not yet been resolved by repo artifacts

## What Does NOT Belong In The Grounding Note

- **Per-conversation state** — what the current Claude Code thread is doing, what was decided in yesterday's session, what the next prompt should be. That belongs in operator-side memory (Claude Code's MEMORY.md, task lists, current chat) — not in the grounding note.
- **In-flight task tracking** — branch names, PR numbers, what's blocked on whom. That lives in the repo, in chat, or in a task list.
- **Recent activity logs** — what landed last week, which PRs merged. That lives in `git log` and PR history.
- **Workflow rules** — how the executor should branch, commit, verify, scope. That lives in repo-local `AGENTS.md`.
- **Project state** — current artifacts, current navigation, current milestone. That lives in the repo.

The grounding note ages slowly because it points to state and carries context. If you find yourself updating it weekly, something fast-aging has crept in and should move out.

## Versioning

Versioned grounding-note files (e.g. `grounding-note-vN.md`) are frozen historical snapshots. The canonical un-versioned mirror (`grounding-note.md`) is always equal to the latest version.

When the grounding note changes meaningfully:

1. Create the new versioned file (`grounding-note-v[N+1].md`).
2. Overwrite the canonical mirror (`grounding-note.md`) with the new version's contents.
3. Do not edit a versioned file in place.

## Refresh Triggers

Refresh the grounding note only when:

- a new strategic direction is adopted
- a philosophical reframing has occurred
- audience or positioning has shifted
- foundational premises have changed
- the operating model has changed (Model A → Model B, or similar)

Do not refresh for routine repo chronology, recent PR activity, or session-specific context.

---

# Grounding Note // [project-name]

**Version:** `[vN]` — `[YYYY-MM-DD]`

## Project Intent

`[2-4 paragraphs: what the project is trying to do and what it is explicitly not trying to do. Stable across many sessions.]`

## Audience

`[who this work is for; who reads outputs; who needs to be able to operate the project later]`

## Philosophy

`[the foundational stance the project takes; the framings treated as given. Not arguments — assertions.]`

## Foundational Premises

`[bulleted assertions the project is built on. These are no longer up for re-derivation in normal work. If a premise becomes contested, that is a refresh trigger.]`

- `[premise 1]`
- `[premise 2]`
- `[premise 3]`

## Operating Model

`[which operating model this project runs on: Model A (ChatGPT/Codex), Model B (Claude Code as control surface and executor), or either. If Model B, name the live operator and any external advisors.]`

## Sources Of Truth

- **Repo:** `[repo URL or path]` — project state, artifacts, decisions, current navigation
- **`AGENTS.md`** (in-repo) — workflow rules
- **This grounding note** (external) — repo-external context
- **Operator-side memory** — ephemeral session state (Claude Code's MEMORY.md, ChatGPT thread history, task lists); not durable, not promoted into the above

## Durable Loose Threads

`[open questions or pressure points that span many conversations and have not been resolved by repo artifacts. Each thread should describe the question and why it has not been closed yet. Threads that have been closed by repo artifacts should be removed, not retained for completeness.]`

- **`[thread title]`** — `[short description of what the open question is and why it's still open]`
- **`[thread title]`** — `[short description]`

## Out Of Scope For This Note

- per-conversation state (lives in operator-side memory)
- in-flight task tracking (lives in repo / chat / task list)
- recent activity logs (lives in `git log` and PR history)
- workflow rules (lives in repo-local `AGENTS.md`)
- project state (lives in the repo)
