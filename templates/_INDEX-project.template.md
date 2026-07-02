# _INDEX-\<project> // GPT Source Index (template)

This is a copyable master for a project's **source index / path map** — the file a GPT (or Claude-in-chat) advisor Project mounts as its **primary Project Source**. Adapt it per project. The template lives in the protocol repo.

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

Mount **this index** into the advisor Project's Sources — **not** copies of the canonicals themselves. The canonicals stay live in Dropbox; the advisor fetches the current file at its path when a Dropbox connector is available. Mounted canonical copies, if any remain, are **fallback only** (connector-failure resilience) — never the live truth. This removes the mount-refresh burden: canonicals stay current at their Dropbox path, and this index is a slow-aging map, not a churny mirror.

## Read-path hierarchy

- **Repo truth** → GitHub / local git (authoritative; unchanged).
- **Operator-side canonicals** (`*-EXTERNAL/` root notes · trackers · `scratch/` · `sources of intent/`) → the **Dropbox connector by exact path**, when available (preferred live read path).
- **Uploads / mounted copies** → fallback only, when the connector is absent or a file is unreachable.
- **Web** → public external sources only.

## Dropbox bases / aliases

Define short aliases so the path tables stay readable. Typical bases (adapt to the project):

```text
S/ = /studio/studio ASK/2026 studioASK/                     (studio-side, shared)
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
| sources of intent (intake) | `S/<project>-EXTERNAL/sources of intent/` | candidate / ingestion |
| scratch | `S/<project>-EXTERNAL/scratch/` | fetch **named** artifacts only (`_vN` snapshots, absorption/closure memos) |

Status classes: **root canonical** · **candidate / intake** · **working index** · **scratch / snapshot** · **reference-only** (available cross-domain context the project has *not* absorbed — consult if a task needs it; not this project's doctrine).

*(Add cross-system masters, inheritable/brand paths, or shared protocol files only if this surface is authorized for them and the project actually consumes them. Mark consumed vs. reference-only explicitly.)*

## Wall + search-hygiene rules

- Fetch only the paths named here, by ASK, by a grounding note, or by the active task.
- **Prefer fetch-by-exact-path; reserve keyword/connector search for genuine discovery.** A broad connector search surfaces *filenames* from private / archive trees (a directory-listing leak) even where content reads are blocked — it can expose a private filename manifest. Default to the exact paths above; use search only to discover something not already mapped.
- Any `P/` (`inheritable/`) or other personal-side paths named above are **the only** authorized personal-side paths. **Do not browse the personal root or any other private personal path** — `inheritable/` is wall-safe; the rest is not. On a cross-user surface, **never** point into another user's private namespace (a cross-namespace path resolves to *not-found*, which is the wall behaving correctly — read the user's own twin instead).
- **Fetched ≠ absorbed / canonicalized / promoted.** Header + path govern status (scratch stays scratch, `-TBI` stays TBI, a root canonical is canonical only in its owning surface).
- Connector access is **read-only** — no write / routing.
- If a path is unreachable, say so and stop — never substitute a weaker source while calling it verified.
