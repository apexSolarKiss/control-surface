# _INDEX-\<project> // GPT Source Index (template)

This is a copyable master for a project's **source index / path map** — the retrieval map an advisor surface fetches **live** at the exact locator its mounted bootstrap declares. Adapt it per project. The template lives in the protocol repo.

**Mount posture.** In healthy connector mode this file is **not mounted**. The advisor Project's single standing Markdown Source is that surface's bootstrap (`templates/advisor-project-bootstrap.template.md`); the bootstrap carries this index's exact locator and fetches it live, so an ordinary index revision needs no remount. Mount a copy only as connector-failure fallback, and retire it when live access returns. The placement contract is owned by [`docs/advisor-project-surface-architecture.md`](../docs/advisor-project-surface-architecture.md).

**Instantiate as** (angle brackets resolve to real names — do not keep them in the actual filename):

```text
<project>-EXTERNAL/_INDEX-<project>.md
```

For role-specific advisor surfaces (e.g. an operator-facing vs. a domain-reviewer-facing project), instantiate one per role:

```text
<project>-EXTERNAL/_INDEX-<project>-<role>.md
```

Keep this file generic when adapting: fill the tables with the project's own canonical paths, delete the example rows, keep the read-path hierarchy + wall rules. Do **not** copy another project's full path set in.

---

## A map, not a mirror

This index maps canonicals — it does not carry copies of them. The canonicals stay live in Dropbox; the advisor fetches the current file at its exact path. Mounted or uploaded copies of canonicals, if any remain, are **fallback only** (connector-failure resilience) — never the live truth.

The same rule now applies to this file itself. It is **fetched, not mounted**: the mounted bootstrap declares its exact locator, and the advisor retrieves the current version each thread. That removes the last mount-refresh obligation — an ordinary path or status change here reaches every advisor surface with no UI operation at all.

## Read-path hierarchy

- **Repo truth** → GitHub / local git (authoritative; unchanged).
- **Operator-side canonicals** (`*-EXTERNAL/` root notes · trackers · `scratch/` · `sources of intent/`) → the **Dropbox connector by exact path**, when available (preferred live read path).
- **Uploads / mounted copies** → fallback only, when the connector is absent or a file is unreachable.
- **Web** → public external sources only.

## Dropbox bases / aliases

Define short aliases so the path tables stay readable. Typical bases (adapt to the project):

```text
S/ = /studio/studio ASK/                                    (studio-side, shared)
P/ = /Andrew Klug/personal-ASK/inheritable/                 (wall-safe inheritable layer — ONLY if the surface is authorized for it)
```

Add or remove bases per project. A cross-user surface may reach only a subset (e.g. a shared `/studio/…` tree but not another user's private namespace) — name only the bases this surface can actually resolve.

## Canonical path table

List only the paths this surface is authorized to read. Give each a **status class** so the advisor knows what it may treat the file as.

| File | Path | Status class |
|---|---|---|
| \<project> grounding note | `S/<project>-EXTERNAL/<project>_grounding-note.md` | root canonical |
| \<project> article / domain tracker | `S/<project>-EXTERNAL/<project>-articles.md` | root canonical *(example — delete if N/A)* |
| working index / corpus-state | `S/<project>-EXTERNAL/scratch/…_<project>_<index>.md` | working index *(resolve-latest by glob, not a pinned date)* |
| sources of intent (intake) | `S/<project>-EXTERNAL/sources of intent/` | candidate / ingestion — the **filename lifecycle marker** carries current disposition (`-TBI` active queue · unmarked ingested · `-SUPERSEDED` retired before ingestion); the folder alone does not establish queue membership |
| scratch | `S/<project>-EXTERNAL/scratch/` | fetch **named** artifacts only (`-PROPOSED` review objects/bundles, `_vN` snapshots, absorption/closure memos) |

Status classes: **root canonical** · **candidate / intake** · **working index** · **scratch / snapshot** · **reference-only** (available cross-domain context the project has *not* absorbed — consult if a task needs it; not this project's doctrine). The shared-protocol rows below additionally use **owner canonical** · **normative registry** · **coordinator canonical**.

*(Add cross-system masters, inheritable/brand paths, or shared protocol files only if this surface is authorized for them and the project actually consumes them. Mark consumed vs. reference-only explicitly.)*

### Shared execution-protocol architecture

*(**Required** when the project's `AGENTS.md` resolves the ASK shared execution protocol. Delete this subsection only for a project that does not.)*

| File | Path | Status class |
|---|---|---|
| shared-protocol owner model | `apexSolarKiss/control-surface/protocol/README.md` | owner canonical |
| shared execution-protocol body | `apexSolarKiss/control-surface/protocol/AGENTS.shared.md` | owner canonical |
| normative protocol manifest | `apexSolarKiss/control-surface/protocol/manifest.json` | normative registry |
| cross-repo propagation runbook | `apexSolarKiss/control-surface/prompts/cross-repo-propagation-wave.md` | coordinator canonical |
| live protocol-consumer state | `<authorized operator-side path>/control-surface_protocol-consumer-ledger.md` | root canonical — live state |

- These rows are **mandatory** for a project whose `AGENTS.md` resolves the shared ASK carrier. The advisor instructions require these files for any question about rule placement, `AGENTS.md` / `CLAUDE.md`, private agent memory, learning disposition, grants, or propagation; an index without the rows leaves the advisor no route to them.
- The four repo canonicals are fetched from **GitHub / local git**, not Dropbox.
- Instantiate the ledger row **only** where this advisor surface is authorized to read that operator-side path. Omit the row rather than naming a path the surface cannot resolve.
- Manifest is normative; the ledger is live state. Do not read either as the other.
- This stays a **map**: fetch this index live at the bootstrap-declared locator; do not mount copies of the mapped files as current sources.

## Wall + search-hygiene rules

- Fetch only the paths named here, by ASK, by a grounding note, or by the active task.
- **Prefer fetch-by-exact-path; reserve keyword/connector search for genuine discovery.** A broad connector search surfaces *filenames* from private / archive trees (a directory-listing leak) even where content reads are blocked — it can expose a private filename manifest. Default to the exact paths above; use search only to discover something not already mapped.
- Any `P/` (`inheritable/`) or other personal-side paths named above are **the only** authorized personal-side paths. **Do not browse the personal root or any other private personal path** — `inheritable/` is wall-safe; the rest is not. On a cross-user surface, **never** point into another user's private namespace (a cross-namespace path resolves to *not-found*, which is the wall behaving correctly — read the user's own twin instead).
- **Fetched ≠ absorbed / canonicalized / promoted.** Header + path govern status (scratch stays scratch, `-TBI` stays TBI, a root canonical is canonical only in its owning surface).
- Connector access is **read / verify only — capability is not authorization.** A connector may expose write actions (a GitHub connector: commit / branch / open-close-merge PR / comment / auto-merge; a Dropbox connector: file save / move / routing); **none are authorized on an advisor surface.** Use connectors only to fetch named files, read exact PRs / diffs / state, and verify relayed claims; every write routes through the executor on the operator's relay (see the advisor Project Instructions §Connector boundary).
- If a path is unreachable, say so and stop — never substitute a weaker source while calling it verified.
