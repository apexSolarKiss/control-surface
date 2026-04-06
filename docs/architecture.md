# Architecture

`control-surface` is a meta repo for ASK workflow architecture assets.

## Role Model

- Decision-maker: sets goals, scope, constraints, and approval points
- ChatGPT: serves as prompt compiler and control surface
- Codex: executes inside the attached local repo

The workflow depends on keeping orchestration, local execution, and explanation separate.

## Artifact Model

- `AGENTS.md`: live repo-local execution rules for this repo
- `docs/`: explanatory docs for this repo's own boundary and architecture
- `control-surface.md`: canonical reusable external control-surface artifact
- `prompts/`: runnable startup prompts for ChatGPT-side and Codex-side setup
- `templates/`: reusable starters for downstream repo-local files
- `examples/`: concise mappings from real ASK projects to this structure

## How The Pieces Relate

- The repo uses `AGENTS.md` plus `docs/` to govern work inside `control-surface`.
- The repo publishes `control-surface.md` as a reusable external artifact for other ASK projects.
- Prompts help attach tools or threads to a project using this workflow.
- Templates provide starting points where a downstream repo needs its own local file.
- Examples show how the model applies in practice without turning example content into policy.

## Current Shape

This repo is intentionally small:

- one canonical external control-surface artifact
- a small downstream template set for repo-local docs
- a small prompt set
- a small docs set
- a minimal example note

The repo keeps templates only where a downstream repo is likely to want its own local counterpart.

It does not yet include automation, sync tooling, CI, generators, or a larger framework system.
