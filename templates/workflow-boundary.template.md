# Workflow-Boundary Template

Use this as a starter for a downstream repo's own workflow-boundary doc.

## Categories

- repo-local execution rules: `[local operating files such as AGENTS.md]`
- repo docs: `[local docs that explain the repo's own structure and boundaries]`
- external control-surface artifacts: `[artifacts that govern work around the repo from outside it]`
- prompts: `[runnable startup text, if used]`
- templates: `[copyable starters, if any are kept locally]`
- examples: `[optional project examples or mapping notes]`

## Boundary Rules

- Repo-local execution rules live inside the repo they govern.
- Repo docs explain the repo itself and are not external control-surface artifacts.
- External control-surface artifacts are separate from repo-local truth.
- Prompts are runnable text inputs, not durable repo policy.
- Templates are starters, not active files.
- Examples are reference material, not authority.

## Reading Order

1. Read `README.md`.
2. Read `[repo-local execution rules]`.
3. Read `[repo docs that define architecture or boundaries]`.
4. Read `[external artifacts, prompts, templates, or examples]` only as needed.
