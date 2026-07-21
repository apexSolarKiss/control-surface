# AGENTS Template — payload-free bootstrap

Starter for `AGENTS.md` in a downstream ASK repo. **This template is a shell, not a protocol copy.** A resolved `AGENTS.md` is the **one four-part model**:

```text
resolved shared block  (from control-surface/protocol/AGENTS.shared.md, verbatim, between BEGIN/END shared markers)
+ applicable profiles  (protocol/profiles/*.md fenced body, between BEGIN/END profile markers)
+ opt-in fragments     (protocol/fragments/*.md, verbatim, between BEGIN/END grant markers — separately-operated opt-in only)
+ repo-local delta      (between BEGIN/END local-delta markers)
```

Do not hand-paste the shared bodies, a profile body, or the grant. All three are installed and maintained by the propagation wave (Profile B). `protocol/check.sh --local` fails if this template inlines any of them; `--wave/--all` byte-compares each installed part against its owner.

---

<!-- BEGIN carrier-metadata -->
CARRIER_TYPE: resolved-local
SHARED_BLOCK_SOURCE: apexSolarKiss/control-surface/protocol/AGENTS.shared.md
SHARED_BLOCK_PIN: <owner-merge-commit>            # filled at install; a resolved carrier must carry a real pin, no placeholder
PROFILES: []                                       # exact list of adopted profile ids, e.g. ["core-ecology"]
GRANT_FRAGMENT: none                               # none | standing-upstream-conformance-grant@<owner-pin>
OPERATING_SURFACE: <direct-core | separately-operated>
<!-- END carrier-metadata -->

*(In the shell above, `<…>` placeholders are legal. A **resolved** carrier must replace every placeholder; `check.sh` rejects a resolved carrier that still contains `<…>`. `PROFILES` and `GRANT_FRAGMENT` here are the consumer-side evidence the operator ledger is populated from — the metadata must agree with the installed bytes.)*

---

<!-- BEGIN shared: AGENTS.shared.md -->
<!-- The resolved shared execution-protocol body is inserted here verbatim from control-surface/protocol/AGENTS.shared.md
     at SHARED_BLOCK_PIN, machine-maintained by the wave. Do not edit between these markers. -->
<!-- END shared -->

---

Each adopted profile is installed by the wave (Profile B) as one marker pair carrying the owner's fenced profile-body **verbatim** (not the owner explanation), in this form — shown escaped in a fenced block so a marker parser cannot mistake the example for an installed profile:

```text
<!-- BEGIN profile: <profile-id> -->
<exact fenced body from protocol/profiles/<profile-id>.md>
<!-- END profile: <profile-id> -->
```

`check.sh --wave/--all` byte-compares each installed profile body to its owner and rejects owner-explanation prose. Do not hand-insert profiles; if `PROFILES` is `[]` the wave leaves the surface below empty.

<!-- BEGIN profiles -->
<!-- PROFILE BLOCKS ARE INSERTED HERE BY THE PROPAGATION WAVE -->
<!-- END profiles -->

---

<!-- BEGIN grant: standing-upstream-conformance-grant (OPTIONAL — separately-operated opt-in only) -->
<!-- Include ONLY if GRANT_FRAGMENT != none AND OPERATING_SURFACE: separately-operated. A direct-core repo does NOT use
     a standing grant. When opted in, the wave inserts the VERBATIM body of
     control-surface/protocol/fragments/standing-upstream-conformance-grant.md between these markers — the full
     permission boundary, not a summary. Delete both markers if not opted in. check.sh byte-compares to the fragment. -->
<!-- END grant -->

---

<!-- BEGIN local-delta -->
## Required Reading — repo-local delta

*(The shared §Required Reading points here. Name this repo's exact reads.)*

- this repository's `README.md`
- this `AGENTS.md`
- `[primary architecture doc]`
- `[repo-specific entry-point doc(s)]`
- external: the grounding note

## Source-of-Truth — repo-local additions

- `[project-specific live truth surfaces, e.g. a database, a CMS, direct visual evidence]`

## Project-Specific Defaults

- `[testing or verification commands]`
- `[protected paths or high-risk areas]`
- `[external systems with their own mutation discipline]`
- `[terminology to preserve]`

## Architecture-Specific Rules (optional)

If the project's information architecture has a load-bearing creative or governance act, model it as first-class. If the task surface is architecture/ontology-uncertain, adopt the `architecture-uncertain` profile.

## Coordinator protocol (reference, not copy)

This repo does not carry the cross-repo propagation coordinator protocol. When a wave touches this repo it is coordinated from `control-surface/AGENTS.md` §Cross-Repo Propagation Waves + `control-surface/prompts/cross-repo-propagation-wave.md`.
<!-- END local-delta -->
