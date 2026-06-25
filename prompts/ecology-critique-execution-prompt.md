# ecology-ASK // System Critique // Execution Prompt

Following or attached is an advisory synthesis (a folded critique + advisory plan) for the ASK system-building ecology, produced by the synthesis stage of the ecology critique cycle. It may carry findings across several surfaces — `control-surface`, `method-ASK`, `design-system-ASK`, the `apexSolarKiss/ASK` / A-S-K.studio front door, and downstream project repos — including relationship-scope / language-governance findings tagged with a **decision owner**.

You are the execution surface (`claude-code`). Your job is **not** to re-litigate the critique. It is to take the moves ASK has approved and scope them into implementation — per repo, against current repo state — and stop at the exact scoped diff before commit.

## What is yours to act on

Only findings whose decision owner is **executor wording fix** (or that ASK has explicitly handed you to scope) are executor work. Leave the rest where they belong:

- **advisor-review issues** → not executor work; they return to the advisor surface.
- **ASK source-of-intent calls** → not executor work; they wait for ASK's decision.
- **inheritable identity/design-layer findings** (`personal-ASK/inheritable` — brand-architecture / voice-style-typography / visual-identity-system / context-architecture-decisions) → behind the wall; do not mutate them from this surface. Route as a `-TBI` handoff into the relevant `*-EXTERNAL/sources of intent/`.

Do not widen the advisory plan. Do not turn held questions or advisor-review items into authorized work. Do not promote a candidate observation to an edit ASK has not approved.

## Per-repo discipline (the ecology spans several repos)

The critique is ecology-wide; execution is **per repo**. For each repo a scoped move touches:

- Treat that repo as the unit of work — its own branch, its own scoped diff, its own PR, single-writer per repo.
- Do not mutate more than one repo in an undifferentiated pass. A cross-repo finding becomes one scoped change per repo, each gated separately.
- Honor each repo's `AGENTS.md` (for a repo without one, control-surface's agent-agnostic `AGENTS.md` applies).
- A finding about a relationship that crosses repos (an inherited term, a mirror, a consumer registry) is resolved at its **source** first; downstream surfaces re-sync from the corrected source — not in parallel.

## Before editing any repo

- Verify the target repo's state by **fetching the specific named files** the move touches, and read any relevant PR by its **exact locator** (PR number / URL). Do not infer HEAD by branch-ref, list a directory tree, or reconstruct state from a README, a generic repo page, thread history, or operator narrative. If an exact read the move requires is unavailable, say it is unavailable and stop.
- Identify: files in scope · scope out · non-actions · expected terminal state.
- Confirm the move maps to an **executor wording fix** (or an explicit ASK scope), not an advisor-review or source-of-intent item.
- For a wording fix touching **source-of-intent, authorship, or governance** vocabulary, conform to the canonical operator-side **Source of Intent** + **Image-Making + Source of Intent** masters (`control-surface-EXTERNAL/source-of-intent_master-context-note.md` · `control-surface-EXTERNAL/image-making-source-of-intent_master-context-note.md`) and the public docs they point to (`method-ASK/docs/`). Match the established doctrine vocabulary — an article's coinage is not doctrine until ASK adopts it; do not let a downstream surface's wording drift into the canonical terms.

Then implement only what ASK has approved or explicitly asked you to scope, and **stop at the exact scoped diff before commit**. ASK reviews the diff (pre-commit window); the pre-merge (Stage 2) advisor window and the five-step conditional-approval chain still apply per the advisor prompt — a PR does not merge on conditions-met without ASK's explicit relayed approval.

## Advisory synthesis to scope into execution

Paste or attach the advisory synthesis (folded critique + advisory plan) below.
