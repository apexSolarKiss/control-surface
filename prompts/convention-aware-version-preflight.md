# Convention-Aware Version Preflight

A **read-only, fail-closed check routine** for operator-side versioned canonicals. It verifies that a
canonical's declared version ceremony actually holds before that canonical is advanced, frozen, or
depended on. It reports disagreement. **It never authors corrective prose.**

This is an **operator runbook**, not shared execution protocol. It is not part of
[`protocol/AGENTS.shared.md`](../protocol/AGENTS.shared.md), it is not inherited into any consumer's
`AGENTS.md`, and running it creates no propagation obligation. It is prompt-carried and run by a human
or an executor reading it — deliberately not a deterministic script, because its targets are operator
canonicals whose conventions differ by design (see §Conventions do not converge).

## Why this exists

Version ceremony drifts quietly. A canonical's bytes can be correct while its *ceremony* — the H1
version token, the snapshot that should mirror it, the predecessor anchor, an in-body "current state"
pointer — lags one or more versions behind. Nothing breaks loudly; the file simply begins asserting
something false about its own lineage, and a later reader trusts it.

The drift class is evidenced, not hypothetical. Examples observed on the ecology surface:

- an image-making master whose in-body `mirrors snapshot` pointer stayed two versions behind while its
  H1 advanced twice, and whose own changelog had already healed the identical drift once before;
- a grounding note whose H1 reached `v10` while its `Supersedes` pointer still named `_v8`;
- a package `VERSION.md` whose current entry cross-referenced a sibling package at a version that
  sibling had already left.

Each was repaired individually. The routine below is what would have caught them at the moment of the
next bump, which is the only moment at which repair is cheap.

## When to run it

Required immediately before:

- an operator-canonical **version bump**;
- a canonical or snapshot **freeze**;
- a diagram package **source or render bump**.

Available on demand when a lineage or pointer defect is suspected.

It is **not** a per-read, per-commit, per-session, or universal-startup ritual. Running it where no
version boundary is being crossed reduces no decision-relevant uncertainty and is the ceremony this
routine is meant to prevent, not produce.

## The routine

A fail-closed check routine (not a prose generator). Per canonical, in order:

```text
1  read the declared ceremony convention for that canonical (durable-context vs numbered-draft vs sealed-package)
2  read the H1 version token
3  assert the newest conventional snapshot for that version exists
4  assert live canonical == newest snapshot (byte/hash)
5  where the convention declares one: assert the predecessor / "Supersedes" anchor resolves
6  where applicable: assert the current-delta marker matches the H1 version
7  where applicable: assert the mirror/twin pointer resolves and twin is byte-identical
8  scope every existence/parity search to an exact-name boundary matching the claim boundary
9  on ANY disagreement: fail closed, report the exact mismatch; NEVER author corrective prose
```

Steps 5, 6, and 7 are conditional **on the target's own declaration**, not on the checker's preference.
A target that declares no mirror pointer does not fail step 7; it skips it. A target that affirmatively
prohibits a pinned in-body version claim does not fail step 6; the registry records that prohibition as
its declared convention.

## The convention registry

The routine cannot "read the declared ceremony convention" unless that declaration lives somewhere. It
lives in the registry, which is the declaration the checker reads:

```text
{ canonical_path · lifecycle_species(durable-context|numbered-draft|sealed-package) ·
  version_extractor(H1 // vN | filename _vN | package stamp) · snapshot_dir + exact_filename_pattern ·
  predecessor_anchor? · current_delta_marker? · twin_or_mirror_target? · parity_relationship ·
  exact_name_search_boundary }
```

**Registry rows describe conventions, not current version values.** A row that hard-codes "currently
`_v47`" is stale the next time that canonical is bumped — the version-bearing-pointer failure this
routine exists to catch, reproduced inside the instrument meant to catch it. Observed version values
belong only in a clearly separated **last-verified receipt** field, which is explicitly a dated
observation and never a conformance target.

Operator-side registry locator:

```text
/studio/studio ASK/ecology-ASK-EXTERNAL/ecology-ASK_version-preflight-registry.md
```

That registry is operator state and lives outside this repo. This repo owns the routine and the schema;
the registry owns the populated rows and their last-verified receipts, because rows age at the rate of
the canonicals they describe and the routine does not.

## Conventions do not converge

Do not force durable-context canonicals, numbered drafts, and sealed diagram packages into one ceremony.
They differ for reasons their own carriers state:

- a **durable-context canonical** carries its version in the H1 and cuts a byte-parity `_vN` snapshot;
- a **numbered draft** is frozen at its number, and a change cuts the next number rather than editing in
  place;
- a **sealed package** carries a `source-vN // render-vN` stamp tuple replicated in package-internal
  files, and freezes a whole directory rather than one file.

Even within one species the signal shape varies legitimately — one package may declare a `Current:`
field while its sibling declares that the topmost per-diagram stamp entry *is* the sole version record,
so that a refresh never forces a pointer revision. A checker keyed to one shape will `LOOKUP-FAILED` on
the other. That is a registry-declaration problem, not a defect in the target.

The routine is convention-*aware*: it reads what each target declares and checks that. Whether the
conventions themselves should ever converge is a separate ASK ruling and is not assumed here.

## Evidence boundaries

Every result this routine produces is bounded by the check actually run.

- **Name the exact carrier set, path or glob, and property tested.** "Ceremony holds" is a claim about
  the targets enumerated in the registry, never about the corpus.
- **Anchor the lineage predicate exactly.** A loose glob picks up review objects, proposal artifacts,
  and parallel lineages that are not lineage members. Where a canonical has two plausible snapshot
  naming families, the registry records which one is the declared lineage and the search is anchored to
  it — a preflight that resolves "newest snapshot" against a stray family reports a **false** parity
  failure.
- **A failed lookup is `LOOKUP-FAILED`, never a false value** and never a silent pass. An unreadable
  target, an unresolvable pattern, or a missing declared field fails closed.
- **Distinguish a real mismatch from a representation artifact.** Extracted text, rendered previews, and
  normalized views are inspection representations; parity claims are made against raw bytes or hashes.
- **Report per-target, not in aggregate.** Any single ceremony loss fails on its own; a passing majority
  is not a result.

Where coverage is partial, state the result as `no unexplained findings in <exact set tested>`.

## What it must never do

- **Never author corrective prose.** The routine reports the exact mismatch and stops. A version
  ceremony is a lineage claim; repairing one is an authoring act with its own approval gate.
- **Never rename, normalize, or backfill a historical snapshot** to make a chain look tidy. Frozen
  records are frozen, including their naming generation.
- **Never infer an absent version.** A gap in a numbered chain may be a legitimate noncanonical
  candidate that the target's own text accounts for. The registry records the declared exception; the
  routine does not reason about it.
- **Never treat a target's declared deviation as a defect.** A deviation the carrier states about itself
  is a convention, and it belongs in that target's registry row.
