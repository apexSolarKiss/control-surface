# Architecture

`control-surface` is a meta repo for ASK workflow architecture assets.

## Role Model

ASK project work supports two operating models:

- **Model A — split:** ChatGPT compiles prompts, Codex executes inside the local repo, Claude Code is optional advisor.
- **Model B — single-node:** Claude Code is both control surface and executor, GPT is optional advisor.

The same workflow rules apply regardless of which agent does the executing. Rules are agent-agnostic; operators are interchangeable.

For this meta repo, Claude Code is currently the live operator. Model A is supported and the historical tooling is retained as legacy reference for projects still running on it.

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

## Model-Asymmetric Compensation

Model A and Model B have different default failure modes. The rule set in `AGENTS.md` is calibrated to compensate for both, not to assert false parity:

- Model A has a natural prompt-compilation step. Model B collapses it into the executor; Plan-Before-Execute is the rule that restores the reasoning surface.
- Model A's two-model separation surfaces disagreements as visible artifacts. Model B runs in one head; Structured Change Summary and exact-scoped-diff approval are the compensations.
- Model B has stronger session-topology pressure (Claude Code spawns parallel threads easily); single-writer discipline is the compensation.

When proposing rule changes, ask which model's failure mode the rule is compensating for and whether the compensation is still load-bearing.

## Current Shape

This repo is intentionally small:

- one set of live operating files for this repo
- a small downstream template set (`AGENTS.template.md`, `grounding-note.template.md`, `architecture.template.md`)
- one agent-agnostic instantiation prompt
- a minimal example set
- a legacy reference set retained for Model A projects

It does not include automation, sync tooling, CI, generators, or a larger framework system.
