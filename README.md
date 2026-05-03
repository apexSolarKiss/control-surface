# control-surface

![control-surface banner](control-surface-banner.png)

Reusable control-surface workflow assets for ASK projects.

This repo contains both the live operating files for `control-surface` itself and reusable workflow artifacts for downstream ASK projects, including the upstream instantiation phase before a target repo exists.

## Operating Model

This repo supports two operating models for ASK project work:

- **Model A — split:** ChatGPT compiles prompts, Codex executes inside the local repo, Claude Code is optional advisor.
- **Model B — single-node:** Claude Code is both control surface and executor, GPT is optional advisor.

The same workflow rules apply regardless of which agent does the executing. The rules live in repo-local `AGENTS.md` files, and they are written agent-agnostically so an operator can pick up either model without rewriting the rules.

Two live working examples anchor the family:

- `apexSolarKiss/asset-pipeline-ASK` — Model B working example. Operated end-to-end on Claude Code as control surface and executor; has produced the most advanced live `AGENTS.md` in the family.
- `apexSolarKiss/mazeASK` — Model A working example. Operated on the ChatGPT/Codex split; the original concrete instance the boundary model was sketched against.

Both are supported. The historical Model-A-specific external orchestration artifact (`control-surface.md`) and the Model-A-only prompts are retained as legacy reference.

## Source-of-Truth Split

ASK project work uses three durable sources of truth plus operator-side ephemeral memory:

- **Repo** = project state (artifacts, decisions, current navigation)
- **`AGENTS.md`** (in-repo) = workflow rules, agent-agnostic, applies to whoever executes
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

- `AGENTS.md` — repo-local workflow rules that govern execution inside this repo
- `CLAUDE.md` — pointer to `AGENTS.md` for Claude Code operators
- `docs/architecture.md` — meta architecture of this repo and the role model behind it

### Reusable templates for downstream ASK repos

- `templates/AGENTS.template.md` — agent-agnostic starter for repo-local execution rules; aligned to the current asset-pipeline-ASK live AGENTS.md
- `templates/grounding-note.template.md` — starter for the external grounding note that travels with each ASK project
- `templates/architecture.template.md` — starter for a downstream repo's architecture doc

Templates are copyable starters. They are not live for this repo unless explicitly adopted somewhere else.

### Prompts

- `prompts/project-instantiation-initial-prompt.md` — agent-agnostic startup prompt for the pre-repo instantiation phase

### Examples

- `examples/asset-pipeline-ASK/notes.md` — Model B working example
- `examples/mazeASK/notes.md` — Model A working example

### Legacy docs

These were active when the canonical operating model was ASK→ChatGPT→Codex with Claude Code as advisory. They are retained for reference and for projects still running on Model A.

- `control-surface.md` — Model-A-specific external control-surface artifact
- `docs/workflow-boundary.md` — earlier boundary categorization, supplanted by `AGENTS.md`'s Source-of-Truth Boundaries section
- `docs/project-instantiation-workflow.md` — pre-repo instantiation workflow (still valid, agent-agnostic)
- `prompts/control-surface-initial-prompt.md` — Model-A ChatGPT-side initial prompt
- `prompts/codex-initial-prompt.txt` — Model-A Codex-side initial prompt

Each legacy doc carries a deprecation header naming what supersedes it for current Model B work.

## Which File Do I Use?

| If you need to... | Use |
| --- | --- |
| define execution rules inside the current repo | `AGENTS.md` |
| understand this meta repo's own architecture | `docs/architecture.md` |
| set up the workflow before the target repo exists | `docs/project-instantiation-workflow.md` and `prompts/project-instantiation-initial-prompt.md` |
| create repo-local starter docs for a downstream repo | `templates/AGENTS.template.md`, `templates/grounding-note.template.md`, `templates/architecture.template.md` |
| see how the structure mapped onto a real ASK project | `examples/` |
| understand the previous canonical Model A operating doc | `control-surface.md` (legacy) |

## Minimal Adaptation Checklist

For a new ASK project:

- Identify the project purpose, repo name, and initial structure.
- Decide whether the project will run on Model A, Model B, or either.
- Copy `templates/AGENTS.template.md` into the new repo as `AGENTS.md` and adapt project-specific defaults.
- Copy `templates/grounding-note.template.md` into the external grounding-note location and fill in intent, audience, philosophy, foundational premises, and durable loose threads.
- Optionally copy `templates/architecture.template.md` into the new repo as `docs/architecture.md`.
- Identify protected paths, constraints, and required verification steps in the new repo's `AGENTS.md`.

## License

Copyright (c) 2026 Andrew S Klug // ASK

Licensed under the Apache License 2.0 // see [`LICENSE`](LICENSE)
