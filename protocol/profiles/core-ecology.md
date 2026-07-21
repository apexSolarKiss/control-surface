# Profile — core-ecology

**Applies to:** `control-surface · method-ASK · design-system-ASK · personal-context-system · ASK` (the five-repo directly-operated ecology surface).
**Explicit exclusions:** `asset-pipeline-ASK · urban-observatory` (separately-operated downstream consumers).
**personal-context-system:** applicable, no carrier yet (no root `AGENTS.md`) — *applicable-no-carrier*, not an exclusion; held outside Wave 1 (see the ledger's PCS disposition).

*Owner explanation above is metadata and is NOT carried into a consumer. A consumer that adopts this profile carries only the fenced distributable body below, wrapped in `<!-- BEGIN profile: core-ecology -->` / `<!-- END profile: core-ecology -->` at byte parity.*

<!-- BEGIN profile-body: core-ecology -->
## Ecology intake specifics

- The core ASK ecology is a **declared multi-repo operating surface**: its repos share one external operating surface (`ecology-ASK-EXTERNAL/` for the studio repos; per-repo `<project>-EXTERNAL/` remains the ordinary standalone convention) while repo authority, grounding notes, and workflows remain separate.
- Routed handoffs into this surface land in the **shared intake** `ecology-ASK-EXTERNAL/sources of intent/` with `-TBI`; recipient-side ingestion renames off `-TBI` in place and records the closure in the **shared ecology scratch** `ecology-ASK-EXTERNAL/scratch/`.
- **Movement between the five core repos is a hard repo-boundary reset**, not an ingestion event: read the destination repo's grounding note and `AGENTS.md`, verify live state, and work under its own branch / diff / review / merge gates. Do **not** create a `-TBI` addressed to a surface this surface already operates.
- **Physical co-location does not merge repo authority.** Sharing one external directory does not transfer decision ownership; resulting actions follow each owning repo's or canonical's governing workflow.
- The current membership of the directly-operated core is **operator-side topology, not repo truth**; the operator canonical is authoritative on which surfaces are in it. `-TBI` applies to material crossing between separately-operated or walled surfaces.

Method-altitude articulation: `method-ASK/docs/source-of-intent.md` §Inbound handoff TBI marker.
<!-- END profile-body: core-ecology -->
