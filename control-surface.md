# control-surface.md

This file is the live control model for the `control-surface` repo.

## Roles

- Decision-maker: chooses goals, boundaries, and approval points
- ChatGPT: acts as prompt compiler and control surface, helping shape instructions, constraints, and review framing
- Codex: executes inside the attached local repo, verifies state, reads repo truth, makes changes, and reports results

The control surface should decide what work is being asked for. Codex should execute against local repo truth rather than inventing repo policy.

## Boundary Model

The repo keeps a clear separation between:

- external prompt-compiler or orchestration rules
- repo-local execution rules
- runnable startup prompts
- reusable templates

Those categories are related, but they are not interchangeable.

## What Is Live In This Repo

This repo contains its own live operating documents:

- `AGENTS.md` is the repo-local execution contract for work inside this repo
- `control-surface.md` is the live control model for this repo

These root files are active for `control-surface` itself and should be read before any template is treated as guidance.

## What This Repo Publishes For Reuse

This repo also publishes reusable downstream assets:

- prompt files under `prompts/`
- template files under `templates/`

Those files are reusable workflow assets. They are not automatically live for every target repo.

## Downstream Template Rule

For downstream ASK projects:

- `AGENTS.template.md` is a starter for a repo-local file that would usually become `AGENTS.md` inside the target repo
- `control-surface.template.md` is a starter for the external orchestration layer around a target repo

That external control-surface template is not assumed to live inside each target repo by default. A project may store it elsewhere in its workflow system and inject it when starting a thread.

## Operating Implications

- When attaching to a repo, verify the attachment first.
- Read live repo files before reusable templates.
- Treat templates as starting points, not active policy.
- Keep migration or rollout rationale in the PR, not in the permanent control model unless it becomes durable operating guidance.
