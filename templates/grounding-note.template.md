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

## Post-Bootstrap Trim Pass

The grounding note often starts life before the target repo exists. During instantiation, it may carry repo-shape thinking, planned file inventory, "future repo" framing, and bootstrap-stage task sequencing — material that is appropriate before the repo exists and becomes fast-aging the moment the repo begins to own project truth.

Once initial bootstrap completes — repo created, `AGENTS.md` adopted, first repo-local docs in place — run a one-time trim pass on the canonical grounding note:

- Remove or relocate material that the repo now owns.
- Replace "future repo" language with references to the live repo.
- Move active planning-packet instructions, bootstrap-stage task sequencing, and current-state file inventory out of the grounding note (to operator-side scratch or to repo-local docs, as appropriate).
- Verify that what remains is durable source-of-intent, audience, philosophy, foundational premises, durable loose threads, voice / surface discipline, and advisor calibration.

Post-bootstrap-specific fast-aging red flags to look for during the trim:

- PR numbers, branch names, commit references
- "future repo" language after the repo exists
- active planning-packet instructions
- bootstrap-stage task sequencing or current / next-task material
- current repo file inventory used as state tracking (as distinct from pointer references to repo paths)
- repo-state chronology accumulated across the pre-repo phase

The trim pass is one-time at the bootstrap-to-operational transition. After it, normal "Refresh Triggers" (below) govern further changes. If the grounding note keeps needing trim passes between strategic refreshes, fast-aging material is leaking back in and the boundary between operator-side scratch and the grounding note needs attention.

## Versioning

Versioned grounding-note files (e.g. `grounding-note_vN.md`) are frozen historical snapshots. The canonical un-versioned mirror (`grounding-note.md`) is always equal to the latest version.

The version lives in the H1 title line (`# [project-name] // Grounding Note // v[N]`). The version claimed in the header must match the version in the filename. A header that claims a different version than its filename is a defect — fix it on the spot.

When the grounding note changes meaningfully:

1. Create the new versioned file (`grounding-note_v[N+1].md`), and set its H1 title version to match: `# [project-name] // Grounding Note // v[N+1]`.
2. Overwrite the canonical mirror (`grounding-note.md`) with the new version's contents, including the bumped H1.
3. Do not edit a versioned file in place.

## Refresh Triggers

Refresh the grounding note only when:

- a new strategic direction is adopted
- a philosophical reframing has occurred
- audience or positioning has shifted
- foundational premises have changed
- the operating model has changed (e.g. legacy Model A → single-node, or similar)

Do not refresh for routine repo chronology, recent PR activity, or session-specific context.

---

# [project-name] // Grounding Note // v[N]

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

`[operating model: single-node (Claude Code as control surface and executor) — default for new ASK projects — or legacy Model A (ChatGPT/Codex split). If single-node, name the live operator and any external advisors. If Model A, note why the project still runs on the legacy model.]`

## Sources Of Truth

- **Repo:** `[repo URL or path]` — project state, artifacts, decisions, current navigation
- **`AGENTS.md`** (in-repo) — workflow rules
- **This grounding note** (external) — repo-external context
- **Operator-side memory** — ephemeral session state (Claude Code's MEMORY.md, ChatGPT thread history, task lists); not durable, not promoted into the above

## Inbound Handoff TBI Marker

This project follows `method-ASK/docs/source-of-intent.md` §Inbound handoff TBI marker. Inbound handoff memos arriving in this project's external `sources of intent/` may carry a `-TBI.md` suffix as an ASK ingestion-state marker (to be ingested, not absorbed). The repo-local execution form lives in `AGENTS.md` §Inbound Handoff TBI Marker.

`[Optional: if this project has a domain-authority review surface that is grounded on this grounding note and pointed at the repo but lacks write access to the project's external folder, name the read-only-origin variant here. urban-observatory provides a worked example of this pattern in its grounding note.]`

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
