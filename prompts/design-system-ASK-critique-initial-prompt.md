# design-system-ASK // Repo Critique // Initial Prompt

Use this prompt to invoke an open-ended fresh-context critique of `apexSolarKiss/design-system-ASK` against its grounding note and the canonical identity layer it conforms to. It is the `repo-critique-initial-prompt` specialized for design-system-ASK — the same two-lens discipline, with a first-lens watch-list tuned to this repo's dominant failure class: **human-readable prose, comments, and examples drifting away from the resolved tokens and the canonical spec.**

## Read the current state of

- `apexSolarKiss/design-system-ASK` and its operator-side grounding note (`design-system-ASK-EXTERNAL/design-system-ASK_grounding-note.md`, or the mounted/uploaded mirror).
- The repo's own truth surfaces: `colors_and_type.css` (the Tier 1/2/3 token implementation), `README.md`, `SKILL.md`, `CONSUMERS.md`, `spectral-state.{css,md,html}`, `preview/styleguide.html`, the `patterns/*/` scaffolds and their READMEs (`diagram-static-{H,V,SEQ,FLOW}`, `diagram-interactive-spine`, `output-artifact`), `assets/`, `fonts/`, `LICENSE`.
- The operator-side consumer / propagation ledger (`design-system-ASK-EXTERNAL/design-system-ASK_consumer-ledger.md`).

## Conformance authority (the lens, not a critique target)

Read the critique **in the context of the ASK inheritable identity layer** — `personal-ASK/inheritable/` (`visual-identity-system.md`, `brand-architecture.md`, `voice-style-typography.md`, `context-architecture-decisions.md`), or the mounted/uploaded equivalents on a surface without filesystem access. That layer is the **authority this repo conforms to**, and the precedence is explicit:

- `visual-identity-system.md` is **source of truth for visual decisions** (palette, type, logo logic, gradient, foreground roles, rationale). It is a **dual-writer canonical**. On a spec decision it wins over the implementation.
- `brand-architecture.md` is **source of truth for the tier model** (Tier 1 / 2 / 3 and brand-distance resolution).
- The **repo wins only on implementation detail** (exact token name, CSS structure). The repo conforms to these files, not the reverse.

This authority layer is context for the critique, not itself a critique target.

## First lens — open observations + spec↔implementation conformance

Surface high-level observations — concerns, doubts, stale surfaces, missing source-of-intent, or things that do not make sense — anchored in the grounding note and the higher-level purpose articulated there. Then run this repo-specific watch-list, because the costly defects here have repeatedly been **a claim in prose/comment/example that contradicts the resolved token or the canonical spec** (a human reads the words; a downstream surface inherits them):

- **Spec ↔ implementation conformance.** For every value-or-relationship claim a human-readable surface makes — `README.md`, `SKILL.md`, `preview/styleguide.html`, pattern READMEs, **CSS comments**, sample/example markup — does it match (a) the **resolved** value of the token in `colors_and_type.css`, and (b) the canonical decision in `visual-identity-system.md` / `brand-architecture.md`? Watch the dimensions that have drifted before: foreground roles (default vs reserved high-contrast), the **gradient direction per mode**, the **wordmark-vs-body-text decoupling**, the named core palette set, tier assignments, Spectral State role names. A comment or sentence that mis-states a resolved value is a **real defect**, not cosmetic.
- **Render fidelity, both modes.** Would a literal reading of any token, comment, or worked example produce the wrong render in **light or dark**? Are there tokens whose comment describes a different resolved value than they hold? Is dark actually verified, not just light (and vice-versa)?
- **Boundary integrity.** No Tier-2 values fused into Tier-1 primitives; no Tier-3 bleed into Tier 2; Class A vs Class B held distinct (not fused or "drift-seam" framed); the Spectral State closed-palette **exception** scoped exactly (sole sanctioned color-bearing semantic-state primitive, not a general accent); the `output-artifact` "foreground inherited, no local `--fg` rebind" rule intact; scaffolds are consumption patterns, **not** generators/renderers/build-pipelines.
- **Provenance / propagation hygiene.** Does `CONSUMERS.md` stay **landed-only and pin-free** while the operator ledger holds the pins, re-sync obligations, and private/firewalled consumers? Are the four static `diagrams.css` byte-uniform? Where a claim of currency rests on a pin label, is the **actual vendored byte-state** consistent with it? Is the dual-writer canonical relationship stated and honored (canonical-before-mirror, snapshot at byte-parity)?

What additional ASK source of intent, direction, repo cleanup, grounding-note refresh, or downstream handoff is needed next to keep developing this repo toward its higher-level purpose?

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

**Identify yourself first.** State who is producing this critique — the **executor (`claude-code`)** or an **independent advisor (`advisor-gpt`, `advisor-claude`)**. This identity is **required**: when more than one surface critiques the same repo in a cycle, the source token is the only thing that tells the critiques apart. A critique delivered with no source — named just `…critique.md` — is not acceptable.

Deliver the critique in two forms:

1. **In reply** — the full critique inline in your response, opened with a `By:` line (e.g. `By: claude-code`).
2. **As a saved Markdown artifact** — the same critique as a standalone `.md` file, beginning with the same `By:` line:
   - **If you can write files** (a file-capable executor, e.g. Claude Code): save it into the repo's operator-side scratch, `design-system-ASK-EXTERNAL/scratch/`.
   - **If you cannot save directly** (a save-blocked advisor): emit it as a downloadable `.md` file, same filename, for the operator to place there.

Name the file per the protocol below — the **`<source>` token is required**. (ASK's file-naming conventions live in the context-architecture ADR every surface carries in context; this is the critique-output form.)

`YYYY-MM-DD_design-system-ASK_repo-critique-<source>[-rN].md`

- `<source>` — `claude-code` (executor), `advisor-gpt` / `advisor-claude` (advisors); add `-rN` when the same source issues a revised artifact.
- examples: `2026-06-26_design-system-ASK_repo-critique-claude-code.md` · `2026-06-26_design-system-ASK_repo-critique-advisor-gpt.md`
