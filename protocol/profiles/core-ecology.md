# Profile — core-ecology

**Applies to:** `control-surface · method-ASK · design-system-ASK · personal-context-system · ASK` (the five-repo directly-operated ecology surface).
**Explicit exclusions:** `asset-pipeline-ASK · urban-observatory` (separately-operated downstream consumers).
**personal-context-system:** applicable, no carrier yet (no root `AGENTS.md`) — *applicable-no-carrier*, not an exclusion; held outside Wave 1 (see the ledger's PCS disposition).

*Owner explanation above is metadata and is NOT carried into a consumer. A consumer that adopts this profile carries only the fenced distributable body below, wrapped in `<!-- BEGIN profile: core-ecology -->` / `<!-- END profile: core-ecology -->` at byte parity.*

<!-- BEGIN profile-body: core-ecology -->
## Ecology intake specifics

- The core ASK ecology is a **declared multi-repo operating surface**: its repos share one external operating surface (`ecology-ASK-EXTERNAL/` for the studio repos; per-repo `<project>-EXTERNAL/` remains the ordinary standalone convention) while repo authority, grounding notes, and workflows remain separate.
- Routed handoffs into this surface land in the **shared intent inbox at the exact live path declared by the surface's current `_INDEX` and `_LAYOUT`**, carrying `-TBI`; recipient-side ingestion renames `-TBI` to `-ingested` in place. The target post-cutover convention is `ecology-ASK-EXTERNAL/intent-INbox/` with `_STATE.md` as its structural inbox-state carrier — read immediately before ingestion, where `OPEN` permits ordinary governed ingestion, `FROZEN` blocks every routed artifact absent an exact-filename exception, and `PARTIAL-HOLD` blocks only the named scope on the same exact-filename terms. **Until the surface cutover is recorded, the current mapped path remains required and operative**; only absence of the *target* `intent-INbox/` plane and its `_STATE.md` is permitted pre-cutover. When a disposition requires a durable record, that record is written in the **shared ecology scratch** `ecology-ASK-EXTERNAL/scratch/` in the same bounded operation as the terminal rename. A co-located `-supersededA` intake artifact is retired lineage — never queue membership and never an ingestion event.
- **Movement between the five core repos is a hard repo-boundary reset**, not an ingestion event: read the destination repo's grounding note and `AGENTS.md`, verify live state, and work under its own branch / diff / review / merge gates. Do **not** create a `-TBI` addressed to a surface this surface already operates.
- **Physical co-location does not merge repo authority.** Sharing one external directory does not transfer decision ownership; resulting actions follow each owning repo's or canonical's governing workflow.
- The current membership of the directly-operated core is **operator-side topology, not repo truth**; the operator canonical is authoritative on which surfaces are in it. `-TBI` applies to material crossing between separately-operated or walled surfaces.

Method-altitude articulation: `method-ASK/docs/source-of-intent.md` §Inbound handoff TBI marker.
<!-- END profile-body: core-ecology -->
