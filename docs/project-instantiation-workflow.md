# Project Instantiation Workflow

This doc explains the workflow before a target ASK repo exists, and how that upstream phase transitions into normal operational use.

It is agent-agnostic. ASK projects run the **adversarial-collaboration operating model** — an ASK-apexed advisor–executor topology: ASK as the source-of-intent and authorization apex, a non-writing advisor surface, and a repo-attached execution surface (currently a GPT advisor and Claude Code as executor; model identity is operational, not architectural). **Direct execution** — ASK driving the executor without an advisor pass where a separate pass would not materially reduce uncertainty — is a bounded variant within that model, not a separate model. The earlier split-execution model (ChatGPT as prompt compiler, Codex as executor, Claude Code as optional advisor — historically **Model A**) is retired as a live option and is not offered to any project. See [`README.md`](../README.md) §Operating Model and [`docs/architecture.md`](architecture.md).

## Phases

### 1. Instantiation

Use this phase when the project is being defined and the target repo does not yet exist.

During instantiation:

- read whatever instantiation source pack exists (Project source pack in ChatGPT, conversation context in Claude Code, or both)
- use [`apexSolarKiss/control-surface`](../README.md) as the master reference repo
- use [`apexSolarKiss/asset-pipeline-ASK`](https://github.com/apexSolarKiss/asset-pipeline-ASK) as the primary working example
- refine project purpose, repo name, repo description, and initial structure
- confirm the advisor configuration — the operating model is not a per-project choice. Record whether an external advisor surface is configured, who occupies it, and which classes of work trigger advisor review. Direct execution is a bounded task-level path and remains available even when an advisor surface is configured
- decide which assets should remain external versus which should eventually live in the repo
- decide where the external grounding note will live (path outside the repo)
- determine whether the project has a **domain authority** in a role distinct from the architect/operator — a person or role that supplies or validates binding judgment within a named domain; if so, it adopts the domain-authority review profile at bootstrap (see [`docs/domain-authority-review-protocol.md`](domain-authority-review-protocol.md))

At this point, there is no repo-local truth yet because the target repo does not exist. The instantiation prompt is `prompts/project-instantiation-initial-prompt.md`.

### 2. Bootstrap

Use this phase once the target repo exists and the first repo-local files can be established.

During bootstrap:

- verify the new repo attachment
- create the project's external surface with its four planes, per the setup step in `README.md`:

  ```text
  <project-name>-EXTERNAL/
    <project-name>_grounding-note.md   # canonical durable context (root)
    scratch/                            # _vN snapshots + iteration
    intent-carriers/                    # standing + invocable carrier canonicals (unversioned)
      ZZZ/                              #   frozen _vN snapshots + retired / historical carrier lineage
    intent-INbox/                       # inbound routed handoffs, under the filename lifecycle
      _STATE.md                         #   structural inbox state — not routed intent
  ```

  A newly instantiated `_STATE.md` begins as `OPEN` — no additional inbox hold, ordinary governed ingestion may proceed. Its full schema and the structural-exemption contract are owned by `docs/advisor-project-surface-architecture.md` (LIFE-4g) and stated operationally in `templates/advisor-project-bootstrap.template.md` and `templates/_INDEX-project.template.md` — do not restate them here.

  In `intent-carriers/`, the unversioned current canonical mirrors the latest accepted `_vN`; `ZZZ/` holds the frozen `_vN` snapshots and any retired or historical carrier variants. **A prior `_vN` is historical, not superseded** — carrier families are revised, retired, or replaced, and existing legacy filenames are preserved unchanged. Adapted prompts and other invocable carriers go in `intent-carriers/`; routed handoffs from another operating surface go in `intent-INbox/`, and never the reverse.
- copy `templates/AGENTS.template.md` into the repo as `AGENTS.md` — the payload-free shell — and adapt its project-specific defaults (the local delta)
- resolve the shared execution protocol into that `AGENTS.md`: insert the shared body from `protocol/AGENTS.shared.md` verbatim between the shell's `BEGIN`/`END` shared markers, so each consumer resolves the block locally inside its own already-required `AGENTS.md` rather than holding a separate copy; then add the applicable `protocol/profiles/*.md` and any opt-in `protocol/fragments/*.md` (e.g. `protocol/fragments/standing-upstream-conformance-grant.md`). `protocol/manifest.json` is the normative registry of these pieces, and `protocol/check.sh` validates the resolved `AGENTS.md` locally (a deterministic local validator, not CI)
- copy `templates/grounding-note.template.md` into the external grounding-note location and fill in intent, audience, philosophy, foundational premises, and durable loose threads
- optionally copy `templates/architecture.template.md` into the repo as `docs/architecture.md`
- for any Claude-operated repo, copy `templates/CLAUDE.template.md` into the repo as `CLAUDE.md`. It is **required**, not optional: Claude Code reads `CLAUDE.md`, not `AGENTS.md`, so the adapter's `@AGENTS.md` import is what actually delivers the resolved carrier into context. Exactly one `@AGENTS.md` import; repo-specific Claude prose may follow it. Verify the new repo's adapter directly — `@AGENTS.md` occurs exactly once, repo-local `CLAUDE.md` prose is preserved, and a fresh session's `/context` receipt shows `AGENTS.md` imported. (`protocol/adapters/claude-code/check-claude-adapter.sh` is an **owner-side** check of control-surface's own adapter, template, and settings fragment; it does not run against a consumer repo)
- if the project profile is architecture-uncertain (ontology-first work, prototypes as pressure surfaces, deferred schema commitment, modeling-before-planning, ceremony-budget pressure), optionally adopt `templates/overlays/architecture-uncertain-rules.template.md` on top of the base `AGENTS.md`; skip when the task surface is known and the work is execution against it
- if the project has a domain authority distinct from the architect/operator (determined at instantiation), copy `templates/domain-authority-review-profile.template.md` into the project's operator-side surface and follow [`docs/domain-authority-review-protocol.md`](domain-authority-review-protocol.md) to keep the reviewer's authority, the project stage, and implementation authority independent, classify returned claims by stage, and route judgment to execution; skip when the project's source of intent is authored entirely by the architect/operator
- identify the first repo-local entry points
- run the post-bootstrap grounding-note trim pass per `templates/grounding-note.template.md` once the repo carries project truth — remove or relocate fast-aging material (repo-state chronology, planning-packet instructions, "future repo" language, bootstrap-stage task sequencing) that the pre-repo grounding note may have accumulated

This is the phase where repo-local truth begins to exist. The transition prompt is `prompts/claude-code-initial-prompt.md` — executor-side bootstrap under the current operating model.

The retired Model-A prompt pair (`prompts/control-surface-initial-prompt.md`, `prompts/codex-initial-prompt.txt`) remains in the repo as frozen historical provenance. It is not a bootstrap path.

### 3. Operational

Use this phase once the target repo has active repo-local docs and normal work can proceed.

During operational use:

- treat repo-local files as the source of truth for work inside the repo
- treat the external grounding note as the source of truth for repo-external context
- use prompts for startup or handoff, not as permanent repo policy
- treat per-conversation state (ChatGPT thread history, task lists, in-flight session context) as ephemeral — do not promote it into the durable sources
- treat Claude Code auto memory (`MEMORY.md` and its topic files) as a **non-authoritative, read-mostly operator cache** — persistent, not ephemeral, never a durable owner, and every mutation governed by `AGENTS.md` §Learning Disposition and §Private-Memory Write Gate
- when an external advisor surface is used (GPT or Claude in chat form):
  - create `<project-name>-EXTERNAL/_INDEX-<project-name>.md` from `templates/_INDEX-project.template.md` — a **source index / path map** listing the project's canonical Dropbox paths, their status classes, and the wall rules (use `_INDEX-<project-name>-<role>.md` for role-specific advisor surfaces). It is **fetched live** at the locator the bootstrap declares, not mounted; the advisor fetches canonicals live from Dropbox by exact path, and any mounted copies are connector-failure fallback only. When the project's `AGENTS.md` resolves the shared execution protocol, the index **must** carry the template's *Shared execution-protocol architecture* rows — owner model, shared body, normative manifest, propagation runbook, and, where the surface is authorized to read it, the live protocol-consumer ledger; the advisor preflight requires those files, so an index without the rows leaves the advisor no route to them. Skip the index for a project with no advisor surface.
  - generate the surface bootstrap from `templates/advisor-project-bootstrap.template.md` and mount it as the advisor Project's **single standing Source**; install the thin pre-bootstrap floor from `templates/advisor-project-instructions.template.md` once into the Project Instructions — not pasted per thread (see `docs/critique-protocol.md`). The Instructions floor points at the mounted bootstrap as the first read; the bootstrap points at the live index; the grounding-note canonical lives at the `-EXTERNAL` root. Placement contract and acceptance tests: `docs/advisor-project-surface-architecture.md`.
  - **for exact-byte advisor review**, the normal repo review object is the **pushed PR**; an executor summary — including an `exact scoped diff ready for approval` report — does not implicitly open pre-PR advisor review, which happens **only on explicit ASK request**. Where ASK does request it, the executor publishes a named `-PROPOSED` review object — or, when a target is not representable as a text patch, a declared review bundle (ordered exact-object or patch parts, one per target, each hashed) — to the project's **mapped shared scratch** (`<project-name>-EXTERNAL/scratch/`), reporting its exact path, baseline, byte size, and SHA-256; a reported review object is immutable and a revision takes a new `-PROPOSED` name. **Retrieval order: exact path → raw bytes → one bounded alternate representation.** Resolving the path proves reachability, not fidelity — extracted text, previews, and normalized views are inspection representations, and **path metadata or a lossy view is not exact-byte availability**. Do not use ASK as a byte courier while exact bytes remain retrievable through the mapped route; **manual operator upload is fallback only** after both rungs have failed and been reported and ASK explicitly elects it, for content already authorized to the advisor, and never to cross a wall (`AGENTS.md` §Advisor-Readable Review Objects; advisor bootstrap §Verification; `_INDEX` scratch row)
- when the project will use the advisor / nudge / critique surfaces, adapt the protocol repo's reusable nudge prompt (`prompts/repo-nudge-prompt.md`) and the repo critique cycle prompts (`prompts/repo-critique-initial-prompt.md`, `prompts/repo-critique-synthesis-prompt.md`, `prompts/repo-critique-execution-prompt.md`) into project-flavored operator-side copies in `<project-name>-EXTERNAL/intent-carriers/` — an adapted prompt is an invocable carrier, not a routed handoff, so it never lands in the intent inbox and never takes a lifecycle suffix; the protocol repo's prompts remain canonical, the operator-side copies are project-flavored adaptations

## What Stays External

Keep these external unless a project has a deliberate reason to mirror them:

- the grounding note (always external, by design)
- the advisor Project's **mounted bootstrap**, its **thin Instructions deployment canonical**, and its **live-fetched index canonical**, when an external advisor surface (GPT or Claude in chat form) is used — the index is not mounted, but it stays external and required
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
- begin bootstrap using the agreed project purpose, structure, and advisor-surface decision
