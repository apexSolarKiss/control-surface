# Architecture

[`control-surface`](../README.md) is the execution-protocol repo for ASK workflow architecture assets.

## Role Model

ASK projects run an **adversarial-collaboration operating model** — an ASK-apexed advisor–executor topology. **ASK** is the source-of-intent and authorization apex, the relay across surfaces, and the final adjudicator. A non-writing **advisor surface** supplies external challenge, reconstruction, and verification from outside the execution thread. A repo-attached **execution surface** plans and performs authorized work under `AGENTS.md`, under single-writer-per-branch discipline. In the current stack a GPT advisor fills the advisor role and Claude Code fills the execution role; model identity is operational, not architectural.

**Direct execution** is the bounded variant — ASK driving the executor without an advisor pass where a separate pass would not materially reduce uncertainty. It is a proportional path within the same model, not a separate model.

Compactly: **multi-surface in reasoning, single-writer in mutation, single-apex in authority.**

The methodology layer that articulates the method has graduated upstream to [`apexSolarKiss/method-ASK`](https://github.com/apexSolarKiss/method-ASK). This repo carries the execution-protocol layer that operationalizes the method per session. [`control-surface`](../README.md) sits upstream of downstream project repos while remaining downstream of `method-ASK`.

An earlier split-execution model, historically **Model A**, shaped this repo's early design and is retired as a live option; its artifacts remain in the repo and git history as frozen provenance under retired-status headers.

The workflow rules are agent-agnostic; the rules in `AGENTS.md` apply to whoever is executing.

Two current working examples anchor the family:

- [`apexSolarKiss/asset-pipeline-ASK`](https://github.com/apexSolarKiss/asset-pipeline-ASK) — primary pressure surface (mature working example)
- [`apexSolarKiss/urban-observatory`](https://github.com/apexSolarKiss/urban-observatory) — second working example (instantiation / source-of-intent recovery pressure surface)

[`apexSolarKiss/design-system-ASK`](https://github.com/apexSolarKiss/design-system-ASK) is a distinct kind of surface — an externalized ASK visual / aesthetic-intent implementation. It is the family's upstream visual-inheritance reference surface: the public, repo-shaped carrier of *externalized* aesthetic intent that child artifacts inherit by reference. Source-of-intent proper remains operator-side; this repo carries the implementation surface. `urban-observatory`'s Example 2 prototype is a downstream inheritance proof. [`apexSolarKiss/method-ASK/examples/design-system-ASK.md`](https://github.com/apexSolarKiss/method-ASK/blob/main/examples/design-system-ASK.md) carries the method-altitude account. Not a project pressure surface in the same sense as the two current working examples above.

## Layer Map

This repo sits in the middle of a three-tier structure:

- **Methodology layer** — adversarial iteration / cross-phase swing discipline. Lives upstream in [`apexSolarKiss/method-ASK`](https://github.com/apexSolarKiss/method-ASK); [`docs/method.md`](method.md) in this repo is a compact bridge pointing there.
- **Execution-protocol layer** — this repo's core purpose. `AGENTS.md`, the shared protocol carrier (`protocol/AGENTS.shared.md`, resolved locally into each consumer's own `AGENTS.md`; `protocol/manifest.json`; `protocol/profiles/`; and the `protocol/check.sh` local validator), templates, review cadence, and branch discipline encode how work gets done within a session.
- **Project repos** — applications of the method and protocol to concrete domains. [`apexSolarKiss/asset-pipeline-ASK`](https://github.com/apexSolarKiss/asset-pipeline-ASK) is the primary pressure surface for rule evolution; [`apexSolarKiss/urban-observatory`](https://github.com/apexSolarKiss/urban-observatory) is the second active working example, exercising the protocol repo at the source-of-intent recovery, post-bootstrap grounding-note freshness, and architecture-uncertain instantiation surfaces.

Alongside the project repos, [`apexSolarKiss/design-system-ASK`](https://github.com/apexSolarKiss/design-system-ASK) is the family's upstream visual-inheritance reference surface — an externalized ASK visual / aesthetic-intent implementation, not a project pressure surface. Child surfaces inherit Tier 1 + Tier 2 by reference and resolve Tier 3 (instance identity) locally by source-of-intent + brand-distance; ASK-the-entity is the one surface that uses ASK's own Tier 3 (it does not inherit ASK's Tier 3 to downstream surfaces). `urban-observatory` carries a downstream inheritance proof. The method-altitude account lives in [`apexSolarKiss/method-ASK/examples/design-system-ASK.md`](https://github.com/apexSolarKiss/method-ASK/blob/main/examples/design-system-ASK.md).

The [control-surface](../README.md) repo owns the execution-protocol layer. The methodology layer lives upstream in `method-ASK`.

An illustrative tree of this architecture and its operator-side ecology is at [`docs/diagrams/control-surface_architecture-tree.html`](diagrams/control-surface_architecture-tree.html). The routed-instance lifecycle owned by §Inbound Handoff TBI Marker has its own standalone figure at [`docs/diagrams/control-surface_intent-inbox-lifecycle.html`](diagrams/control-surface_intent-inbox-lifecycle.html) — the architecture tree carries an intent-inbox group because the tree must show the plane exists, which is a different job. Both diagrams are illustrative; repo prose is source truth.

## Source-of-Truth Split

ASK project work uses three durable sources of truth, plus two non-durable surfaces that are **not** interchangeable:

- **Repo** = project state (artifacts, decisions, current navigation)
- **`AGENTS.md`** (in-repo) = workflow rules, agent-agnostic
- **Grounding note** (external) = repo-external context (intent, audience, philosophy, foundational premises, durable loose threads)
- **Per-conversation / task state** (current chat, task lists, in-flight session context) = ephemeral; does not flow into the durable sources
- **Private agent memory** (Claude Code's auto memory) = **persistent, not ephemeral**: a non-authoritative, read-mostly operator cache; never a durable owner, never the home for in-flight tracking, and every mutation governed by `AGENTS.md` §Learning Disposition and §Private-Memory Write Gate

The last two are separated by *persistence*, not just by authority. Collapsing them is what lets an invisible surface accumulate operative rules: ephemeral state is discarded, while a cache that survives the session keeps whatever was written to it.

### Aging-Rate Principle

The split is separation by *aging rate*:

- Docs that *track state* age fast.
- Docs that *point to state* age slowly.
- Rules docs age slowly when they contain rules only.
- Context docs age slowly when they contain context only.
- Mixed docs age at the rate of their fastest-aging contents.

This is the load-bearing rationale for keeping these durable and non-durable surfaces separate.

## Lifecycle Phases

- **Instantiation:** the project is being defined and the target repo does not yet exist; the grounding note and any pre-repo prompts carry the workflow.
- **Bootstrap:** the target repo exists, repo-local truth begins to form, and starter templates are adopted.
- **Operational:** repo-local files are authoritative, normal workflow rules apply, and the grounding note remains the external context anchor.

## Artifact Model

- `AGENTS.md` — live repo-local execution rules for this execution-protocol repo
- `CLAUDE.md` — the Claude Code adapter; its `@AGENTS.md` import is what delivers the resolved carrier into an executor's context. Required for a Claude-operated repo, not a convenience pointer
- `docs/architecture.md` — this doc; explains the execution-protocol architecture
- `templates/` — reusable starters for downstream repo-local files and the external grounding note
- `protocol/` — the distributable execution-protocol layer: the shared `AGENTS` core (`AGENTS.shared.md`, resolved verbatim into each consumer's own `AGENTS.md` between the shared markers), the normative `manifest.json` registry, downstream `profiles/`, the opt-in standing-upstream-conformance-grant `fragments/` entry, and `check.sh` (a deterministic local validator, not CI); consumers resolve the shared block locally rather than holding an independent copy
- `protocol/adapters/` — typed, executor-specific artifacts providing runtime enforcement for a supported write path of an agent-agnostic shared rule on a given runtime, **not** OS-level enforcement over arbitrary subprocess writes (the shared protocol prohibits that circumvention semantically; sandbox hardening is a separate out-of-scope question); **not shared-protocol text and never inherited into a consumer's `AGENTS.md`**. `adapters/claude-code/` carries the native permission fragment for the private-persistent write gate, a static owner-repo check, a machine-local verifier, and their fixtures, run separately so the portable checker stays agent-agnostic
- `prompts/project-instantiation-initial-prompt.md` — agent-agnostic startup prompt for the pre-repo phase
- `examples/` — concise mappings from real ASK projects to this structure

## Session Topology

ASK project work routinely involves multiple writer-capable sessions: parallel executor threads, subagents in separate worktrees, a human editor alongside an executor. The repo and remote are the audit trail when sessions disagree. (The advisor surface is not a writer — it reviews from outside the execution thread and never mutates the repo.)

The single-writer-per-branch rule encoded in `AGENTS.md` handles this. Operators must verify state freshly when picking up a branch, treat the working tree as authoritative over their own memory, and stop on suspected concurrent mutation.

Single-writer discipline governs *who* may write. Two companion rules govern what operations against shared mutable state may **claim**: **Write Guarantee Levels** names the exact guarantee level — observation only, cooperative exclusion, or backend-enforced conditional mutation — and prohibits silent downgrade; the **Bounded-Region Byte Contract** governs partial-file writes and bounded-region identity claims alike, requiring each to declare its boundary, separator ownership, encoding, and structural handling rather than inherit a tool's defaults.

Those sessions sometimes need to coordinate mid-task — one clears a gate another is blocked on, or reports that an explicitly checked gate is still blocked. That is a within-surface concern; coordination across an operating-surface boundary stays with ASK's relay. [`prompts/inter-session-coordination.md`](../prompts/inter-session-coordination.md) is the coordinator runbook for that case. For a **transition** event, the evidence object and the durable owner land first. For an explicitly checked gate that is **still blocked**, the notice points at the existing source actually checked and creates no durable write, no new artifact, and no polling obligation — reporting that nothing changed is not a reason to write. Either way the peer notice **owns** no state, evidence, or authority — it carries only locators and bounded, non-authoritative summaries pointing back to that owner. It separates the durable pull (what is true now) from the ephemeral push (go re-read it), so neither substitutes for the other.

## Why The Rules Exist

Most rules make reasoning inspectable across ASK, the executor, and any configured advisor while preserving one write authority. In the standard paired path they make the advisor/executor boundary productive; in direct execution they give ASK the same reviewable objects before mutation:

- **Plan-Before-Execute** makes the executor's reasoning inspectable *before* it becomes a diff. It is what an advisor — or ASK — can challenge on scope, assumptions, non-actions, and intended terminal state.
- **Structured Change Summary** and **exact-scoped-diff approval** are the review objects themselves: what actually crosses the boundary, in a form precise enough to disagree with.
- **Single-writer discipline** keeps exactly one write authority while other surfaces read and review. Multi-surface reasoning only works if mutation stays single-writer.

Historically these were calibrated against what the retired split-execution model provided by default; that framing is preserved in the article record. Stated forward, they are the machinery of the current model rather than compensation for a retired one.

When proposing rule changes, ask which failure mode the rule addresses and whether it is still load-bearing.

## Current Shape

This repo is intentionally small:

- one set of live operating files for this repo
- the `protocol/` layer: the shared `AGENTS` core resolved locally into each consumer's own `AGENTS.md`, a normative `manifest.json` registry, downstream `profiles/`, an opt-in standing-upstream-conformance-grant fragment, `check.sh` (a deterministic local validator, not CI), and typed `adapters/` for the executor-specific enforcement of an agent-agnostic rule
- a small downstream template set (`AGENTS.template.md`, `grounding-note.template.md`, `architecture.template.md`) — starters adopted alongside, not instead of, the locally resolved shared protocol
- one agent-agnostic instantiation prompt
- a minimal example set

Beyond the bounded `protocol/` resolution-and-validation layer — a distributable shared execution-protocol core resolved locally into each consumer's own `AGENTS.md`, a normative manifest, downstream profiles, an opt-in standing-grant fragment, and `check.sh` (a deterministic validator run locally, by hand) — it does not include automation, sync tooling, CI, generators, or a larger framework system. `check.sh` is a local validator, not continuous integration; the `protocol/` layer resolves and checks existing rules, it does not generate artifacts or constitute a product build framework.
