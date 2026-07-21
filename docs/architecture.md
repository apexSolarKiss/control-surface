# Architecture

[`control-surface`](../README.md) is the execution-protocol repo for ASK workflow architecture assets.

## Role Model

The active operating model for new ASK projects is single-node: Claude Code is both control surface and executor. An advisor in chat-based form — typically GPT or Claude — remains available outside the execution thread.

The methodology layer that articulates the method has graduated upstream to [`apexSolarKiss/method-ASK`](https://github.com/apexSolarKiss/method-ASK). This repo carries the execution-protocol layer that operationalizes the method per session. [`control-surface`](../README.md) sits upstream of downstream project repos while remaining downstream of `method-ASK`.

An earlier split-execution model — ChatGPT as prompt compiler, Codex as executor, Claude Code as optional advisor — shaped this repo's design and is retained as legacy reference. It is referred to historically as **Model A**. [`apexSolarKiss/mazeASK`](https://github.com/apexSolarKiss/mazeASK) is the retained legacy Model A reference (currently dormant) — the working example for any project that still needs that model.

The workflow rules are agent-agnostic; the rules in `AGENTS.md` apply to whoever is executing.

Three worked examples anchor the family:

- [`apexSolarKiss/asset-pipeline-ASK`](https://github.com/apexSolarKiss/asset-pipeline-ASK) — single-node working example (mature pressure surface)
- [`apexSolarKiss/urban-observatory`](https://github.com/apexSolarKiss/urban-observatory) — single-node working example (newer; instantiation / source-of-intent recovery pressure surface)
- [`apexSolarKiss/mazeASK`](https://github.com/apexSolarKiss/mazeASK) — legacy Model A reference (project currently dormant)

[`apexSolarKiss/design-system-ASK`](https://github.com/apexSolarKiss/design-system-ASK) is a distinct kind of surface — an externalized ASK visual / aesthetic-intent implementation. It is the family's upstream visual-inheritance reference surface: the public, repo-shaped carrier of *externalized* aesthetic intent that child artifacts inherit by reference. Source-of-intent proper remains operator-side; this repo carries the implementation surface. One downstream child proof has landed (`urban-observatory`'s Example 2 prototype). [`apexSolarKiss/method-ASK/examples/design-system-ASK.md`](https://github.com/apexSolarKiss/method-ASK/blob/main/examples/design-system-ASK.md) carries the method-altitude account. Not a project pressure surface in the same sense as the three worked examples above.

## Layer Map

This repo sits in the middle of a three-tier structure:

- **Methodology layer** — adversarial iteration / cross-phase swing discipline. Lives upstream in [`apexSolarKiss/method-ASK`](https://github.com/apexSolarKiss/method-ASK); [`docs/method.md`](method.md) in this repo is a compact bridge pointing there.
- **Execution-protocol layer** — this repo's core purpose. `AGENTS.md`, the shared protocol carrier (`protocol/AGENTS.shared.md`, resolved locally into each consumer's own `AGENTS.md`; `protocol/manifest.json`; `protocol/profiles/`; and the `protocol/check.sh` local validator), templates, review cadence, and branch discipline encode how work gets done within a session.
- **Project repos** — applications of the method and protocol to concrete domains. [`apexSolarKiss/asset-pipeline-ASK`](https://github.com/apexSolarKiss/asset-pipeline-ASK) is the mature single-node working example and primary pressure surface for rule evolution; [`apexSolarKiss/urban-observatory`](https://github.com/apexSolarKiss/urban-observatory) is the second single-node working example, exercising the protocol repo at the source-of-intent recovery, post-bootstrap grounding-note freshness, and architecture-uncertain instantiation surfaces; [`apexSolarKiss/mazeASK`](https://github.com/apexSolarKiss/mazeASK) is the legacy Model A working example.

Alongside the project repos, [`apexSolarKiss/design-system-ASK`](https://github.com/apexSolarKiss/design-system-ASK) is the family's upstream visual-inheritance reference surface — an externalized ASK visual / aesthetic-intent implementation, not a project pressure surface. Child surfaces inherit Tier 1 + Tier 2 by reference and resolve Tier 3 (instance identity) locally by source-of-intent + brand-distance; ASK-the-entity is the one surface that uses ASK's own Tier 3 (it does not inherit ASK's Tier 3 to downstream surfaces). One downstream child proof has landed (`urban-observatory`). The method-altitude account lives in [`apexSolarKiss/method-ASK/examples/design-system-ASK.md`](https://github.com/apexSolarKiss/method-ASK/blob/main/examples/design-system-ASK.md).

The [control-surface](../README.md) repo owns the execution-protocol layer. The methodology layer lives upstream in `method-ASK`.

An illustrative tree of this architecture and its operator-side ecology is at [`docs/diagrams/control-surface_architecture-tree.html`](diagrams/control-surface_architecture-tree.html). The diagram is illustrative; repo prose is source truth.

## Source-of-Truth Split

ASK project work uses three durable sources of truth plus operator-side ephemeral memory:

- **Repo** = project state (artifacts, decisions, current navigation)
- **`AGENTS.md`** (in-repo) = workflow rules, agent-agnostic
- **Grounding note** (external) = repo-external context (intent, audience, philosophy, foundational premises, durable loose threads)
- **Per-conversation memory** (operator-side) = ephemeral session state; does not flow into the durable sources

### Aging-Rate Principle

The split is separation by *aging rate*:

- Docs that *track state* age fast.
- Docs that *point to state* age slowly.
- Rules docs age slowly when they contain rules only.
- Context docs age slowly when they contain context only.
- Mixed docs age at the rate of their fastest-aging contents.

This is the load-bearing rationale for keeping the four sources separate.

## Lifecycle Phases

- **Instantiation:** the project is being defined and the target repo does not yet exist; the grounding note and any pre-repo prompts carry the workflow.
- **Bootstrap:** the target repo exists, repo-local truth begins to form, and starter templates are adopted.
- **Operational:** repo-local files are authoritative, normal workflow rules apply, and the grounding note remains the external context anchor.

## Artifact Model

- `AGENTS.md` — live repo-local execution rules for this execution-protocol repo
- `CLAUDE.md` — pointer to `AGENTS.md` for Claude Code operators
- `docs/architecture.md` — this doc; explains the execution-protocol architecture
- `templates/` — reusable starters for downstream repo-local files and the external grounding note
- `protocol/` — the distributable execution-protocol layer: the shared `AGENTS` core (`AGENTS.shared.md`, resolved verbatim into each consumer's own `AGENTS.md` between the shared markers), the normative `manifest.json` registry, downstream `profiles/`, the opt-in standing-upstream-conformance-grant `fragments/` entry, and `check.sh` (a deterministic local validator, not CI); consumers resolve the shared block locally rather than holding an independent copy
- `prompts/project-instantiation-initial-prompt.md` — agent-agnostic startup prompt for the pre-repo phase
- `examples/` — concise mappings from real ASK projects to this structure
- legacy docs (`control-surface.md`, `docs/workflow-boundary.md`, Model-A-specific prompts) — retained for reference; deprecation headers name what supersedes them

## Session Topology

ASK project work routinely involves multiple operator sessions: parallel Claude Code threads, ChatGPT plus Codex, Claude Chat as advisor plus Claude Code as executor. The repo and remote are the audit trail when sessions disagree.

The single-writer-per-branch rule encoded in `AGENTS.md` handles this. Operators must verify state freshly when picking up a branch, treat the working tree as authoritative over their own memory, and stop on suspected concurrent mutation.

## Why The Rules Exist

The single-node model collapses several functions that Model A handled by default. Most of the rules in `AGENTS.md` are calibrated compensations for what gets lost when a single agent is both compiler and executor:

- A split model has a natural prompt-compilation step. A single-node model collapses it into the executor; **Plan-Before-Execute** is the rule that restores the reasoning surface.
- A split model's two-model separation surfaces disagreements as visible artifacts. A single-node model runs in one head; **Structured Change Summary** and **exact-scoped-diff approval** are the compensations.
- A single-node model has stronger session-topology pressure (Claude Code spawns parallel threads easily); **single-writer discipline** is the compensation.

When proposing rule changes, ask which failure mode the rule is compensating for and whether the compensation is still load-bearing.

## Current Shape

This repo is intentionally small:

- one set of live operating files for this repo
- the `protocol/` layer: the shared `AGENTS` core resolved locally into each consumer's own `AGENTS.md`, a normative `manifest.json` registry, downstream `profiles/`, an opt-in standing-upstream-conformance-grant fragment, and `check.sh` (a deterministic local validator, not CI)
- a small downstream template set (`AGENTS.template.md`, `grounding-note.template.md`, `architecture.template.md`) — starters adopted alongside, not instead of, the locally resolved shared protocol
- one agent-agnostic instantiation prompt
- a minimal example set
- a legacy reference set retained for [`mazeASK`](https://github.com/apexSolarKiss/mazeASK) and any other project still on Model A

Beyond the bounded `protocol/` resolution-and-validation layer — a distributable shared execution-protocol core resolved locally into each consumer's own `AGENTS.md`, a normative manifest, downstream profiles, an opt-in standing-grant fragment, and `check.sh` (a deterministic validator run locally, by hand) — it does not include automation, sync tooling, CI, generators, or a larger framework system. `check.sh` is a local validator, not continuous integration; the `protocol/` layer resolves and checks existing rules, it does not generate artifacts or constitute a product build framework.
