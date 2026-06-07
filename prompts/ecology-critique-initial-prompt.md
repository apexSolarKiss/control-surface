# ecology-ASK // System Critique // Initial Prompt

Use this prompt to invoke an open-ended fresh-context critique of the ASK system-building ecology.

Review the current state of:

- `apexSolarKiss/control-surface` and its grounding note
- `apexSolarKiss/method-ASK` and its grounding note
- `apexSolarKiss/design-system-ASK` and its grounding note
- the relevant downstream ASK project repos and their grounding notes, when attached or routed into the critique context

Anchor the critique in the repo materials, the grounding notes, and the higher-level purpose articulated there.

Surface high-level observations — concerns, doubts, tensions, stale surfaces, missing source-of-intent, or things that do not make sense.

What additional ASK source of intent, direction, repo cleanup, grounding-note refresh, or downstream handoff is needed next to keep developing the ASK ecology toward its higher-level purpose?

## Delivery

**Identify yourself first.** State who is producing this critique — the **executor (`claude-code`)** or an **independent advisor (`advisor-gpt`, `advisor-claude`)**. This identity is **required**: when more than one surface critiques the same ecology in a cycle, the source token is the only thing that tells the critiques apart. A critique delivered with no source — named just `…critique.md` — is not acceptable.

Deliver the critique in two forms:

1. **In reply** — the full critique inline in your response, opened with a `By:` line (e.g. `By: advisor-gpt`).
2. **As a saved Markdown artifact** — the same critique as a standalone `.md` file, beginning with the same `By:` line:
   - **If you can write files** (a file-capable executor, e.g. Claude Code): save it into the ecology operator-side scratch, `control-surface-EXTERNAL/scratch/`.
   - **If you cannot save directly** (a save-blocked advisor): emit it as a downloadable `.md` file, same filename, for the operator to place there.

Name the file per the protocol below — the **`<source>` token is required**. (ASK's file-naming conventions live in the context-architecture ADR every surface carries in context; this is the critique-output form.)

`YYYY-MM-DD_ecology-ASK_ecology-critique-<source>[-rN].md`

- `<source>` — `claude-code` (executor), `advisor-gpt` / `advisor-claude` (advisors); add `-rN` when the same source issues a revised artifact.
- examples: `2026-06-07_ecology-ASK_ecology-critique-claude-code.md` · `2026-06-07_ecology-ASK_ecology-critique-advisor-gpt-r2.md`
