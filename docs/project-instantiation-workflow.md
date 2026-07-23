# Project Instantiation Workflow

This doc explains the workflow before a target ASK repo exists, and how that upstream phase transitions into normal operational use.

It is agent-agnostic. The default operating model for new ASK projects is single-node (Claude Code as control surface and executor). The legacy split-execution model (ChatGPT/Codex with Claude Code as advisor — historically referred to as Model A) is retained for projects already running on it.

## Phases

### 1. Instantiation

Use this phase when the project is being defined and the target repo does not yet exist.

During instantiation:

- read whatever instantiation source pack exists (Project source pack in ChatGPT, conversation context in Claude Code, or both)
- use [`apexSolarKiss/control-surface`](../README.md) as the master reference repo
- use [`apexSolarKiss/asset-pipeline-ASK`](https://github.com/apexSolarKiss/asset-pipeline-ASK) as the single-node working example (default)
- use [`apexSolarKiss/mazeASK`](https://github.com/apexSolarKiss/mazeASK) as the legacy Model A working example (still active for that project)
- refine project purpose, repo name, repo description, and initial structure
- confirm the operating model — default to single-node unless the project has a specific reason to run on legacy Model A
- decide which assets should remain external versus which should eventually live in the repo
- decide where the external grounding note will live (path outside the repo)
- determine whether the project has a **domain authority** in a role distinct from the architect/operator — a person or role that supplies or validates binding judgment within a named domain; if so, it adopts the domain-authority review profile at bootstrap (see [`docs/domain-authority-review-protocol.md`](domain-authority-review-protocol.md))

At this point, there is no repo-local truth yet because the target repo does not exist. The instantiation prompt is `prompts/project-instantiation-initial-prompt.md`.

### 2. Bootstrap

Use this phase once the target repo exists and the first repo-local files can be established.

During bootstrap:

- verify the new repo attachment
- copy `templates/AGENTS.template.md` into the repo as `AGENTS.md` — the payload-free shell — and adapt its project-specific defaults (the local delta)
- resolve the shared execution protocol into that `AGENTS.md`: insert the shared body from `protocol/AGENTS.shared.md` verbatim between the shell's `BEGIN`/`END` shared markers, so each consumer resolves the block locally inside its own already-required `AGENTS.md` rather than holding a separate copy; then add the applicable `protocol/profiles/*.md` and any opt-in `protocol/fragments/*.md` (e.g. `protocol/fragments/standing-upstream-conformance-grant.md`). `protocol/manifest.json` is the normative registry of these pieces, and `protocol/check.sh` validates the resolved `AGENTS.md` locally (a deterministic local validator, not CI)
- copy `templates/grounding-note.template.md` into the external grounding-note location and fill in intent, audience, philosophy, foundational premises, and durable loose threads
- optionally copy `templates/architecture.template.md` into the repo as `docs/architecture.md`
- for any Claude-operated repo, copy `templates/CLAUDE.template.md` into the repo as `CLAUDE.md`. It is **required**, not optional: Claude Code reads `CLAUDE.md`, not `AGENTS.md`, so the adapter's `@AGENTS.md` import is what actually delivers the resolved carrier into context. Exactly one `@AGENTS.md` import; repo-specific Claude prose may follow it. Verify the new repo's adapter directly — `@AGENTS.md` occurs exactly once, repo-local `CLAUDE.md` prose is preserved, and a fresh session's `/context` receipt shows `AGENTS.md` imported. (`protocol/adapters/claude-code/check-claude-adapter.sh` is an **owner-side** check of control-surface's own adapter, template, and settings fragment; it does not run against a consumer repo)
- if the project profile is architecture-uncertain (ontology-first work, prototypes as pressure surfaces, deferred schema commitment, modeling-before-planning, ceremony-budget pressure), optionally adopt `templates/overlays/architecture-uncertain-rules.template.md` on top of the base `AGENTS.md`; skip when the task surface is known and the work is execution against it
- if the project has a domain authority distinct from the architect/operator (determined at instantiation), copy `templates/domain-authority-review-profile.template.md` into the project's operator-side surface and follow [`docs/domain-authority-review-protocol.md`](domain-authority-review-protocol.md) to keep the reviewer's authority, the project stage, and implementation authority independent, classify returned claims by stage, and route judgment to execution; skip when the project's source of intent is authored entirely by the architect/operator
- identify the first repo-local entry points
- run the post-bootstrap grounding-note trim pass per `templates/grounding-note.template.md` once the repo carries project truth — remove or relocate fast-aging material (repo-state chronology, planning-packet instructions, "future repo" language, bootstrap-stage task sequencing) that the pre-repo grounding note may have accumulated

This is the phase where repo-local truth begins to exist. The transition prompt is:

- `prompts/claude-code-initial-prompt.md` for the default single-node model (Claude Code as control surface and executor)
- `prompts/control-surface-initial-prompt.md` and `prompts/codex-initial-prompt.txt` for legacy Model A (retained for projects already running on it)

### 3. Operational

Use this phase once the target repo has active repo-local docs and normal work can proceed.

During operational use:

- treat repo-local files as the source of truth for work inside the repo
- treat the external grounding note as the source of truth for repo-external context
- use prompts for startup or handoff, not as permanent repo policy
- treat per-conversation state (ChatGPT thread history, task lists, in-flight session context) as ephemeral — do not promote it into the durable sources
- treat Claude Code auto memory (`MEMORY.md` and its topic files) as a **non-authoritative, read-mostly operator cache** — persistent, not ephemeral, never a durable owner, and every mutation governed by `AGENTS.md` §Learning Disposition and §Private-Memory Write Gate
- when an external advisor surface is used (GPT or Claude in chat form):
  - create `<project-name>-EXTERNAL/_INDEX-<project-name>.md` from `templates/_INDEX-project.template.md` — a **source index / path map** listing the project's canonical Dropbox paths, their status classes, and the wall rules (use `_INDEX-<project-name>-<role>.md` for role-specific advisor surfaces); then **mount that index** as the advisor Project's **primary Source** — *mount the map, not copies of the canonicals* (the advisor fetches canonicals live from Dropbox by exact path; any mounted canonical copies are fallback only). When the project's `AGENTS.md` resolves the shared execution protocol, the index **must** carry the template's *Shared execution-protocol architecture* rows — owner model, shared body, normative manifest, propagation runbook, and, where the surface is authorized to read it, the live protocol-consumer ledger; the advisor preflight requires those files, so an index without the rows leaves the advisor no route to them. Skip the index for a project with no advisor surface.
  - adapt `templates/advisor-project-instructions.template.md` and install it once into the advisor Project Instructions — not pasted per thread (see `docs/critique-protocol.md`); the instructions point at the mounted index as the first read; the grounding-note canonical lives at the `-EXTERNAL` root
- when the project will use the advisor / nudge / critique surfaces, adapt the protocol repo's reusable nudge prompt (`prompts/repo-nudge-prompt.md`) and the repo critique cycle prompts (`prompts/repo-critique-initial-prompt.md`, `prompts/repo-critique-synthesis-prompt.md`, `prompts/repo-critique-execution-prompt.md`) into project-flavored operator-side copies in `<project-name>-EXTERNAL/sources of intent/`; the protocol repo's prompts remain canonical, the operator-side copies are project-flavored adaptations

## What Stays External

Keep these external unless a project has a deliberate reason to mirror them:

- the grounding note (always external, by design)
- advisor Project Instructions and the mounted source index / path map, when an external advisor surface (GPT or Claude in chat form) is used
- startup prompts used to frame or hand off work

## What Usually Becomes Repo-Local

Once the repo exists, these are typical local candidates:

- `AGENTS.md` (always)
- `CLAUDE.md` adapter (required for Claude-operated repos; imports `AGENTS.md`)
- a project architecture doc
- project-specific entry-point docs

## Practical Output

The normal output of instantiation is not code yet.

It is a ready-to-send next prompt that can:

- create or attach the target repo
- copy and adapt the relevant templates
- begin bootstrap using the agreed project purpose, structure, and operating model
