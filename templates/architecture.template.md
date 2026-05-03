# Architecture Template

Use this as a starter for a downstream repo's own architecture doc.

This template is agent-agnostic.

## Repo Purpose

- repo purpose: `[what the repo owns]`
- non-goals: `[what the repo does not own]`

## Operating Model

- `[which operating model this project runs on: Model A (ChatGPT/Codex), Model B (Claude Code), or either]`
- live operator: `[Claude Code | Codex | both | other]`
- optional advisors: `[GPT | Claude Code | none]`

The same workflow rules apply regardless of which agent does the executing. Rules live in repo-local `AGENTS.md`.

## Sources Of Truth

- **Repo** = project state
- **`AGENTS.md`** = workflow rules
- **Grounding note** (external) = intent, audience, philosophy, foundational premises, durable loose threads
- **Per-conversation memory** (operator-side) = ephemeral session state; not durable
- `[any project-specific live truth surfaces, e.g. a database, a CMS, direct visual evidence]`

## Artifact Model

- repo-local execution files: `[files]`
- repo docs: `[docs]`
- external context: grounding note at `[path or URL]`
- `[any project-specific artifact classes, e.g. milestone notes, finding artifacts, schema mutation records]`

## How The Pieces Relate

- `[explain how repo-local files govern work inside the repo]`
- `[explain how the grounding note relates without overriding repo-local truth]`
- `[explain which docs are explanatory versus operational]`

## Architecture-Specific Anchors

If the project's information architecture has a load-bearing creative or governance act (curation, capture, ratification, selection, etc.), name it here and explain how it is modeled in the schema or in the rules.

If the project has external systems with their own mutation discipline, list them here.

## Ownership Notes

- local source of truth: `[files or rules]`
- external dependencies or governing artifacts: `[grounding note, external systems]`
