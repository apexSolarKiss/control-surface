# Architecture Template

Use this as a starter for a downstream repo's own architecture doc.

This template is agent-agnostic.

## Repo Purpose

- repo purpose: `[what the repo owns]`
- non-goals: `[what the repo does not own]`

## Operating Model

- operating model: adversarial collaboration — an ASK-apexed advisor–executor topology. ASK is the source-of-intent and authorization apex, the relay across surfaces, and the final adjudicator.
- advisor surface: `[who fills the non-writing advisor role — external challenge, reconstruction, and verification from outside the execution thread]`
- execution surface: `[who fills the repo-attached execution role — plans and performs authorized work under AGENTS.md, under single-writer-per-branch discipline]`

The workflow rules apply regardless of which agent does the executing. Rules live in repo-local `AGENTS.md`. **Direct execution** — ASK driving the executor without an advisor pass where a separate pass would not materially reduce uncertainty — is a bounded proportional path within the same model, not a separate model.

## Sources Of Truth

- **Repo** = project state
- **`AGENTS.md`** = workflow rules
- **Grounding note** (external) = intent, audience, philosophy, foundational premises, durable loose threads
- **Per-conversation / task state** (current chat, task lists, in-flight context) = ephemeral; not durable
- **Private agent memory** (e.g. Claude Code's auto memory) = persistent but non-authoritative — a read-mostly operator cache, never a durable owner, and not the home for in-flight tracking; every mutation is governed by `AGENTS.md` §Learning Disposition and §Private-Memory Write Gate
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
