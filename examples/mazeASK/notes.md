# mazeASK Notes

`mazeASK` is the motivating ASK project for this repo's first structure, and its current repo docs show the boundary model in a concrete form.

## Repo-local files in mazeASK

- `AGENTS.md` governed execution behavior inside the repo.
- `docs/workflow-boundary.md` explained why repo-local execution rules and the external control surface stayed separate.
- `docs/architecture.md` captured the project-specific architecture and ownership model for topology, maze state, runtime state, and rendering.

## External artifacts and startup prompts

- The control-surface artifact sat outside the repo and governed how work was framed before it reached Codex.
- The ChatGPT-side startup prompt packaged repo attachment, mode, goals, and handoff expectations.
- The Codex-side startup prompt enforced verification and repo-local reading order once attached.

## What was customized

- repo attachment defaults such as repo root, canonical repo, and base branch
- repo entry points and local docs to read first
- project constraints around narrow architectural moves and milestone scope
- architecture content specific to maze generation, topology ownership, and milestone boundaries

## What stayed project-specific

- the graph-first architecture plan and milestone sequence
- the exact source-of-truth rules for maze connectivity
- algorithm and topology constraints documented in the repo docs
- any verification expectations tied to mazeASK's own code and workflow
