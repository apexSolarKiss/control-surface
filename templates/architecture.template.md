# Architecture Template

Use this as a starter for a downstream repo's own architecture doc.

## Repo Purpose

- repo purpose: `[what the repo owns]`
- non-goals: `[what the repo does not own]`

## Role Model

- decision-maker: `[if relevant]`
- prompt compiler or control surface: `[if relevant]`
- executor: `[if relevant]`

Omit this section if the repo does not use an explicit role model.

## Artifact Model

- repo-local execution files: `[files]`
- repo docs: `[docs]`
- external artifacts: `[external control-surface or orchestration assets]`
- prompts: `[startup prompts if used]`
- templates: `[local starters if any]`

## How The Pieces Relate

- `[explain how repo-local files govern work inside the repo]`
- `[explain how external artifacts relate without overriding repo-local truth]`
- `[explain which docs are explanatory versus operational]`

## Ownership Notes

- local source of truth: `[files or rules]`
- external dependencies or governing artifacts: `[artifacts]`
