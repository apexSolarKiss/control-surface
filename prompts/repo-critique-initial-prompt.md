# Repo Critique Initial Prompt

Use this prompt to invoke an open-ended fresh-context critique of a repo against its grounding note.

Review the current state of the repo and surface high-level observations — concerns, doubts, or things that do not make sense — anchored in the grounding note and the higher-level purpose articulated therein.

What additional external operator source of intent or direction is needed next to keep developing this repo toward its higher-level purpose as articulated in the grounding note?

## Delivery

**Identify yourself first.** State who is producing this critique — the **executor (`claude-code`)** or an **independent advisor (`advisor-gpt`, `advisor-claude`)**. This identity is **required**: when more than one surface critiques the same repo in a cycle, the source token is the only thing that tells the critiques apart. A critique delivered with no source — named just `…critique.md` — is not acceptable.

Deliver the critique in two forms:

1. **In reply** — the full critique inline in your response, opened with a `By:` line (e.g. `By: advisor-gpt`).
2. **As a saved Markdown artifact** — the same critique as a standalone `.md` file, beginning with the same `By:` line:
   - **If you can write files** (a file-capable executor, e.g. Claude Code): save it into the repo's operator-side scratch, `<repo>-EXTERNAL/scratch/`.
   - **If you cannot save directly** (a save-blocked advisor): emit it as a downloadable `.md` file, same filename, for the operator to place there.

Name the file per the protocol below — the **`<source>` token is required**. (ASK's file-naming conventions live in the context-architecture ADR every surface carries in context; this is the critique-output form.)

`YYYY-MM-DD_<repo>_repo-critique-<source>[-rN].md`

- `<source>` — `claude-code` (executor), `advisor-gpt` / `advisor-claude` (advisors); add `-rN` when the same source issues a revised artifact.
- examples: `2026-06-07_urban-observatory_repo-critique-claude-code.md` · `2026-06-07_urban-observatory_repo-critique-advisor-gpt.md`
