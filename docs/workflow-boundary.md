# Workflow Boundary

This doc explains the boundary model used by the `control-surface` repo itself.

## Categories

- Live repo-local files: active operating files for this repo, such as `AGENTS.md`
- Repo docs: explanatory docs that describe this meta repo's structure and architecture
- External artifacts: reusable control-surface documents intended to govern work around another repo
- Prompts: runnable startup text for ChatGPT or Codex
- Templates: copyable starters for downstream repo-local files
- Examples: concise notes that show how a real ASK project maps onto the structure

## Boundary Rules

- Before a target repo exists, there is no repo-local truth yet; the instantiated Project source pack and external artifacts carry the workflow.
- Repo-local execution rules live inside the repo they govern.
- Repo explanatory docs describe this repo and should not be mistaken for external operating artifacts.
- External control-surface artifacts are intentionally outside the repo they govern, even when this repo publishes them.
- Prompts are runnable text inputs, not durable repo policy.
- Templates are reusable starters, not live files.
- Examples illustrate mapping and usage, not authority.

## Practical Reading Order

When working inside this repo:

1. Read `README.md`.
2. Read `AGENTS.md`.
3. Read the relevant files in `docs/`.
4. Read `control-surface.md` if the task involves the published external artifact.
5. Read prompts, templates, or examples only as needed.

For pre-repo instantiation work, start with `docs/project-instantiation-workflow.md` and the relevant prompt or template before any repo-local reading order exists.

## Naming Discipline

Use terminology precisely:

- `live` for active files that govern the current repo
- `repo-local` for files whose authority depends on being inside a repo
- `external` for artifacts that govern from outside the target repo
- `reusable` for assets intended to be adapted across ASK projects
- `template` for copyable starters
- `example` for concrete reference material
