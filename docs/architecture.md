# Architecture

`control-surface` is a meta repo for ASK workflow architecture assets.

## Role Model

- **ASK** -> human decision-maker: sets goals, scope, constraints, and approval points
- **ChatGPT** -> prompt compiler: shapes instructions and control-surface framing
- **Codex** -> executor: works inside the attached local repo

The workflow depends on keeping orchestration, local execution, and explanation separate.

An optional advisory model surface may also be present.

Claude Code is the current working example.

It remains advisory rather than authoritative. Verified repo-local truth stays authoritative, ChatGPT remains the gatekeeping control surface, and Codex remains the executor.

## Lifecycle Phases

- Instantiation: the ChatGPT Project and source pack may exist before the target repo does
- Bootstrap: the target repo exists and repo-local truth starts to become explicit
- Operational: the repo exists, repo-local files are authoritative, and normal control-surface workflow applies

## Artifact Model

- `AGENTS.md`: live repo-local execution rules for this repo
- `docs/`: explanatory docs for this repo's own boundary and architecture
- `docs/project-instantiation-workflow.md`: procedural guide for the upstream instantiation phase
- `control-surface.md`: canonical reusable external control-surface artifact
- `prompts/`: runnable startup prompts for ChatGPT-side and Codex-side setup
- `templates/`: reusable starters for downstream repo-local files
- `examples/`: concise mappings from real ASK projects to this structure

## How The Pieces Relate

- The repo uses `AGENTS.md` plus `docs/` to govern work inside `control-surface`.
- The repo models an upstream phase where the Project source pack may be instantiated before the target repo exists.
- The repo models a bootstrap phase where the target repo becomes real and repo-local truth begins to form.
- The repo publishes `control-surface.md` as a reusable external artifact for other ASK projects.
- Prompts help attach tools or threads to a project using this workflow.
- The pre-repo prompt and Project-instructions template cover instantiation before repo creation.
- Templates provide starting points where a downstream repo needs its own local file.
- Examples show how the model applies in practice without turning example content into policy.

## Current Shape

This repo is intentionally small:

- one canonical external control-surface artifact
- a small downstream template set for repo-local docs
- a small prompt set
- a small docs set
- a minimal example set

The repo keeps templates only where a downstream repo is likely to want its own local counterpart.

It does not yet include automation, sync tooling, CI, generators, or a larger framework system.
