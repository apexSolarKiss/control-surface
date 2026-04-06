# AGENTS.md

This file is the live repo-local execution guide for work inside `control-surface`.

## Repo Purpose

This repo owns workflow architecture assets for ASK projects:

- live operating docs for this repo
- explanatory docs for this meta repo
- canonical external control-surface artifacts
- reusable templates for downstream repos
- bootstrap prompts for attaching ChatGPT or Codex to a repo

This repo does not own product application code. Changes here should improve workflow structure, operating clarity, or reusable scaffolding.

## Entry Points

Start with these files when working in this repo:

1. `README.md`
2. `AGENTS.md`
3. relevant files under `docs/`
4. `control-surface.md` when working on the published external artifact
5. relevant files under `prompts/`, `templates/`, or `examples/`

Read the live repo-local files and repo docs before treating any external artifact or template as authoritative for this repo.

## Working Style

- Keep scope narrow and intentional. Prefer the smallest coherent scaffold that clarifies the workflow boundary.
- Preserve the distinction between live repo files, repo docs, external artifacts, runnable prompts, reusable templates, and examples.
- Tailor docs to this repo's job as a workflow meta repo. Do not write as if this repo were an application repo.
- Use clean technical language. Avoid manifesto phrasing, speculative systems, or generic process bloat.

## Change Discipline

- Branch from current `main` for each task unless instructed otherwise.
- Keep changes grouped by one reviewable intent. Avoid mixing new structure, broad rewrites, and unrelated cleanup.
- Do not create extra folders, tools, or automation unless the task requires them.
- If a template changes, confirm whether the corresponding live file also needs an update, or whether the divergence is intentional.

## Comments, Docs, And PR Boundary

- Comments belong in local truth when a file needs inline clarification.
- Docs describe architecture, boundaries, operating contracts, and reusable guidance.
- PR descriptions explain migration intent, review framing, and why a change is being made now.

Do not push PR-only explanation into permanent repo docs, and do not hide durable operating rules inside PR text.

## Commit And PR Hygiene

- Prefer small, coherent PRs with a clear boundary.
- Use commit messages that describe the actual repo-facing change.
- Stage only files that belong to the task.
- Before proposing a PR, check the scoped diff and confirm that terminology around `live`, `template`, `external`, and `repo-local` is consistent.

## Defaults

- Prefer ASK reuse over world-scale abstraction.
- Prefer explicit structure over clever indirection.
- Prefer updating root docs and a small set of templates over adding systems around them.
