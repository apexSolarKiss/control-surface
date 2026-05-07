# Architecture

`control-surface` is a meta repo for ASK workflow architecture assets.

## Role Model

The active operating model for new ASK projects is single-node: Claude Code is both control surface and executor. An advisor in chat-based form — typically GPT or Claude — remains available outside the execution thread.

An earlier split-execution model — ChatGPT as prompt compiler, Codex as executor, Claude Code as optional advisor — shaped this repo's design and is retained as legacy reference. It is referred to historically as **Model A**. `apexSolarKiss/mazeASK` is still operated on Model A and is the working example for any project that still needs it.

The workflow rules are agent-agnostic; the rules in `AGENTS.md` apply to whoever is executing.

Two live working examples anchor the family:

- `apexSolarKiss/asset-pipeline-ASK` — single-node working example
- `apexSolarKiss/mazeASK` — Model A working example (still active for that project)

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

- `AGENTS.md` — live repo-local execution rules for this meta repo
- `CLAUDE.md` — pointer to `AGENTS.md` for Claude Code operators
- `docs/architecture.md` — this doc; explains the meta architecture
- `templates/` — reusable starters for downstream repo-local files and the external grounding note
- `prompts/project-instantiation-initial-prompt.md` — agent-agnostic startup prompt for the pre-repo phase
- `examples/` — concise mappings from real ASK projects to this structure
- legacy docs (`control-surface.md`, `docs/workflow-boundary.md`, `docs/project-instantiation-workflow.md`, Model-A-specific prompts) — retained for reference; deprecation headers name what supersedes them

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
- a small downstream template set (`AGENTS.template.md`, `grounding-note.template.md`, `architecture.template.md`)
- one agent-agnostic instantiation prompt
- a minimal example set
- a legacy reference set retained for `mazeASK` and any other project still on Model A

It does not include automation, sync tooling, CI, generators, or a larger framework system.
