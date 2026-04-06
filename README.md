# control-surface

Reusable control-surface workflow assets for ASK projects.

This repo contains both live repo files for `control-surface` itself and reusable workflow artifacts for other ASK projects.

The structure separates five concerns:

- Live repo-operating files for this repo itself
- Repo explanatory docs for this meta repo
- External control-surface artifacts published for reuse
- Runnable startup prompts used to attach ChatGPT or Codex to a repo
- Reusable templates for downstream ASK projects
- Examples that show how an ASK project maps onto the structure

## Repo Layout

### Live files in this repo

- `AGENTS.md`: repo-local execution rules for work inside this repo

`AGENTS.md` is the live repo-local operating file for this repo.

### Repo docs

- `docs/workflow-boundary.md`: explains the boundary between repo-local rules, repo docs, external artifacts, prompts, templates, and examples
- `docs/architecture.md`: explains the meta architecture of this repo and the role model behind it

These docs explain this repo. They are not external control-surface artifacts.

### External artifact

- `control-surface.md`: canonical reusable external control-surface artifact published by this repo for ASK projects

This file is not the live local governance file for `control-surface` itself.

### Prompts

- `prompts/`: startup prompts that can be used when attaching an agent to a repo

Prompts are runnable inputs. They are not the same thing as live repo policy, explanatory docs, or templates.

### Reusable templates

- `templates/AGENTS.template.md`: starter for repo-local execution rules in downstream ASK repos

Templates are copyable scaffolds. They are not live for this repo unless explicitly adopted somewhere else.

### Examples

- `examples/mazeASK/notes.md`: concise mapping note showing how mazeASK fits this structure

## Boundary Summary

The key distinction in this repo is:

- `AGENTS.md` is repo-local and governs execution inside a repo
- `docs/` explains this meta repo's own boundary and architecture
- `control-surface.md` is an external reusable artifact intended to govern work around another repo
- `prompts/` contains runnable startup text
- `templates/` contains copyable starters
- `examples/` contains concrete mapping notes

External control-surface artifacts are intentionally outside the repo they govern, even when this repo publishes them as canonical reusable assets.
