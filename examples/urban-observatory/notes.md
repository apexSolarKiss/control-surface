# urban-observatory Notes

`apexSolarKiss/urban-observatory` is the second single-node working example for the control-surface workflow. `apexSolarKiss/asset-pipeline-ASK` is the mature single-node working example and primary pressure surface for rule evolution; `apexSolarKiss/mazeASK` is the legacy Model A working example, still active for that project.

## Operating Model

Single-node — Claude Code is both control surface and executor. GPT is used as advisor outside the execution thread.

The project was instantiated under the single-node default rather than migrating from Model A.

## Lifecycle Stage

Early — past instantiation and initial bootstrap, currently in prototype planning. The target repo exists and carries the initial implementation-intelligence foundation; repo-local docs are now internally coherent after a scoped drift-cleanup pass. Prototype data, schemas, notebooks, and reports have not yet been produced.

## What This Example Surfaced For The Meta Repo

- **Source-of-intent recovery as a pre-repo phase.** The project began from multi-round source-of-intent reconciliation across saved conversation captures and operator-side review syntheses before any repo file was written. This pressures the meta repo's framing of the instantiation phase as more than a single startup prompt: source-of-intent recovery is itself a load-bearing pre-repo move when the project's intent lives diffused across prior captures rather than in a single ready brief.
- **Validation before repo prose.** Operator-validated source-of-intent material was held in operator-side scratch and grounding-note revisions until validated, rather than being converted directly into repo prose. The discipline preserves the boundary between operator-side validation work and repo-local truth.
- **Post-bootstrap grounding-note freshness failure / fix.** The grounding note carried repo-state chronology, current-task sequencing, and "future repo" language past the moment the repo began to exist. A corrective pass revised the grounding note to point to repo state rather than track it, preserving durable source-of-intent and removing the fast-aging material. The failure mode is general: a grounding note carried over from pre-repo phase can accumulate state-tracking material that the repo should own once it exists.
- **Repo-local drift cleanup after validated v0 direction.** Once the v0 direction was validated, earlier repo-local docs still carried open / unresolved framing from before validation. A scoped cleanup pass aligned repo docs without changing strategy, creating schemas, or expanding scope. The failure mode is general: validated direction may land at the grounding-note layer before repo-local docs catch up, and the catch-up pass is its own scoped unit of work.
- **Architecture-uncertain overlay pressure.** The project has an explicit `Assumption → ImplementationSignal → ImplementationFinding → InterventionCandidate` ontology direction with working-hypothesis posture and explicit deferral of final schema commitment. This profile — active architectural uncertainty, ontology-first work, refusal of premature schema doctrine — is the audience for which the meta repo's held question about an opt-in architecture-uncertain overlay would apply.

These observations are upstream evidence for meta-repo work. Absorption of any specific lesson into rules, templates, or prompts is held until the corresponding scoped change is opened.
