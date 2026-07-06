# ecology-ASK // System Critique // Initial Prompt

Use this prompt to invoke an open-ended fresh-context critique of the ASK system-building ecology. For how this critique is instantiated — the two fresh-context mechanics by executor type, and the rule that a filesystem executor reads the operator-side packages directly while a connector advisor needs them mounted or must declare them not-reviewed — see `docs/critique-protocol.md`.

**Declare the coverage band first.** Open the critique by stating what it covers and what it does not — e.g. `band: core ecology (control-surface · method-ASK · design-system-ASK · ASK front door) + publication/propagation drift; downstream deep-state excluded except AP/UO front doors`. Without a declared band, successive passes drift toward coverage-theater (implying total coverage while sampling). The band is an honesty instrument, not a scope cap.

Review the current state of:

- `apexSolarKiss/control-surface` and its grounding note
- `apexSolarKiss/method-ASK` and its grounding note
- `apexSolarKiss/design-system-ASK` and its grounding note
- `apexSolarKiss/ASK` / `A-S-K.studio` — ASK public front door and live `design-system-ASK` reference implementation; treat as a public identity surface, not a downstream domain project pressure surface
- the relevant downstream ASK project repos and their grounding notes, when attached or routed into the critique context

Anchor the critique in the repo materials, the grounding notes, and the higher-level purpose articulated there.

Read the critique **against the ASK inheritable identity/design layer** — `personal-ASK/inheritable` (`brand-architecture.md`, `voice-style-typography.md`, `visual-identity-system.md`, `context-architecture-decisions.md`, plus any other mounted/uploaded inheritable files). This layer is **both**: (1) the **conformance authority** for brand, tier model, voice, visual identity, naming grammar, and context architecture; **and** (2) a **scoped critique target** — as of 2026-06-27 **the whole `inheritable/` layer is dual-writer**, so **every file inside `personal-ASK/inheritable/` is a valid ecology-critique target** (`context-architecture-decisions.md` (ADR) · `brand-architecture.md` · `visual-identity-system.md` + `.html` · `voice-style-typography.md` · `asymptotic-system-key.md` · `reading-interests.md` · `devices.md`). Findings against any of them **may be raised directly** — they are still **not authorized edits** until ASK approves, and any execution follows the dual-writer controls (offline canonical first · one writer per file per session · explicit ASK authorization · dated `ZZZ-ASK/` snapshot at byte-parity · mounted mirrors refreshed after canonical; **the ADR additionally syncs its byte-identical `personal-TMK` twin**). Per-file nuances when critiquing: `visual-identity-system.html` is a derived companion (resolve findings against the `.md`); `brand-architecture.md` is mirror-not-lead for its public upstream — the **ASK site / `apexSolarKiss/ASK` repo** since the 2026-06-27 source-of-truth flip; **Notion is legacy/staging, no longer the public upstream** (govern the file, not its upstream). Mark the **decision owner** for each finding (ASK source-of-intent · advisor review · executor wording fix). **Two axes — valid critique target ≠ downstream-conformance target:** being in `inheritable/` makes a file a valid critique *target* (wall-safe + dual-writer-governable); it does **not** make it **`ecology-consumed`** — the narrower, explicitly named downstream-read / conformance relationship. The stable identity/architecture conformance subset is the ADR · `brand-architecture.md` · `visual-identity-system.md` · `voice-style-typography.md`; other inheritable files are context unless a source explicitly names a consumer relationship. For a non-consumed file (`devices.md`, `reading-interests.md`, `asymptotic-system-key.md`), critique internal coherence / wall-safety / source-of-truth hierarchy / file-header governance — **do not invent downstream conformance obligations.** The **private layer outside** `personal-ASK/inheritable/` remains out of scope — never read, summarized, inferred, or depended on.

Read the critique **also in the context of the current operator-side source-of-intent canonicals** — the **Source of Intent** master (`control-surface-EXTERNAL/source-of-intent_master-context-note.md`) and its **Image-Making + Source of Intent** branch (`control-surface-EXTERNAL/image-making-source-of-intent_master-context-note.md`), or their mounted/uploaded mirrors where filesystem access is unavailable. These are the ecology's **evidence, synthesis, and domain-branch context** for source of intent, authorship, governance, and the relationship-scope lens below; they are context for the critique, **not themselves a competing public-doctrine surface**. For public method claims, `method-ASK` governs through `docs/normative-apex.md`, `docs/governance.md`, `docs/source-of-intent.md`, `docs/bounded-generativity.md`, and `examples/image-making-source-of-intent.md`.

Read the critique **also against the operator-side propagation + publication trackers**: the **Substack / workflow article tracker** (root-canonical at `control-surface-EXTERNAL/workflow-substacks_master-tracker.md`, the durable mirror of the latest scratch `_vN` snapshot) — the public essay line is an active method / source-of-intent expression surface, so a critique that ignores it misses publication-state and reception-state drift; and the **design-system-ASK operator-side consumer ledger** (`design-system-ASK-EXTERNAL/design-system-ASK_consumer-ledger.md`) — the canonical record of **local / private / firewalled design-system consumers**, vendored pins, drift, and re-sync obligations that the public `CONSUMERS.md` (landed-public-only) does not show. Both are operator-side context for the critique, not critique targets; they exist so the critique reads the **real propagation + publication map**, not only the public repo surfaces.

Read also the current **operator-side ecology diagram packages** (root-canonical, at the `method-ASK-EXTERNAL/` root): `method-ASK-EXTERNAL/system-ASK-topology/` (D03 — topology / ontology / IA map) and `method-ASK-EXTERNAL/ecology-ASK-inheritance-permissions/` (D04 — the wall + grant boundary, consumer-scope inheritance classes, direct-operation-vs-`-TBI` boundary). Treat them as **illustrative operator-side topology artifacts**: context for the critique and for the relationship-scope findings below, **not repo truth and not automatic doctrine**. Each package's `VERSION.md` carries its render/content status (D04 is currently `source-v3 // render-v3`); canonical prose wins where they disagree. They are a legitimate second-lens target for whether the diagram's own language over-exposes the wall or mis-scopes the grant boundary. **If the D03/D04 package files are unavailable in a given surface, state that limitation explicitly and do not claim to have reviewed their rendered language** (the same read-path honesty as for repo files and PRs).

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
