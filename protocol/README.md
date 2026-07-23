# protocol/ — shared execution protocol (owner)

This directory is the **owner canonical for the shared execution protocol**. Shared workflow rules live in **one versioned place**; downstream repos resolve them locally rather than re-deriving or drifting a private copy.

## The one resolution model (used identically by every carrier)

```text
consumer AGENTS.md  =  resolved shared block   (AGENTS.shared.md, verbatim, between BEGIN/END shared markers)
                    +  applicable profiles     (profiles/*.md distributable body, between BEGIN/END profile markers)
                    +  opt-in fragments        (fragments/*.md, verbatim, between BEGIN/END grant markers — separately-operated opt-in only)
                    +  repo-local delta         (between BEGIN/END local-delta markers)
```

Because the shared block lands **inside** each consumer's own `AGENTS.md` — already a required read — an executor sees the full shared protocol locally (the visibility fix).

## What's here

```text
AGENTS.shared.md    the distributable shared body — fixed byte-identical text with per-rule <!-- rule-id: … --> markers.
                    No owner H1, no parameters, no coordinator, no grant, no local delta. Its comment points here via an
                    OWNER-QUALIFIED path so a consumer copy never mis-resolves.
manifest.json       the normative registry (validated by manifest.schema.json + jq relational checks in check.sh).
                    Declares rule ownership, scope, applicability, exclusions, carrier mode, profile, holds, failure mode,
                    lifecycle, and provenance. Declares grant ELIGIBILITY + fragment ownership; NEVER who is currently opted in.
manifest.schema.json  the checked JSON Schema for manifest.json.
profiles/           each profile = owner explanation + a BEGIN/END profile-body fence around the distributable body.
fragments/          verbatim opt-in fragments (body-only). The standing grant.
adapters/           executor-specific artifacts providing runtime enforcement for a SUPPORTED WRITE PATH of an
                    agent-agnostic shared rule on a given runtime — never OS-level enforcement over arbitrary
                    subprocess writes, which the shared protocol prohibits semantically. NOT shared-protocol text
                    and NOT inherited by any consumer's AGENTS.md. One subdirectory per executor;
                    adapters/claude-code/ carries the native permission fragment, the static owner-repo adapter
                    check, the machine-local gate verifier, and their fixtures.
check.sh            deterministic local validator, three modes (--local | --wave | --all). NO CI.
tests/              tests/run-check-fixtures.sh — the durable, map-driven fixture runner (positive controls for every
                    mode + negative fixtures over the checker's rejection paths). Its per-run report is PR/ecology
                    evidence, written to a caller-supplied path, and is NOT committed here.
```

## Requirements

`check.sh` and `tests/run-check-fixtures.sh` require **`jq`**, **`python3`**, and the python3 **`jsonschema`** package (`pip install jsonschema`). This is fail-closed: a missing dependency is a hard FAILURE, never a skipped or silently-passed check. The formal JSON-Schema validation of `manifest.json` runs on every invocation.

`adapters/*/` checks are run **separately** and require only `python3`. Keeping them out of `check.sh` is deliberate: the portable AGENTS checker stays agent-agnostic, so a repo operated by a different executor is never failed by another runtime's adapter.

## The standing-grant fragment (provenance — historical, not live state)

`fragments/standing-upstream-conformance-grant.md` is the **body-only owner fragment** (no owner comment). **The initial fragment body (2743 bytes, SHA1 `1943525a731761a6516fb5c1d9a6d4295be8dc23`) was derived from, and is byte-identical to, the standing-grant body installed in asset-pipeline-ASK at `#389` / `8ed643d` (AGENTS.md blob `fea5c834605e0443afb27fe68d3669afd575e566`) and urban-observatory at `#56` / `c56356f` (AGENTS.md blob `a9501bb7fb77311efb16a324dfbd31bab3ae7412`) — both installed against control-surface `@ 51339c2`.** Those are immutable derivation refs, not a live claim — **current installed parity is tracked only in the operator `control-surface_protocol-consumer-ledger.md`**, and `check.sh --wave/--all` byte-compares each installed grant against this fragment at run time. A separately-operated consumer that opts in inserts the fragment **verbatim** between `<!-- BEGIN grant … -->` / `<!-- END grant -->` markers; direct-core repos do not use it.

## Profiles (distributable-body + insertion contract)

Each `profiles/<profile>.md` carries an owner explanation plus a fenced distributable body:

```text
<!-- BEGIN profile-body: <profile> -->  …distributable body…  <!-- END profile-body: <profile> -->
```

A resolved consumer that adopts a profile carries **only that fenced body**, wrapped in consumer markers, at byte parity:

```text
<!-- BEGIN profile: <profile> -->  <exact fenced body>  <!-- END profile: <profile> -->
```

`architecture-uncertain`'s body is the authoritative twin of `templates/overlays/architecture-uncertain-rules.template.md`. `check.sh` byte-compares owner profile-body ↔ overlay, and (in `--wave/--all`) owner profile-body ↔ each consumer's installed profile body, rejecting owner-wrapper prose inserted into a consumer.

## Ownership boundaries

- This shared body is the authority for the shared rules; the root `control-surface/AGENTS.md` **resolves** it + a fenced `## Control-Surface-Local` delta.
- The coordinator protocol (Cross-Repo Propagation Waves) is control-surface-owned and **referenced**, never replicated.
- Live consumer state (installed pin, present/absent/divergent, propagation, opt-in adoption) lives in the operator ledger. Manifest is normative; ledger is state.
