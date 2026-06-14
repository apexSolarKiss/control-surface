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

## Second lens — read the architecture for what its language *governs*

The pass above catches stale surfaces, missing intent, and claims that don't add up. It reliably *misses* a quieter class: prose that reads fine but **mis-scopes a relationship** — wording that classifies who depends on whom, what inherits what, what is owned versus merely referenced, or what a rule covers, and gets that classification subtly wrong. One edit small, one topology large — because the surfaces downstream inherit the words, not the intent behind them.

The discipline in one line: **read the sentence for what it governs**, not for what it meant to say.

Run a second sweep with a different eye. Don't hunt for *where* — hunt for *what the words do*. Find the load-bearing terms that assert a relationship or a scope — the vocabulary of ownership, dependency, import, inheritance, source-of-truth, layer, consumer, mirror, and the quiet scope-setters (*all, every, only, project, downstream*) — and read each the way a stranger would six months from now: cold, literal, no conversation to fill the gaps. Then ask:

- What relationship does this actually create? What does it include — and what does it silently exclude or lump together?
- Does the scope it asserts match the real topology? Does an *every / all / project* over-claim, or does a real case fall outside a protection meant to cover it?
- If a downstream surface obeyed the sentence literally, would it inherit the relationship we *mean*, or a flattened version that erases a distinction the architecture depends on?
- Is the same word descriptive in one place and normative in another — asserting a relationship class it doesn't actually hold everywhere it appears?

The term list above is the *kind* of word to read for, not a checklist to walk — the real instances will be ones no one has named. The highest-value finding here is usually one word wide and systemic in implication.

This reading has its own failure mode — over-carving, defining everything, treating every ambiguity as a dispute. Resist it. Flag a scope/relationship issue only where a plausible literal reading would actually mis-govern something downstream, not for theoretical imprecision.

For each finding, name:

- the **term** and where it sits;
- the relationship it *should* express, and the one it *currently* expresses;
- the **decision owner** — whether resolving it is an **executor wording fix**, an **advisor-review issue**, or an **ASK source-of-intent call**.

These are candidate observations, not authorized edits.

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
