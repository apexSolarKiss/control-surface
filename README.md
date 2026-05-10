# control-surface

![control-surface banner](control-surface-banner.png)

Reusable control-surface workflow assets for ASK projects.

This repo contains both the live operating files for `control-surface` itself and reusable workflow artifacts for downstream ASK projects, including the upstream instantiation phase before a target repo exists.

## Operating Model

The active operating model for new ASK projects is single-node: **Claude Code as both control surface and executor**. An advisor in chat-based form — typically GPT or Claude — remains available outside the execution thread.

An earlier split-execution model — ChatGPT as prompt compiler, Codex as executor, Claude Code as optional advisor — shaped this repo's design and is retained as legacy reference. It is referred to historically as **Model A**. The Model-A-specific external orchestration artifact ([`control-surface.md`](control-surface.md)) and Model-A-only prompts remain in the repo as legacy.

`apexSolarKiss/mazeASK` is still operated on Model A and is the working example for any project that still needs it. New ASK projects should default to single-node.

The workflow rules live in repo-local `AGENTS.md` files and are written agent-agnostically — they apply to whoever is executing.

Two live working examples anchor the family:

- `apexSolarKiss/asset-pipeline-ASK` — single-node working example, primary pressure surface from which the meta repo's rules are discovered, and source of upstream workflow-rule evolution. Operated end-to-end on Claude Code as control surface and executor; has produced the most advanced live `AGENTS.md` in the family. Template changes absorb only the portions that generalize beyond that repo's domain.
- `apexSolarKiss/mazeASK` — Model A working example. Operated on the ChatGPT/Codex split; the original concrete instance the boundary model was sketched against. Still active for that project.

## Source-of-Truth Split

ASK project work uses three durable sources of truth plus operator-side ephemeral memory:

- **Repo** = project state (artifacts, decisions, current navigation)
- **[`AGENTS.md`](AGENTS.md)** (in-repo) = workflow rules, agent-agnostic, applies to whoever executes
- **Grounding note** (external) = repo-external context: intent, audience, philosophy, foundational premises, durable loose threads
- **Per-conversation memory** (operator-side: Claude Code's MEMORY.md, ChatGPT thread history, task lists) = ephemeral session state, does not flow into the durable sources

### Aging-Rate Principle

The split is not just separation of concerns. It is separation by *aging rate*:

- A doc that *tracks state* ages fast and must be refreshed often.
- A doc that *points to state* ages slowly and stays useful across many sessions.
- A rules doc that contains rules only ages slowly.
- A context doc that contains context only ages slowly.
- A doc that mixes rules, context, and state ages at the rate of its fastest-aging contents.

This is the load-bearing rationale for the source-of-truth split. Each source is sized to a single aging rate.

## Repo Layout

### Live operating files for this repo

- [`AGENTS.md`](AGENTS.md) — repo-local workflow rules that govern execution inside this repo
- [`CLAUDE.md`](CLAUDE.md) — pointer to `AGENTS.md` for Claude Code operators
- [`docs/architecture.md`](docs/architecture.md) — meta architecture of this repo and the role model behind it

### Methodology docs

- [`docs/method.md`](docs/method.md) — methodology layer; articulation of the method for designing systems-of-systems; transitional bridge that may graduate to its own repo when accumulation earns it

### Workflow docs

- [`docs/project-instantiation-workflow.md`](docs/project-instantiation-workflow.md) — agent-agnostic workflow doc for the pre-repo instantiation phase before a target ASK repo exists

### Reusable templates for downstream ASK repos

- [`templates/AGENTS.template.md`](templates/AGENTS.template.md) — agent-agnostic starter for repo-local execution rules; derived from the shared workflow core of asset-pipeline-ASK's live AGENTS.md (project-specific architecture rules in that repo are not absorbed by default)
- [`templates/grounding-note.template.md`](templates/grounding-note.template.md) — starter for the external grounding note that travels with each ASK project
- [`templates/architecture.template.md`](templates/architecture.template.md) — starter for a downstream repo's architecture doc

Templates are copyable starters. They are not live for this repo unless explicitly adopted somewhere else.

### Prompts

- [`prompts/project-instantiation-initial-prompt.md`](prompts/project-instantiation-initial-prompt.md) — agent-agnostic startup prompt for the pre-repo instantiation phase

### Examples

- [`examples/asset-pipeline-ASK/notes.md`](examples/asset-pipeline-ASK/notes.md) — single-node working example
- [`examples/mazeASK/notes.md`](examples/mazeASK/notes.md) — Model A working example (still active for that project)

### Legacy docs

These were active when the canonical operating model was ASK→ChatGPT→Codex with Claude Code as advisory. They are retained for reference and for `apexSolarKiss/mazeASK`, which still runs on Model A.

- [`control-surface.md`](control-surface.md) — Model-A-specific external control-surface artifact
- [`docs/workflow-boundary.md`](docs/workflow-boundary.md) — earlier boundary categorization, supplanted by [`AGENTS.md`](AGENTS.md)'s Source-of-Truth Boundaries section
- [`prompts/control-surface-initial-prompt.md`](prompts/control-surface-initial-prompt.md) — Model-A ChatGPT-side initial prompt
- [`prompts/codex-initial-prompt.txt`](prompts/codex-initial-prompt.txt) — Model-A Codex-side initial prompt

Each legacy doc carries a deprecation header naming what supersedes it for current single-node work.

## Which File Do I Use?

| If you need to... | Use |
| --- | --- |
| define execution rules inside the current repo | [`AGENTS.md`](AGENTS.md) |
| understand this meta repo's own architecture | [`docs/architecture.md`](docs/architecture.md) |
| set up the workflow before the target repo exists | [`docs/project-instantiation-workflow.md`](docs/project-instantiation-workflow.md) and [`prompts/project-instantiation-initial-prompt.md`](prompts/project-instantiation-initial-prompt.md) |
| create repo-local starter docs for a downstream repo | [`templates/AGENTS.template.md`](templates/AGENTS.template.md), [`templates/grounding-note.template.md`](templates/grounding-note.template.md), [`templates/architecture.template.md`](templates/architecture.template.md) |
| see how the structure mapped onto a real ASK project | [`examples/`](examples/) |
| understand the previous canonical Model-A operating doc | [`control-surface.md`](control-surface.md) (legacy) |

## Minimal Adaptation Checklist

For a new ASK project:

- Identify the project purpose, repo name, and initial structure.
- Default to the single-node operating model unless the project has a specific reason to run on legacy Model A.
- Copy [`templates/AGENTS.template.md`](templates/AGENTS.template.md) into the new repo as `AGENTS.md` and adapt project-specific defaults.
- Copy [`templates/grounding-note.template.md`](templates/grounding-note.template.md) into the external grounding-note location and fill in intent, audience, philosophy, foundational premises, and durable loose threads.
- Optionally copy [`templates/architecture.template.md`](templates/architecture.template.md) into the new repo as `docs/architecture.md`.
- Identify protected paths, constraints, and required verification steps in the new repo's `AGENTS.md`.

## Background Reading

The control-surface design recorded in this repo is anchored to four pieces of external writing:

- [*Beyond Vibe Coding: Constraining LLMs*](https://atomicspacekitten.substack.com/p/beyond-vibe-coding-constraining-llms) — the prior argument that reliable AI-native execution requires *constrained* LLMs, with explicit rules, explicit boundaries, explicit reasoning surfaces, and ready-to-send prompts that already encode the workflow rather than asking the human to reconstruct it on every turn. The original case for the structural friction that the legacy split-execution control surface (Model A) operationalized.
- [*Lessons from the First Prototype Phase*](https://atomicspacekitten.substack.com/p/lessons-from-the-first-prototype) — the structural retrospective that justifies the current state. Records the migration of structural friction into rules in the repo, the sunset of Model A, the ~50x ceremony reduction that single-node operation produces, and the reframe of the rules as calibrated compensations for what single-node collapses relative to the legacy split.
- [*Adversarial Collaboration*](https://atomicspacekitten.substack.com/p/adversarial-collaboration) — the next workflow piece, recording where dual-agent dialogue went after Model A retired. Once execution-layer friction had compressed into rules, the dual-agent surface relocated to the architectural layer — where the work hasn't yet compressed and may never compress that way. Names adversarial collaboration (Kahneman / Mellers) as the working term, with multi-agent debate and actor-critic as adjacent shapes of the same family. The pattern's tractability depends on the durable backbone of repo, grounding note, and `AGENTS.md` rules.
- [*From Execution Proof Back to Normative Structure*](https://atomicspacekitten.substack.com/p/from-execution-proof-back-to-normative) — the next workflow piece after *Adversarial Collaboration*. Names two related-but-distinct patterns: adversarial collaboration (multi-mind, one moment) and adversarial iteration (single-mind, across time / the swing methodology). Both are load-bearing in the working method.

Together they describe why the control-surface rules look the way they do, why the operating model evolved from split-execution to single-node, and where dual-agent dialogue still earns its keep above the rules.

## License

Copyright (c) 2026 Andrew S Klug // ASK

Licensed under the Apache License 2.0 // see [`LICENSE`](LICENSE)
