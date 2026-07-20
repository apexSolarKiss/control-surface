# Cross-repo-propagation-wave runbook

Reusable execution instrument for propagating a merged upstream owner change across multiple consumers. Referenced by `AGENTS.md` §Cross-Repo Propagation Waves. This is **execution protocol**, not design-system visual doctrine.

**Principle:** parallelize measurement and consumer staging; serialize authority, visual judgment, canonical writes, and closure. The parent coordinator is the single writer of every shared surface.

The generic contract (§0–§5) governs every wave. Two **typed profiles** supply the domain-specific manifest, census, and evidence fields: **Profile A — diagram / design-system vendor propagation** and **Profile B — execution-protocol carrier propagation**. Pick the profile that matches the owner change.

---

## 0. Owner lane (serial)

Nothing propagates from an unmerged owner branch. Once the owner change is reviewed and merged at an exact head, the coordinator records an **owner-delta manifest**. Generic fields (both profiles):

```text
owner canonical path + landed SHA
clauses / files explicitly marked for propagation
declared downstream carrier / consumer classes
expected impact + known neutral classes
```

The profile adds its domain-specific fields (below). The manifest is the reference every downstream subagent is pinned to.

---

## 1. Census wave (parallel, read-only)

One subagent per consumer/package/carrier. Strict read-only contract — **fetch and read only; write nothing, create no worktree.** Each is pinned to the owner-delta manifest and returns the profile's census fields plus the generic:

```text
authoritative base:   origin/main SHA (repo) or Dropbox content-hash (package); ALWAYS fetch first —
                      a local checkout may lag origin/main
local exceptions / deltas that must be preserved and NOT overwritten
direct-operation / handoff / frozen classification
proposed scope · unresolved ambiguity
GREEN / AMBER / RED / HANDOFF recommendation
```

The census is **measurement, not authority.** A finding that conflicts with `origin/main`, a live `VERSION.md`, the owner bytes, or the consumer ledger is a prompt to re-check. A failed lookup is `LOOKUP-FAILED`, never a false value.

---

## 2. Triage (parent coordinator, serial)

- **GREEN** — deterministic mechanical conformance, exact scope known, no consumer-owned geometry/semantics/authority touched, output impact measurable, no unexpected diff. → parallel staging.
- **AMBER** — a bespoke builder / local adapter; a skipped architectural generation; render impact changes committed artifacts; ambiguous version/date; a locally-modified owner file; or (Profile B) a clause whose local meaning depends on project architecture. → the parent rules first.
- **RED** — owner regression or unsafe mutation. → stop that leg, route upstream.
- **HANDOFF** — source data, semantics, project architecture, or source-of-intent judgment; or the wall/grant is absent. → project-owned; not a wave operation.

**AMBER resolution.** The parent may resolve an AMBER question by issuing an **exact bounded disposition**. After that ruling, the remaining deterministic implementation may be **reclassified GREEN and staged in parallel**. The evidence packet records both the original AMBER condition and the parent ruling — so a deterministic operation (e.g. a raster regeneration) does not remain permanently outside the lane once its only ambiguity is resolved.

The at-rest gate (`AGENTS.md` §Cross-Repo Propagation Waves) must pass before any granted consumer is written.

---

## 3. Consumer staging (parallel, isolated)

Each GREEN consumer gets an **exclusive** work area.

**Repos** — isolated worktree from authoritative current state:

```bash
git -C <repo> fetch origin
git -C <repo> worktree add -b <unique-branch> <unique-path> origin/main
test "$(git -C <path> rev-parse HEAD)" = "$(git -C <repo> rev-parse origin/main)"   # confirm clean base
```

**Operator packages (D03/D04-style)** — byte-parity copy, live canonical untouched:

```text
copy the current canonical package at byte parity into a named staging area
edit ONLY the staging copy; leave the live canonical untouched until the parent's post-gate write
```

### Subagent / parent split (single contract)

```text
subagent:   read · census · create isolated worktree · edit · test · prepare a local commit · return evidence
parent:     inspect the final diff · push · open/update the PR · write the narrative · relay Stage-2 · merge
```

A staging subagent prepares a local commit in its exclusive area but **does not push or open a PR** — the parent alone does, avoiding branch-parent contamination, duplicate PRs, and competing narratives. Give every browser worker a unique port and serving root; do not share one mutable `launch.json`.

The evidence packet is the profile's schema (below) plus, where a render change is claimed, before/after PNGs, a console log, and the exact viewport matrix.

---

## 4. Visual + semantic gate (centralized)

Do **not** delegate terminal visual/semantic acceptance to N independent agents. The parent — or the external Stage-2 advisor — inspects one consolidated packet and answers: does the composition read correctly? did a semantic relation change? is it legible at ordinary embed scale? **does the claimed neutrality match the actual pixels?** Byte-identity or a clean bbox matrix is necessary but not sufficient — this layer has repeatedly caught defects after geometry matrices were green. (Profile B analogue: does the re-synced clause preserve local exceptions and change no authority/review/sealing boundary?)

---

## 5. Merge, canonical writes, ledger (serial, parent only)

Only the parent performs: exact-head merge; branch retirement (remove the worktree **before** `--delete-branch`); live operator-canonical revision; frozen snapshot creation; companion placement; canonical/snapshot byte-parity check; consumer-ledger update advanced from the **live** current version (never a forecast number). **Never give the shared ledger to a propagation subagent** — one shared state surface, single-writer. Preserve the ownership division: the owner repo owns shared engines/CSS/support/exporters (or the baseline protocol); each consumer owns its source data, realization, stamps, rasters, sealed artifacts, and local protocol deltas.

---

## At-rest gate — classifying branch and local state

The gate (human + machine) is defined in `AGENTS.md`. Two clarifications the first dogfood run required:

**Branch-name presence is not itself active work.** A branch blocks the gate only when it carries related **unique work that is open, unmerged, unresolved, or actively checked out**. A closed-and-merged PR head whose change is already represented on current `origin/main` is **cleanup residue** (squash-merge leaves the ref; its commits are not `main` ancestors, so a diff against a later `main` can look like a revert). Classify it from the PR lifecycle and patch disposition — do **not** require branch deletion merely to make the gate pass. Such refs may be retired later as hygiene, after the parent verifies each maps to a merged or deliberately abandoned PR, but that cleanup is never a prerequisite and is not bundled into the wave PR.

**Machine evidence covers accessible checkouts, worktrees, branches, and remotes. Human confirmation covers related unpushed work on inaccessible machines or sessions.** Untracked local config (e.g. `.claude/`) is out of any authorized carrier scope and is left untouched — a fresh isolated worktree from `origin/main` does not inherit it.

---

## Profile A — diagram / design-system vendor propagation

**Owner-delta manifest adds:**

```text
contract category:    helper | engine | exporter | CSS | tokens | font-carrier | scaffold
affected pattern classes
expected live-render impact · expected export/raster impact
known neutral classes  (e.g. "landscape diagrams are byte-identical under this exporter")
```

**Census adds:** complete shell/builder census; current vendored blobs vs owner blobs (`git hash-object`); local adapters / duplicated or inlined pre-extraction `fit()`; committed-raster + stamp/version contract; diagram orientation per diagram (portrait height>width vs landscape — decides exporter render-impact).

**Evidence packet (`evidence.json`):**

```text
consumer · authorityClass (direct-operable | granted | handoff | frozen)
baseSha/contentHash · ownerSha + expected blobs
changedFiles · unchangedFilesExplicitlyChecked
ownerParity            per file: MATCH | DIFFERS | LOOKUP-FAILED
shellLoadOrder         helper-before-engine confirmed
callerOwnedValuesPreserved   clearance / maxScale / floors / bounds
liveFitMatrix · interactionMatrix   (zoom floor: no minus/wheel reversal; Fit idempotent)
exportAB               PNG page + PNG diagram, base vs head, per theme
rasterStampDisposition   what stamp/date does; whether a committed raster changes
temporaryFilesRemoved · headSha/stagingPath · unresolvedFindings · recommendation (STOP | READY)
```

---

## Profile B — execution-protocol carrier propagation

For deterministic re-sync of an `AGENTS.md` / template / prompt clause marked for downstream propagation, **while preserving local protocol exceptions**.

**Owner-delta manifest adds:**

```text
owner clause path + landed SHA
clauses explicitly marked for propagation
declared downstream carrier classes   (AGENTS.md · templates · prompts)
```

**Census adds:** recipient carrier census; local exception / delta inventory; whether the clause is an intentional local divergence; substantive-equivalence comparison (the mapping is exact or substantively deterministic, not a blind string replace); authority / review / release / sealing boundaries checked; confirmation the grant text itself is unchanged unless *this* wave explicitly installs it; unrelated carrier text unchanged.

**Evidence packet:**

```text
consumer
ownerClausePath · ownerSha
recipientCarriers
localExceptionsPreserved
canonicalSubstanceMatched
authorityBoundariesUnchanged
reviewMergeReleaseRulesUnchanged
unexpectedDiff
recommendation (STOP | READY)
```

Protocol conformance is **GREEN only** when the owner clause has merged, the downstream carrier is known, the local text is not an intentional divergence, the mapping is exact or substantively deterministic, local deltas remain untouched, no authority/review gate changes, and the grant itself is not being changed. A new permission, a changed merge/review gate, a changed source-of-truth boundary, a changed local exception, a changed release/sealing policy, or a clause whose local meaning depends on project architecture is **AMBER** — census and stage the obvious portion, stop before writing the interpretation.

---

## Serial fallback

When subagents are unavailable, run the same phases sequentially — owner manifest → census → triage → staging → visual/semantic gate → merge/ledger — without weakening any gate. The parallelism is a throughput optimization; the gates are the contract.
