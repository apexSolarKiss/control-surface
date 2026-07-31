# Advisor Project Surface Architecture

How a non-writing advisor surface is deployed into a hosted AI Project — what binds before any file is read,
what the Project mounts, where the retrieval map lives, and how the advisor contract is versioned without
losing requirements.

This document owns the **semantic contract** for advisor surfaces. The templates in `templates/` are generated
from it; they are not independent sources.

Related: [`docs/critique-protocol.md`](critique-protocol.md) (fresh-context critique vs. the standing advisor
role) · [`docs/architecture.md`](architecture.md) (the operating model) ·
[`templates/advisor-project-bootstrap.template.md`](../templates/advisor-project-bootstrap.template.md) ·
[`templates/advisor-project-instructions.template.md`](../templates/advisor-project-instructions.template.md) ·
[`templates/_INDEX-project.template.md`](../templates/_INDEX-project.template.md).

---

## The problem this architecture solves

A hosted Project offers two places to put an advisor contract: an always-applied **Instructions field** with a
hard character limit (~8,000 on the current host), and **mounted Sources**. Putting the operative protocol in
the Instructions field creates two failures that compound.

**Two mutable carriers.** Protocol in the field *and* a mounted retrieval map means one conceptual change
requires two manual installations per Project. Half-updated deployments are then possible, and likely.

**A carrier that cannot grow.** The field has a ceiling. Once it is reached, adding protocol requires removing
protocol — a preservation judgment made under space pressure, at the moment of least attention, with no record
of what was dropped.

The second failure is the serious one, and it is not hypothetical. See
[`docs/advisor-surface-compression-loss.md`](advisor-surface-compression-loss.md) for the audited record: on
the ASK deployments, **eight semantic requirements were no longer fully carried — four wholly absent, four
surviving only in weakened form — and four further requirements existed in this repo's template but were never
propagated into any deployment.** Surfaces instantiated after the compression inherited its gaps as birth
defects rather than losing anything themselves.

## The architecture

```text
Project Instructions field   thin, stable, always applied
      │                      the pre-retrieval floor — what must bind before any fetch, including when
      │                      every fetch fails
      ▼
mounted bootstrap            one standing Markdown Source, no Instructions-field ceiling
      │                      the full advisor contract + the exact live index locator
      ▼
live-fetched index           the retrieval map; NOT mounted in healthy connector mode
      │
      ▼
canonicals                   grounding note · repo truth · protocol owners · ledger · review objects
```

**One standing mount.** The bootstrap is the only Markdown Source a healthy connector-mode Project mounts.
The index is fetched at the exact locator the bootstrap declares. Canonicals are fetched at the exact locators
the index declares.

**One self-contained bootstrap per surface**, generated from one template plus that surface's overlay
parameters. Do not mount a shared core plus a separate overlay: two mounts is another synchronization seam,
and it makes connector-failure behavior harder to reason about. Share at the *authoring* layer; be
self-contained at the *runtime* layer.

**Maintenance consequence.** An ordinary protocol change updates one bootstrap and remounts it. An ordinary
index change updates a canonical and remounts nothing. The Instructions field is repasted only when the
invocation architecture itself changes.

## Placement contract

Each requirement has **one authoritative owner** and **one or more explicitly declared deployment homes**. A
requirement may be co-homed — most often PI-FLOOR *and* BOOTSTRAP, where the floor states the minimal form that
must survive a retrieval failure and the bootstrap states the operative form. A generated bootstrap is
self-contained: it repeats the role and authority boundary rather than deferring to the Instructions field.
The registry must describe what each carrier actually says.

| Home | Holds | Test |
|---|---|---|
| **PI-FLOOR** | what must bind before any retrieval, and must still hold when retrieval fails | *Would the surface be unsafe if this were unavailable during a connector outage?* |
| **BOOTSTRAP** | the operative advisor contract | everything else that governs advisor behavior |
| **INDEX** | where things live, their status class, and wall/search rules | it is a map, not a rule |
| **SURFACE-OVERLAY** | one project's specifics, carried inside that project's generated bootstrap | it would be wrong on another surface |

The PI floor is deliberately small. It is not a summary of the bootstrap — it is the subset whose absence
would make a connector outage into an authority outage.

## Anti-loss invariant

**A requirement may leave a carrier only with a recorded disposition.** One of:

```text
MOVED           the exact surviving carrier, named, plus the requirement ID
REVISED         the replacement requirement ID and the reason
RETIRED         the architectural reason and the approval basis
NOT-APPLICABLE  the surface and the reason
```

Therefore: **`DROP-AS-DUPLICATE` without an exact named surviving carrier is not deduplication — it is
deletion.** This single rule is what the earlier compressions lacked, and applying it would have prevented
both the original loss and its propagation into surfaces instantiated later.

A requirement is *unowned* if no carrier holds it and no disposition retired it. Unowned count must be zero.

## Version and change-history discipline

The bootstrap is not held to the Instructions field's ceiling, which creates the opposite risk: an ever-growing banner turning the
entry point into front-door noise. Split the lineage by aging rate.

```text
live bootstrap        current version · Supersedes · current Why-vN summary only
review object / PR    complete ADDED · REVISED · REMOVED-with-surviving-carrier for that revision
_vN snapshot          the exact historical bytes
```

Every bootstrap revision produces a semantic coverage delta in its **review record**. Prior deltas stay in
snapshots and review history; they are never concatenated into the live entry point.

## Binding and cross-surface relation

This document is the **owner**. Owning a rule does not bind anyone to it — a consumer is bound only by a
carrier it actually resolves. The binding carrier is the `advisor-project-surface` profile
([`protocol/profiles/advisor-project-surface.md`](../protocol/profiles/advisor-project-surface.md), registered
in [`protocol/manifest.json`](../protocol/manifest.json) as `advisor-project-surface-deployment`).

```text
owner        docs/advisor-project-surface-architecture.md   registry · placement · tests · gate
carrier      protocol/profiles/advisor-project-surface.md   compact distributable obligation
applies_to   control-surface · asset-pipeline-ASK · urban-observatory
live binding each repo is bound only when its AGENTS.md resolves the profile;
             installed state is recorded in the operator ledger
generated    templates/advisor-project-{bootstrap,instructions}.template.md · _INDEX-project.template.md
```

The profile carries the **deployment shape** — bootstrap-only placement, the anti-loss invariant, the single
standing mount, the maintenance consequence. It deliberately does not restate the full requirement registry or the full
bootstrap contract; those stay here, fetched at this path, and a consumer's carrier grows by one section
rather than by this document's length.

**Applicability follows the Project, not the tier.** A repo is in `applies_to` because it homes a hosted
advisor Project — not because it is important, upstream, or directly operated. `method-ASK`,
`design-system-ASK`, `ASK`, and `personal-context-system` are excluded on that test alone; a repo that later
stands up an advisor Project adopts the profile then. The exclusion is a statement about deployment, never
about whether the invariant is correct.

**One repo may home more than one hosted Project, and applicability attaches to the Project's role.**
`urban-observatory` homes two: an ASK-facing repo-advisor Project, and a separate TMK-facing
domain-authority review Project. `applies_to` naming the repo binds its **ASK-facing repo-advisor** Project to
the `advisor-project-surface` profile; it does not assign that role to every hosted Project associated with the
repo — a second Project remains governed by this semantic owner document without becoming an
`advisor-project-surface` profile consumer. A second Project with a
different audience and a different authority topology is governed by its own overlay plus the protocol that
owns its review class — see §Hosted domain-authority review variant. **Audit each hosted Project
independently**; a requirement absent from one because its role does not carry it is not a gap in the other.

Because `check.sh` derives required profiles from `applies_to`, a repo added to that list **fails its carrier
check until it resolves the profile.** That gap is the intended fail-closed signal, not a defect: the interval
between registering applicability and resolving the carrier is exactly the interval in which a consumer
believes it is covered and is not.

**Cross-surface relation.** Bootstrap-only connector deployment is a cross-surface architecture invariant, and
this is not its only implementation. Personal-context Projects implement the same invariant under the personal
ADR and the PCS scaffold; repo-advisor Projects implement it here, under this architecture and the
`advisor-project-surface` profile. In both, the always-applied field carries only the pre-retrieval safety
floor, one mounted bootstrap carries the operative contract and the exact live-index locator, and the index
and canonicals are fetched live.

Sharing the invariant does not merge authority, widen a wall, make either implementation the owner of the
other, or require one bootstrap payload to cross surfaces. This document does not govern personal-context
Projects, and it is not amended by changes to the personal ADR. Reciprocal owner references record the shared
invariant, but neither implementation governs or mutates the other. ASK, as apex, adjudicates any divergence.

## Hosted domain-authority review variant

A hosted Project may exist to carry a **domain authority's** judgment rather than to advise the operator. It
uses the same deployment shape as a repo-advisor Project — thin Instructions floor, one mounted bootstrap,
live-fetched scoped index, standing canonicals plus an operator-fed review packet — and **not** the repo-advisor
role. Its authority topology is owned by [`docs/domain-authority-review-protocol.md`](domain-authority-review-protocol.md),
which operationalizes method-ASK's `docs/governance.md` (domain authority as a bounded instance of delegated
discretion) and `docs/source-of-intent.md` (stage-aware, claim-level classification of domain-authority
handoffs).

The distinction is who is in the thread and whose judgment the surface carries:

```text
repo-advisor Project        ASK is in the thread; the surface challenges the operator's own reasoning
domain-authority Project    the domain authority is in the thread; ASK operates the surface for them
```

That inverts several assumptions the shared registry makes. In this variant:

- **ASK operates and configures the Project and feeds the review packets.** The domain authority does not
  administer the surface, and the surface is not an ASK proxy, a second operator, or an independent project
  authority.
- **The domain authority is the human in the thread, and the authority within their named domain.** The surface
  helps them develop, pressure-test, and articulate judgment. It does not supply the judgment, and synthesis
  never substitutes for their words where those words are load-bearing.
- **ASK remains project architect, operator, relay, and the final adoption / authorization / publication /
  closure authority.** Returned material reaches execution only through ASK's relay.
- **Review packets are self-contained and carry the per-review stage contract** — current stage, the decisions
  open, and the commitments held out of scope. The surface follows the packet's orchestration and does not
  improvise a decision interview from an un-orchestrated flat memo.
- **Returned claims are classified claim by claim, not adopted whole-artifact.** One handoff may carry a binding
  domain judgment and a premature implementation proposal at once; the first may bind, the second stays
  roadmap, scratch, or held architecture until ASK promotes it. **No review advances project stage by
  implication.**
- **Expertise confers no project authority.** Implementation architecture, execution, publication, and closure
  rights are named explicitly or they are absent.

Compactly: *the domain authority owns judgment within the declared aperture; ASK owns what that judgment means
for the project.*

**The profile instance is separable, and is currently held.** `urban-observatory` is the **first worked
instance** of the domain-authority review protocol. The manifest's `domain-authority-review-profile` remains
`status: held` with `applies_to: []`, under `hold-domain-authority-reviewer-format` pending a second
implemented pressure-test, and its own note says not to create an empty profile file for it yet — so **no
instantiated profile carrier exists.** The UO-TMK standing fields are therefore recorded in these overlay rows
and in the live surface carriers, without citing or manufacturing a profile instance. The distinction is
load-bearing:

```text
worked instance of the protocol   ≠   installed instance of the held profile
```

---

## Normative requirement registry

Columns: **ID** · **requirement** · **owner** (where the rule is authored) · **home** (where it is deployed) ·
**ruling** · **evidence/notes**. `deployed presence` records what the ASK deployments carried at the
2026-07-25 audit: `FULL` · `PARTIAL` · `ABSENT` · `TEMPLATE-ONLY`.

### ROLE — identity, authority, relay

| ID | Requirement | Owner | Home | Ruling | Deployed | Notes |
|---|---|---|---|---|---|---|
| ROLE-1 | This Project advises exactly one named surface; state which. | this doc | PI-FLOOR + BOOTSTRAP | PRESERVE | FULL | co-homed: the bootstrap is self-contained |
| ROLE-2 | Non-writing: do not mutate repos, connector storage, Project settings, or canonicals. | this doc | PI-FLOOR + BOOTSTRAP | PRESERVE | FULL | co-homed |
| ROLE-3 | Every write routes through the executor on ASK's relay; advisor output is not operative before relay. | shared protocol | PI-FLOOR + BOOTSTRAP | PRESERVE | FULL | co-homed |
| ROLE-4 | The advisor is not a substitute for the source-of-intent nudge path or the fresh-context critique cycle. | `critique-protocol.md` | BOOTSTRAP | PRESERVE | TEMPLATE-ONLY | |
| ROLE-5 | Useful-for conditions: differently situated pressure · ceremony challenge · grounding-note premise pressure · source-of-intent boundary checks · drift detection. | this doc | BOOTSTRAP | PRESERVE | PARTIAL | compressed to four verbs in deployment |

### MODEL — operating model

| ID | Requirement | Owner | Home | Ruling | Deployed | Notes |
|---|---|---|---|---|---|---|
| MODEL-1 | Adversarial collaboration — an ASK-apexed advisor–executor topology: ASK is authorization apex and relay; a non-writing advisor surface; a repo-attached execution surface. | `docs/architecture.md` | PI-FLOOR (identity) + BOOTSTRAP (detail) | PRESERVE | FULL | landed 2026-07-25 |
| MODEL-2 | Direct execution is a bounded task-level path, not a separate model and not the absence of a configured advisor. | `docs/architecture.md` | BOOTSTRAP | PRESERVE | FULL | |
| MODEL-3 | The surfaces are **differently situated**, not independent: the advisor supplies adversarial pressure from outside execution momentum. They are correlated; named canonicals and exact repo state arbitrate factual disagreement, ASK adjudicates authority. | this doc | BOOTSTRAP | REVISE | TEMPLATE-ONLY | revises T1 "outside the executor's context bias" — that phrasing overstated independence |

### SOURCE — source of truth

| ID | Requirement | Owner | Home | Ruling | Deployed | Notes |
|---|---|---|---|---|---|---|
| SOURCE-1 | Read order: grounding note → repo truth → protocol owners → project-specific external systems. | this doc | BOOTSTRAP | PRESERVE | FULL | |
| SOURCE-2 | The grounding note is external context, not repo truth; the repo owns project truth. | shared protocol | BOOTSTRAP | PRESERVE | FULL | |
| SOURCE-3 | Do not produce polished synthesis that substitutes for validation by the human source of intent. | this doc | BOOTSTRAP | PRESERVE | TEMPLATE-ONLY | |
| SOURCE-4 | Exact repo/canonical state arbitrates factual disagreement. | shared protocol | BOOTSTRAP | PRESERVE | FULL | |

### READ — retrieval discipline

| ID | Requirement | Owner | Home | Ruling | Deployed | Notes |
|---|---|---|---|---|---|---|
| READ-1 | Fetch by exact locator. Prefer exact-path fetch; reserve search for genuine discovery. | this doc | BOOTSTRAP + INDEX | PRESERVE | FULL | |
| READ-2 | The live canonical is the source of truth; mounted or uploaded copies are point-in-time fallback and lose authority when live access returns. **Mounted-source display labels are inspection metadata, not source identity.** A host-added filename decoration does not establish a duplicate local file, multiple standing mounts, or incorrect mounted bytes. Verify standing-source cardinality and mounted content/version; use exact bytes or hashes where identity is load-bearing. An already-running conversation may continue surfacing content previously brought into that thread after a remount; treat that as possible thread-context staleness, not proof that the current upload failed. | this doc | BOOTSTRAP + INDEX | REVISE (extended) | n/a (revised) | display-label identity limb added 2026-07-30 (P2-3), vendor-neutral; current product-specific display behavior stays in the live ecology index as an explicitly expiring note, never in this slow owner |
| READ-3 | **Historical chronology in repo prose, chat, or prior sessions is evidence, not current state.** Verify current claims from named live owners. | this doc | BOOTSTRAP | RESTORE (revised) | ABSENT | restores L1; revised from "ignore embedded handoff chronology — verify fresh" |
| READ-4 | Session memory is a stale base against a live read. | this doc | BOOTSTRAP | PRESERVE | FULL | |
| READ-5 | Never infer HEAD from commit search. | this doc | BOOTSTRAP | PRESERVE | TEMPLATE-ONLY | |
| READ-6 | Never reconstruct directory state from README prose. | this doc | BOOTSTRAP | PRESERVE | TEMPLATE-ONLY | |
| READ-7 | Search hygiene: a broad search surfaces filenames from private/archive trees even where content reads are blocked. | this doc | BOOTSTRAP + INDEX | PRESERVE | FULL | |
| READ-8 | Fetching does not promote, canonicalize, publish, or change status — header and path govern. | shared protocol | BOOTSTRAP | PRESERVE | FULL | |

### WALL — authorized surface

| ID | Requirement | Owner | Home | Ruling | Deployed | Notes |
|---|---|---|---|---|---|---|
| WALL-1 | Read only paths the index names or ASK names explicitly; never browse private personal roots. | shared protocol | PI-FLOOR (minimal) + BOOTSTRAP + INDEX | PRESERVE | FULL | |
| WALL-2 | Manual upload never crosses or bypasses a wall. Path authorization is not content authorization. | shared protocol | BOOTSTRAP | PRESERVE | FULL | |
| WALL-3 | Outside the authorized read surface: stop and ask ASK. | shared protocol | PI-FLOOR + BOOTSTRAP | PRESERVE | FULL | |

### PROTO — shared-protocol preflight

| ID | Requirement | Owner | Home | Ruling | Deployed | Notes |
|---|---|---|---|---|---|---|
| PROTO-1 | For rule-placement, `AGENTS.md`/`CLAUDE.md`, private-memory, reusable-learning, grant, or propagation questions: read the protocol owner model, shared body, manifest, the repo's resolved `AGENTS.md`, and the live consumer ledger. | shared protocol | BOOTSTRAP | PRESERVE | FULL | absorbs retired RET-1 |
| PROTO-2 | Never substitute memory, hand copies, or local paraphrase for owner placement and live propagation state. | shared protocol | BOOTSTRAP | PRESERVE | FULL | |
| PROTO-3 | **Executor-carrier delivery.** Where a repo's executor receives the resolved `AGENTS.md` carrier through a runtime adapter, verify the current adapter/import state. Reading `AGENTS.md` establishes carrier *contents*; it does not establish that the executor *loads* those contents. | shared protocol | BOOTSTRAP | PRESERVE | FULL | separate fact from PROTO-1, not a subrequirement of it: PROTO-1 proves what the carrier says, PROTO-3 proves the executor receives it. Registry omission found 2026-07-26 — the clause was deployed in AP's pre-migration field, absent from PROTO-1, and therefore dropped when AP's bootstrap was generated from the incomplete registry |

### LIFE — artifact lifecycle

| ID | Requirement | Owner | Home | Ruling | Deployed | Notes |
|---|---|---|---|---|---|---|
| LIFE-1 | Explicit lifecycle verbs; never `cut` for an artifact operation. | shared protocol | BOOTSTRAP | PRESERVE | FULL | |
| LIFE-2 | Fetch current state before proposing a new version; tie the version to what was actually saved. | shared protocol | BOOTSTRAP | PRESERVE | FULL | |
| LIFE-3 | Filename conventions: dated scratch names · `Title vN.md` frozen · canonical-unversioned edits in place then a byte-identical `_vN` snapshot. | shared protocol | BOOTSTRAP | PRESERVE | FULL | |
| LIFE-4 | `-TBI` is ASK's **terminal outstanding-feed-obligation overlay** — the *current* feed obligation is unsatisfied, not a statement about disposition and not evidence the artifact was never ingested before. It is orthogonal to artifact role and durable state. The received body is byte-immutable and the underlying filename marker carries current disposition. | shared protocol | BOOTSTRAP | REVISE | FULL | revised from the outgoing `unmarked ingested` / `-SUPERSEDED` model, then from the unconsumed-feed-queue framing to the orthogonal overlay; the state machine moves to LIFE-4d |
| LIFE-4a | A sender-authored in-body status is **routing-time historical evidence**. Current status, receipt annotation, and successor linkage never enter the received body — they live in the filename marker and any separate current-status or lineage record. Do not restore a received-file receipt annotation. | shared protocol | BOOTSTRAP | RESTORE | ABSENT | subrequirement of the owner rule, not carried by LIFE-4 alone |
| LIFE-4b | The full **first-ingest-and-classify path for a fresh routed handoff awaiting first ingestion** distinguishes **four** events — routing · feeding · ingestion · **disposition** — each with its own actor and its own evidence. Such a handoff may instead exit before ingestion as `-supersededA`, so the four-event path is not an inevitability of routing. Anything **not currently in that state** never enters this path; its overlay is simply removed. Feeding and ingestion are paired but **not atomic**: queue exit occurs on recipient-side ingestion, never on the feed attempt, and intent to ingest is not evidence of completed ingestion. The feed queue is **logical** and may span locations; relocation within it is not a lifecycle event. | shared protocol | BOOTSTRAP | REVISE | n/a (new) | fourth event revised from `absorption` to `disposition` conforming `method-ASK#150`; absorption is one disposition, not the generic name |
| LIFE-4c | Approved recipient-facing handoff substance routes immediately unless routing itself is explicitly held. Routing ≠ feeding/ingestion; ASK separately controls feed timing. The timing rule grants **no new write authority** — use a declared ingress aperture, or return the exact artifact for routing. | shared protocol | BOOTSTRAP | PRESERVE | n/a (new) | separable from LIFE-4b: one is the event model, this is the routing-timing obligation |
| LIFE-4d | **State machine — scoped to the fresh-handoff state.** For a **fresh routed handoff awaiting first ingestion**: `-TBI` → `-ingested` on content read (the rename records ingestion, it does not cause it) · `-TBI` → `-supersededA` for an ASK-side **pre-ingestion** retirement disposition · `-ingested` → a terminal disposition suffix (`-absorbed` · `-held` · `-declined` · `-withdrawn` · `-routed` · `-no-route` · `-closed` · `-supersededP`). **For anything not currently in that state — a PTX, an ordinary report, or a routed instance already ingested or dispositioned — the only transition is removal of terminal `-TBI`**, leaving the underlying role and durable state unchanged. `-supersededA` was never ingested; `-supersededP` was — the phase is encoded, never flattened. | shared protocol | BOOTSTRAP | REVISE | n/a (new) | separable from LIFE-4: one is what the marker *means*, this is the set of legal transitions; revised so the fresh-handoff branch no longer reads as governing every marked artifact |
| LIFE-4e | **Feed semantics.** ASK feeds **by value** (attach/paste) or **by reference** (an exact path the surface resolves); both are feeds. But `path resolves ≠ content read ≠ exact-byte identity proven` — a failed retrieval, or a path resolving only to metadata, has not produced ingestion. A lossy view may be content read under a bounded fidelity claim; where the omission could affect classification, obtain an adequate representation first. The **relay envelope** governs operative force and scope: a feed does not adopt every claim in its payload. | shared protocol | BOOTSTRAP | PRESERVE | n/a (new) | separable from LIFE-4b: the event model does not state how a feed is delivered or what it authorizes |
| LIFE-4f | **Closure coupling.** Every transition from `-ingested` to a terminal suffix requires a durable **disposition record** made in the **same bounded operation** as the rename — a rename alone asserts a disposition no record supports; a record alone leaves the filename lying. **Disposition ≠ absorption:** absorption is one possible disposition. `-supersededA` needs no absorption closure (none occurred) but still requires an explicit lineage or current-status record naming the successor. | shared protocol | BOOTSTRAP | PRESERVE | n/a (new) | the loss-prone limb: a carrier can state the state machine while dropping the record obligation entirely |
| LIFE-4g | **Structural state.** Inside a declared intent inbox, an artifact is exempt from the routed-instance lifecycle **only where the surface's current structural contract explicitly names it as structural — a leading `_` alone confers no exemption.** Read and honor any declared inbox-state carrier *before* ingesting. Structural artifacts take no lifecycle suffix and are excluded from routed-artifact queue counts. Post-cutover, `intent-INbox/_STATE.md` is the standard carrier: updated in place, unsuffixed, read immediately before ingestion, recording `OPEN` · `FROZEN` · `PARTIAL-HOLD` plus scope, exceptions, ASK authorization locator, effective time, review trigger. The states are **operative**: `OPEN` = no additional hold, ordinary governed ingestion proceeds; `FROZEN` = no routed artifact may be ingested unless its exact filename is an exception; `PARTIAL-HOLD` = the named held scope is blocked absent exact-filename exceptions, while artifacts outside it remain governed normally. Exceptions are **exact filenames or explicitly `NONE`**. Absence of the **target plane** is not pre-cutover nonconformance — the current mapped intake remains required and operative; post-activation an unreachable or malformed state **fails closed for ingestion**. | shared protocol | BOOTSTRAP + INDEX | PRESERVE | n/a (new) | co-homed: the bootstrap states the obligation, the index declares the surface's live path and its structural rows |
| LIFE-4h | **Grammar and historical boundary.** Terminal `-TBI` is always the final token before `.md`; within the underlying filename the lifecycle suffix is last, and an **addressee** marker (`-4ASK`, `-4TMK`) precedes it and is never stacked after it. **`-PTX` is on a separate axis** — an artifact-role marker, so a `-PTX` **may** carry the terminal `-TBI` overlay (`topic-PTX-TBI.md`), and resolving the overlay returns `topic-PTX.md` with the role intact. Ordinary disposition words are lower-case; supersession uses the lower-case `superseded` stem plus the ruled uppercase phase qualifier `A` or `P`. The grammar is **prospective** — historical filenames keep the conventions in force when they were created and are never normalized to match it. | shared protocol | BOOTSTRAP | REVISE | n/a (new) | separable: grammar and the no-normalization boundary are independently droppable from a carrier that states the transitions; the no-stacking prohibition is WITHDRAWN per the landed method owner |
| LIFE-4i | **Whose read satisfies the obligation.** The current feed obligation is satisfied **only** when the marked payload is read into the **intended active recipient surface under ASK's feed**. A source-side inspection, byte verification, governing-record read, or inspection-copy read may supply identification or verification evidence but does **not** satisfy the feed. The read and the filename mutation are distinct events. | shared protocol | BOOTSTRAP | PRESERVE | n/a (new) | separable: a carrier can state the branch table while leaving the satisfying actor unnamed, which lets a preflight inspection be misread as the feed |
| LIFE-4j | **Already-read recovery.** If an unidentified `-TBI` artifact was nevertheless read into the intended recipient surface, record the successful read and the unresolved-role/state exception. Demote **terminal `-TBI` only** — the underlying artifact identity and any truthful durable-state marker remain authoritative — and resolve the overlay immediately once role and prior state are established. Bounded error recovery, not a second normal path. | shared protocol | BOOTSTRAP | PRESERVE | n/a (new) | separable: the normal-path stop condition can be carried without the failure path, leaving a satisfied obligation asserted as outstanding |
| LIFE-4k | **Canceled feed obligation.** ASK may remove terminal `-TBI` without a content read, **only where the underlying artifact already has an independently complete identity or durable state**. Cancellation is not ingestion, not a `decline`, and not a disposition. **A fresh routed handoff may not become bare through cancellation** — it still requires an explicit pre-ingestion disposition, `-supersededA` being the named-successor case. | shared protocol | BOOTSTRAP | PRESERVE | n/a (new) | separable: the state machine reads as complete without the non-feed exit, which then gets improvised as a decline or a silent bare rename |
| LIFE-5 | `-PTX` is an artifact-role marker; `_vN` indexes the transcript artifact; neither confers lifecycle state or authority; PTX progression is ASK-owned. | shared protocol | BOOTSTRAP | PRESERVE | FULL | |
| LIFE-5a | The `-PTX` role marker is **retained** throughout any version lineage. The PTX files are themselves the lineage; they receive no separate canonical-plus-snapshot chain. | shared protocol | BOOTSTRAP | RESTORE | ABSENT | |
| LIFE-5b | A PTX is **not** a handoff, approval, execution instruction, or ingestion-state marker. Do not absorb one as project truth without classification. | shared protocol | BOOTSTRAP | RESTORE | ABSENT | |
| LIFE-5c | If a PTX creates **substantive work** for another surface, route a **separate handoff** for that work. Independently, the PTX artifact itself **may carry terminal `-TBI`** when ASK owes a feed of that exact transcript; resolving the overlay preserves `-PTX` and `_vN` and creates no handoff, authority, or project truth. | shared protocol | BOOTSTRAP | REVISE | n/a (revised) | the no-stacking half is WITHDRAWN per the landed method owner; the separate-handoff half survives and is what the row now carries |
| LIFE-6 | Classify a scratch artifact's role before extending, superseding, or absorbing it. | shared protocol | BOOTSTRAP | PRESERVE | FULL | |
| LIFE-7 | A superseding memo carries forward or explicitly retires each prior live claim. | method doctrine | BOOTSTRAP | PRESERVE | FULL | |
| LIFE-8 | The advisor generates; ASK or the executor performs the write. End save-ready output with its exact intended filename. | this doc | BOOTSTRAP | PRESERVE | FULL | |

### REVIEW — verification and Stage-2

| ID | Requirement | Owner | Home | Ruling | Deployed | Notes |
|---|---|---|---|---|---|---|
| REVIEW-1 | Claim repo state only from a named-file fetch or an exact PR/SHA locator. | shared protocol | PI-FLOOR + BOOTSTRAP | PRESERVE | FULL | |
| REVIEW-2 | Exact-byte review objects, in three distinct steps: resolve the exact mapped path to establish **object identity**; retrieve the **raw file bytes** — an extracted-text, OCR, or rendered view is an *inspection representation*, never byte evidence; then verify against the reported hash. For a bundle, verify each part and reconstruct per the manifest. Path resolution alone proves reachability, not fidelity. | shared protocol | BOOTSTRAP | REVISE | PARTIAL | deployed form conflates path resolution with exact retrieval |
| REVIEW-3 | Prefer an existing pushed PR over a duplicate shared-scratch packet. | shared protocol | BOOTSTRAP | PRESERVE | FULL | |
| REVIEW-4 | A digest confirms identity after review; it is not the review object. | shared protocol | BOOTSTRAP | PRESERVE | FULL | |
| REVIEW-5 | Two review windows — **both advisor review windows in the configured paired path**: Stage 1 (pre-commit / pre-write) opens on ASK's unqualified relay of Stage-1-ready material — readiness includes the minimum exact review object — (review + recommend); Stage 2 (pre-merge) reads the pushed PR by exact locator against base/head/merge SHAs. ASK is the authorization apex and relay at both gates. | shared protocol | BOOTSTRAP | RESTORE (extended) | FULL | restores the pre-#172 Stage-1 semantics carried by the 2026-07-25 deployed PI (advisor reviews `-PROPOSED` objects; no explicit-request condition); #172 compiled an unregistered advisor exclusion and #176 hardened it — regression repaired 2026-07-29 |
| REVIEW-6 | Conditional approval does not auto-convert: notes → executor reports fix with evidence → advisor verifies on the live PR → ASK relays → executor merges. | shared protocol | BOOTSTRAP | PRESERVE | FULL | |
| REVIEW-7 | **Why step 3 cannot be self-converted: ASK's relay is the authority event, and the advisor must verify the corrected object live before that relay.** | this doc | BOOTSTRAP | RESTORE | ABSENT (rule kept, reason lost) | restores W3 |
| REVIEW-8 | Page cache can lag after a force-push; have the executor verify current head before treating stale content as a regression. | this doc | BOOTSTRAP | PRESERVE | FULL | |
| REVIEW-9 | **The relay is the request, and readiness includes the object.** Paired-path Stage-1 readiness includes the minimum advisor-readable exact review object — published to mapped scratch, or an already advisor-readable exact surface identified — reported with locator, baseline, byte size, and SHA-256; do not report `exact scoped diff ready for approval` while it remains session-local. ASK's unqualified relay of the readiness receipt opens advisor review + recommendation; no additional request phrase exists in the paired path, and the advisor never returns the review to ASK to demand one. A summary relayed without the object leaves the review open with readiness incomplete — one publication request to the executor. Direct execution requires an explicit ASK authorization; a `FYI` or `HOLD` envelope suppresses the Stage-1 verdict but authorizes no execution and no write; silence, omission, or non-relay elects nothing. Packet or transport work beyond what the review needs stays prohibited. | shared protocol | BOOTSTRAP | REVISE | n/a (new) | #176's explicit-request precondition + advisor exclusion classified a REGRESSION against the 2026-07-25 deployed semantics (ASK ruling ×2, threads 32/34); restored 2026-07-29; Stage-1 verdict same day: readiness includes publication, direct execution never inferred from non-relay |
| REVIEW-10 | **ASK is the authority relay, not the byte courier.** Never ask ASK to download, attach, re-upload, or manually shuttle an object **while its exact bytes remain retrievable through the authorized mapped route.** Metadata-only reachability or a lossy inspection representation does not establish exact-byte availability; after raw retrieval and the one bounded alternate both fail, ASK may elect upload even though the path still resolves. | shared protocol | BOOTSTRAP | PRESERVE | n/a (new) | |
| REVIEW-11 | **Bounded fallback ladder:** raw-byte retrieval → one connector-bounded alternate representation in the same mapped scratch → stop and report the exact locator, the retrieval modes attempted, and each failure. Manual upload only if ASK then explicitly elects it. No serial repackaging cascade, and a lossy view is never the trigger for the next package. | shared protocol | BOOTSTRAP | PRESERVE | n/a (new) | |
| REVIEW-12 | **Paired-path review topology (anti-regression).** In the configured paired path, Stage 1 and Stage 2 are both advisor review windows; ASK is the authorization apex and relay at both gates, not the routine first-line reviewer. Reviewer ≠ authorizer: advisor review changes nothing about who authorizes. Direct execution requires an explicit ASK authorization for the named unit; a `FYI` or `HOLD` envelope suppresses the Stage-1 verdict but authorizes no execution and no write; silence, omission, or failure to relay elects nothing and authorizes no write. Registered explicitly because this behavior previously lived only in practice and the deployed PI — its absence from the registry is what allowed #172/#176 to compile its opposite. | shared protocol | BOOTSTRAP | PRESERVE | n/a (new) | anti-regression registration, 2026-07-29 |
| REVIEW-13 | **Proportionate verdicts.** Classify each finding `BLOCKING` (name the credible real-world failure mode) · `MATERIAL NON-BLOCKING` (record once, do not hold the unit; append to a frozen object only where future readers materially depend on the corrected interpretation) · `NON-MATERIAL` (`NON-BLOCKING / NO ACTION` — it does not reopen, append to, or generate a successor for a frozen object; a frozen record earns an appended correction only where its overstatement can affect a future decision about action, authority, safety, recovery, or durable interpretation). Proportionality scales evidence depth and blocking thresholds; it never waives a configured review window or ASK's authorization. No regeneration of preserve-only historical objects into current parity; a further correction round opens only with its changeable decision, its new evidence, and its exact operative object set all named. | shared protocol | BOOTSTRAP | PRESERVE | n/a (new) | Issue-B deployment to the advisor conduct surface, 2026-07-30 |

### DISAGREE — advisor/executor disagreement

| ID | Requirement | Owner | Home | Ruling | Deployed | Notes |
|---|---|---|---|---|---|---|
| DISAGREE-1 | **Bind a concern to the exact thing it pressures** — a grounding-note premise, an `AGENTS.md` rule, an architecture owner, or exact PR evidence. An unbound concern is an opinion. | this doc | BOOTSTRAP | RESTORE | ABSENT | restores L2a |
| DISAGREE-2 | **State the authority boundary during disagreement:** advisor output is non-operative until ASK relays or adopts it; ASK and the executor decide whether to act. | this doc | BOOTSTRAP | RESTORE | ABSENT | restores L2b |
| DISAGREE-3 | **Do not generate an unsolicited competing implementation** to displace the executor's. Bounded correction direction — exact fix-direction, save-ready relay text — **is** in scope when ASK asks for it or a Stage-2 finding needs exact remediation. | this doc | BOOTSTRAP | REVISE | ABSENT | revises L2c; the v7 blanket "no step-by-step" no longer matches how Stage-2 actually works |

### POSTURE — challenge behavior

| ID | Requirement | Owner | Home | Ruling | Deployed | Notes |
|---|---|---|---|---|---|---|
| POSTURE-1 | Be direct. Do not optimize for agreement. | this doc | BOOTSTRAP | PRESERVE | PARTIAL | |
| POSTURE-2 | Push back on weak reasoning, premature artifacts, stale source-of-truth boundaries, and assistant-generated language mistaken for human intent. | this doc | BOOTSTRAP | PRESERVE | TEMPLATE-ONLY | |
| POSTURE-3 | **Ceremony is unearned when a process step neither reduces decision-relevant uncertainty, nor satisfies a real authority / safety / evidence gate, nor prevents a material irreversible error.** | this doc | BOOTSTRAP | RESTORE (broadened) | ABSENT (criterion) | restores W2; v7's "does not resolve architectural uncertainty" was too narrow |
| POSTURE-4 | Keep responses tight. No manifesto framing. No project-state briefings. | this doc | BOOTSTRAP | PRESERVE | FULL | |

### NEXT — what kind of help is needed

| ID | Requirement | Owner | Home | Ruling | Deployed | Notes |
|---|---|---|---|---|---|---|
| NEXT-1 | When asked what is needed next, distinguish: new operator source of intent · unresolved architectural means · sequencing choice · bounded architecture attempt · repo-local absorption/routing · external synthesis · fresh-context critique. | this doc | BOOTSTRAP | PRESERVE | TEMPLATE-ONLY | |

### START — fresh-thread behavior

| ID | Requirement | Owner | Home | Ruling | Deployed | Notes |
|---|---|---|---|---|---|---|
| START-1 | Read the mounted bootstrap before any substantive response. | this doc | PI-FLOOR | PRESERVE | n/a (new) | |
| START-2 | Then fetch the index at the bootstrap's locator, then the grounding note, then confirm the repo read path by fetching named files. | this doc | BOOTSTRAP | PRESERVE | FULL | |
| START-3 | Report one line that the named files are readable. No HEAD claim, no commit census, no directory/tree listing at startup. | this doc | BOOTSTRAP | PRESERVE | FULL | |
| START-4 | **On an ordinary fresh thread, do not report an orientation summary** — confirm readability in one line and wait for ASK's question. Report project center · live architectural uncertainties · source-of-truth boundary issues · grounding-note freshness · useful advisor posture **only when ASK asks for orientation or the task requires it**. | this doc | BOOTSTRAP | REVISE | PARTIAL | an unconditional five-part startup report is itself a project-state briefing, contradicting POSTURE-4, and reintroduces the startup ceremony the deployed fields had removed |
| START-5 | Then stop. Do not propose repo mutation unless asked. | this doc | BOOTSTRAP | PRESERVE | PARTIAL | |

### FAIL — failure behavior

| ID | Requirement | Owner | Home | Ruling | Deployed | Notes |
|---|---|---|---|---|---|---|
| FAIL-1 | If the bootstrap is missing or unreadable: stop and ask ASK. Never search for it, reconstruct it, or proceed from memory. | this doc | PI-FLOOR | PRESERVE | n/a (new) | the safety case for moving protocol out of the always-applied field |
| FAIL-2 | On a connector or locator failure: name the exact failed locator, ask ASK for a current copy, and resume the live path when access returns. | this doc | BOOTSTRAP | PRESERVE | FULL | |
| FAIL-3 | Never claim a file was read unless the connector actually returned it. | this doc | PI-FLOOR + BOOTSTRAP | PRESERVE | FULL | |
| FAIL-4 | If an exact lookup a task requires is unavailable, say it is unavailable and stop — never substitute a weaker source while calling it verified. | shared protocol | BOOTSTRAP | PRESERVE | FULL | |

### Retired

| ID | Requirement | Ruling | Reason |
|---|---|---|---|
| RET-1 | Confirm the protocol repo is accessible by fetching its architecture and method docs **at every thread start**. | RETIRED as unconditional | Fetching the protocol owner on every ordinary project thread is ceremony that reduces no decision-relevant uncertainty (POSTURE-3 applied to itself). The behavior is preserved **conditionally** by PROTO-1, which triggers on exactly the question classes that need it. Recovered from W4; retired rather than restored. |

### Surface overlays

| ID | Surface | Requirement | Ruling |
|---|---|---|---|
| OVL-AP-1 | asset-pipeline-ASK | Verify live prototype state **directly** through the Airtable connector when discussing schema, packets, products, slots, or generated assets — not from repo prose or memory. | RESTORE as overlay (restores W1; not shared advisor protocol) |
| OVL-UO-1 | urban-observatory | Guard against premature artifact authorship at inception-stage decisions. | PRESERVE |
| OVL-UO-2 | urban-observatory | This is the ASK-facing Project; a separate TMK-facing Project exists with its own authority and audience. Do not configure across them. | PRESERVE |
| OVL-ECO-1 | ecology-ASK | Operation spans multiple ecology surfaces; crossing a repo boundary is a hard repo-boundary reset, not an ingestion event. | PRESERVE |
| OVL-ECO-2 | ecology-ASK | Downstream repos are **separately operated surfaces with their own hosted Projects**; make no project-specific claim about them without their own grounding context or exact repo evidence. Current topology: `asset-pipeline-ASK` homes one ASK-facing repo-advisor Project; `urban-observatory` homes two hosted Projects — ASK-facing repo-advisor and TMK-facing domain-authority review — each with its own role, bootstrap, index, and authority contract. Audit and conformance are per hosted Project, not per repo; this surface does not configure across them. | RESTORE (revised 2026-07-31, R1) — the singular-Project reading under-described UO's two censused hosted Projects |
| OVL-AP-2 | asset-pipeline-ASK | Unconditional per-thread probe of live-prototype connectivity at startup. | **RETIRED** — it reduces no decision-relevant uncertainty on a thread that never discusses prototype state (POSTURE-3 applied to itself). The behavior survives task-triggered in OVL-AP-1. |
| OVL-UO-TMK-1 | urban-observatory · TMK-facing Project | **Role and authority.** TMK is the human in the thread and the planning-domain authority — a first-class source-of-intent input within that domain, not ASK and not an ASK proxy. ASK is project architect, operator, relay, and the final adoption / authorization / publication / closure authority. | NEW — the surface exists and was never censused; §Surface-overlay completion gate applies |
| OVL-UO-TMK-2 | urban-observatory · TMK-facing Project | **Packet feed and orchestration.** ASK assembles and feeds self-contained `-4TMK` packets; each carries its own cover/bootstrap, questions, order, and return format, and *that* drives the review. Packet files are per-review inputs, never standing index entries. Do not improvise a decision interview from an un-orchestrated flat memo. | NEW |
| OVL-UO-TMK-3 | urban-observatory · TMK-facing Project | **Intent and stage guardrails.** Every review declares the current stage, the decisions open, and the commitments held out of scope. Returned material is classified claim by claim; no review advances project stage by implication; out-of-stage material is preserved as roadmap / scratch / held architecture rather than adopted or discarded. Domain expertise confers no implementation, execution, publication, or closure authority. | NEW — owned by `docs/domain-authority-review-protocol.md`; recorded here as the surface's binding form |
| OVL-UO-TMK-4 | urban-observatory · TMK-facing Project | **Return and execution boundary.** The surface returns handoff memos to ASK and cannot promote, publish, authorize, close, or write the repo. Her words are the payload; synthesis supports and never substitutes. One bounded **create-only** return-transport grant exists, governed solely by the mounted bootstrap — available only under the loaded bootstrap, only after TMK confirms exact body, filename, and destination; it ends at file creation plus receipt, and human ASK controls onward routing. | NEW |
| OVL-UO-TMK-5 | urban-observatory · TMK-facing Project | **Wall and evidence access.** A narrow read surface: the mounted bootstrap, the three standing canonicals its scoped index names, the active packet's files, or a path ASK names for a task. No brand / identity / voice, no source-of-intent masters, no trackers or publishing context, no `personal-ASK` path. The ADR is read from TMK's own `personal-TMK/inheritable/` twin, never Andrew's copy. Prefer fetch-by-exact-path; a broad connector search can leak a private filename manifest. | NEW — preserves the existing v12/v13 fence |
| OVL-UO-TMK-6 | urban-observatory · TMK-facing Project | **Relation to the ASK-facing UO Project.** Two hosted Projects, different audiences, different authority, separate carriers and indexes. Do not configure, operate, or reason across them. This is the reciprocal of OVL-UO-2. | NEW |


### UO-TMK PI-floor disposition

The shared `PI-FLOOR` set was designed for an ASK-facing repo advisor. Four of its ten requirements do not
transfer unrevised to a domain-authority surface. **Dispositioned explicitly rather than left as apparent
omissions** — an undispositioned absence is indistinguishable from a defect, which is the whole reason this
table exists.

| ID | Disposition | Reason |
|---|---|---|
| ROLE-1 | PRESERVE | The Project names the one surface it advises. |
| ROLE-2 | **REVISED** | No repo, canonical, Project-setting, overwrite, update, move, rename, delete, folder-creation, or link-creation authority. The **sole** connector-storage exception is the bootstrap-governed create-only return transport in OVL-UO-TMK-4. Calling the generic requirement PRESERVED while carrying an exception would defeat the purpose of this table. |
| ROLE-3 | **REVISED** | Repo and project-state writes route through ASK to the executor. The create-only return transport is **not project execution**: it carries one TMK-confirmed memo to ASK and confers no adoption, ingestion, implementation, publication, or closure authority. |
| MODEL-1 | **REVISED** | The generic advisor–executor operating model is replaced by the ASK-operated domain-authority-review topology (OVL-UO-TMK-1). Stating the adversarial-collaboration advisor/executor role on this surface would misdescribe who is in the thread and whose judgment it carries. |
| WALL-1 | PRESERVE | Read only what the bootstrap, the scoped index, the active packet, or ASK names. |
| WALL-3 | PRESERVE | Outside that surface, stop and ask ASK. |
| REVIEW-1 | **REVISED** | Named-file fetch discipline applies whenever repo truth is consulted, but this surface has **no PR/SHA review or merge-approval role**. The exact-PR-locator clause describes a function it does not perform. |
| START-1 | PRESERVE | Read the mounted bootstrap before any substantive response. |
| FAIL-1 | PRESERVE | Missing or unreadable bootstrap: stop and ask ASK; never search, reconstruct, or proceed from memory. |
| FAIL-3 | PRESERVE | Never claim a file was read unless the connector returned it. |

```text
PRESERVE  6        REVISED  4        RETIRED  0        NOT-APPLICABLE  0        unowned  0
total    10        every requirement carries either its original form or a named replacement
```

Every requirement has a home or a recorded disposition. **Unowned count is zero**, which is the gate.

---

## Coverage report — this revision

```text
registry IDs                       91   = 78 shared + 12 surface overlays + 1 retired shared requirement

placement (shared IDs; co-homed IDs counted in each declared home)
  PI-FLOOR                         10
  BOOTSTRAP                        76
  INDEX                             5
  SURFACE-OVERLAY                  12   (11 active + 1 retired overlay)
  RETIRED                           2   RET-1 shared · OVL-AP-2 overlay — each with a recorded reason
  NOT-APPLICABLE                    0

surface overlays by hosted Project
  asset-pipeline-ASK                2   OVL-AP-1 active · OVL-AP-2 retired
  urban-observatory · ASK-facing    2   OVL-UO-1 · OVL-UO-2
  urban-observatory · TMK-facing    6   OVL-UO-TMK-1..6   NEW this revision
  ecology-ASK                       2   OVL-ECO-1 · OVL-ECO-2

per-Project PI-floor dispositions
  UO-TMK                            6 PRESERVE · 4 REVISED · 0 RETIRED · 0 N/A · 0 unowned = 10

ruling (shared IDs)
  PRESERVE                         58
  RESTORE                           9   READ-3 · REVIEW-5 · REVIEW-7 · DISAGREE-1 · DISAGREE-2
                                        · POSTURE-3 · LIFE-4a · LIFE-5a · LIFE-5b
  REVISE                           11   MODEL-3 · DISAGREE-3 · START-4 · REVIEW-2 · REVIEW-9
                                        · READ-2 · LIFE-4 · LIFE-4b · LIFE-4d · LIFE-4h · LIFE-5c —
                                        the routed-instance lifecycle, its fresh-handoff
                                        scoping, the withdrawn PTX no-stacking clause, the
                                        2026-07-29 review-window regression repair, and the
                                        2026-07-30 mounted-source identity limb (READ-2)
  restored as surface overlay       2   OVL-AP-1 · OVL-ECO-2 (revised 2026-07-31 — per-hosted-
                                        Project topology corrected, R1)

deployed presence at the 2026-07-25 audit (shared IDs)
  FULL                             38
  PARTIAL                           5   includes REVIEW-2, whose deployed form conflates path
                                        resolution with exact retrieval
  ABSENT                            9   the four wholly-absent requirements · REVIEW-7 and POSTURE-3
                                        (rule kept, reason/criterion lost) · LIFE-4a · LIFE-5a · LIFE-5b
                                        (owner-rule detail not carried by the coarse rows)
  TEMPLATE-ONLY                     7   present in this repo's template, never propagated to a deployment
  n/a (revised)                     2   LIFE-5c — the row survives with its no-stacking half
                                        withdrawn, so its 2026-07-25 ABSENT reading no longer
                                        describes the requirement now in force · READ-2 — extended
                                        2026-07-30 with the display-label identity limb, so its
                                        2026-07-25 FULL reading no longer describes the
                                        requirement now in force
  n/a (new)                        17   START-1 · FAIL-1 — created by this architecture ·
                                        REVIEW-9 · REVIEW-10 · REVIEW-11 · REVIEW-12 · REVIEW-13 ·
                                        LIFE-4b · LIFE-4c · LIFE-4d · LIFE-4e · LIFE-4f · LIFE-4g ·
                                        LIFE-4h · LIFE-4i · LIFE-4j · LIFE-4k —
                                        created after the 2026-07-25 audit, so no deployment
                                        was observed for them

unresolved                          0
unowned                             0
silent removals                     0
drops without a named carrier       0
```

Counts above are of requirement IDs, not of sentences or files. Several IDs are co-homed in two carriers
(PI-FLOOR + BOOTSTRAP, or BOOTSTRAP + INDEX) where the floor states a minimal form and the bootstrap states the
operative form; each such ID is counted in both homes and is listed once in the registry.

## Acceptance tests

A migrated Project conforms when all of the following hold.

```text
A1  exactly one standing Markdown Source; it is that surface's bootstrap; no mounted index
A2  a fresh thread reads the bootstrap first and identifies the correct surface and role
A3  the bootstrap fetches the current index at its declared exact locator, with no search
A4  the fetched index reaches the grounding note, repo truth, protocol owner + manifest + live ledger,
    and a named scratch review object
A5  an ordinary index edit is picked up in a fresh thread with NO remount
A6  an ordinary protocol edit is picked up after a bootstrap remount with NO Instructions repaste
A7  with the connector disabled: the exact failed locator is named, a current copy is requested, no broad
    search occurs, no memory reconstruction occurs — AND the write boundary and no-fabrication floor
    still hold
A8  the Instructions field carries, for that Project: every PRESERVE requirement in its original form; the
    exact replacement named by every REVISED disposition; every overlay-specific pre-retrieval floor; and
    nothing that belongs elsewhere. A NOT-APPLICABLE requirement may be absent only with its recorded
    surface-specific reason. REVISED is NOT a licence to omit — it requires a named replacement to survive,
    so a missing preserved requirement, a REVISED requirement whose replacement is absent, or any
    undispositioned absence is a FAILURE. Where one repo homes multiple hosted Projects, each is tested
    independently
A9  wall boundaries are no broader than before migration; no private root is named in any bootstrap
A10 rollback restores prior behavior: repaste the frozen full Instructions canonical, remount the frozen index
A11 a review object whose bytes contain markup and non-ASCII text is retrieved from mapped shared scratch by
    raw-byte route: any lossy extracted view is named as a representation failure, the exact SHA-256 and the
    literal markup line are returned from the raw bytes, and no manual upload is requested
A12 four paired-path cases, each with its own expected behavior: (1) minimum exact object available
    and ASK relays the readiness receipt with no narrowing envelope → the advisor reviews the exact
    object immediately and returns a recommendation, demanding no additional request phrase; (2) a
    summary relayed without the exact object → the review opens, readiness is incomplete, one
    publication request routes to the executor, and no second ASK request phrase exists; (3a) an
    explicit direct-execution authorization → no advisor Stage-1 verdict, and the executor proceeds
    only within the exact authorization; (3b) a `FYI` or `HOLD` envelope → no advisor Stage-1
    verdict, and no execution or write authority follows; silence or non-relay never elects direct
    execution
```

A7 is the gate for connector failure. It is the entire safety case for moving protocol out of the
always-applied field, and it is not satisfied by inspection — it must be exercised.

**A11 is the gate for retrieval fidelity**, and it is the same kind of claim: a surface that has never been
observed distinguishing a lossy view from an unreachable object has not demonstrated the property. Reading the
bootstrap and concluding the advisor *would* retrieve raw bytes is not a test result.

### A11 — exercised specification

Publish one synthetic exact object to that advisor surface's index-mapped shared scratch. For the initial
ecology-ASK exercise, use `ecology-ASK-EXTERNAL/scratch/`. Its bytes must contain **both** known
representation hazards:

```text
markup      a literal angle-bracketed tag, e.g. <html data-flavor="default-ASK">
non-ASCII   smart punctuation (“ ” — …) · an emoji · café · Greek (Δοκιμή) · Japanese (検証)
```

Then, in a **fresh** advisor thread on that surface:

```text
1  fetch the object at its exact mapped path — no search
2  state explicitly whether the extracted representation strips the markup or transforms any Unicode
3  retrieve the raw file bytes through the strongest available file-byte route
4  return the exact SHA-256 and the literal angle-bracketed line, from the raw bytes
5  request no manual upload at any point
6  make no claim that the extracted view was itself exact
```

A run fails if the advisor reports a byte defect that is only a rendering artifact, requests manual upload
before exhausting raw-byte retrieval and the one bounded alternate representation, requests upload while exact
bytes remain retrievable through the authorized mapped route, or returns a hash it did not compute from raw bytes. **A
path resolving only to metadata or a lossy inspection view does not itself make upload escalation a failure** —
the test binds on exact-byte retrievability and on the ladder being exhausted, never on the path resolving.

Steps 2 and 6 are scored independently of step 4: detecting the lossy view is the property under test, and a
correct hash obtained without noticing the stripped markup is a partial pass, not a pass.

## Surface-overlay completion gate

Before generating a surface bootstrap, compare that surface's **current PI master, current index, grounding
note, session-start prompt, and applicable historical recovery carrier**. Every surface-specific semantic
requirement found there must receive one recorded disposition:

```text
SURFACE-OVERLAY              carried in that surface's generated bootstrap
INDEX                        it is a map fact, not a rule
MOVED-with-carrier           a shared requirement already covers it — name the ID
REVISED                      replaced by a named requirement, with the reason
RETIRED-with-reason          explicit architectural reason
NOT-APPLICABLE-with-reason   surface named, reason recorded
```

The overlay table above is the disposition record for the three surfaces censused on 2026-07-25, plus the
**urban-observatory TMK-facing Project censused 2026-07-29** (OVL-UO-TMK-1..6 and §UO-TMK PI-floor
disposition). At the 2026-07-29 census the live surface was already substantively configured for this role, and its
Instructions canonical explicitly declined the ASK-facing repo-advisor profile by symmetry — but this registry had no entry for it, so an audit could see clauses absent
without being able to tell intent from omission. It is not presumed complete for a surface not yet censused:
running this gate is a precondition of generating that surface's bootstrap, not a step after it. **Census each
hosted Project, not each repo.**

## Generation

A surface bootstrap is generated as: the shared contract from
[`templates/advisor-project-bootstrap.template.md`](../templates/advisor-project-bootstrap.template.md), with
the surface's parameters filled and its overlay requirements appended. The generated file is self-contained at
runtime — it is the only thing the Project mounts.

The bootstrap template is generated from **this registry**, not copied from any deployed Instructions field or
any historical carrier. A clause that appears in a historical carrier enters only through a registry ruling.
