# Diagrams // illustrative

These diagrams are illustrative. They are not source truth.

Repo prose remains authoritative. If a diagram and the repo prose disagree, trust the prose and refresh the diagram; do not modify the repo prose to match the diagram.

Each diagram is a structural snapshot of the repo at a point in time. Diagrams age. Repo prose ages too, but more slowly. The diagram should track the repo, not the other way around.

## Authority cadence

- repo prose: source truth
- diagram: illustrative snapshot, refreshed at topology / milestone changes
- repo [`README.md`](../../README.md) and [`docs/architecture.md`](../architecture.md): canonical structure articulation

## Inheritance

The diagram conforms to [`apexSolarKiss/design-system-ASK`](https://github.com/apexSolarKiss/design-system-ASK) Tier 1 + Tier 2 by reference at generation time. The compiled `diagrams.css` in this folder is render support, not identity source truth. `design-system-ASK` remains the visual authority; this folder does not own visual identity.

`diagrams-fit.js`, `diagrams-static-H-engine.js`, `diagrams.css`, and `export-png.js` are **design-system-owned** — vendored byte-identical and not edited here. `diagrams-fit.js` computes a zero-band base candidate, returns that candidate unchanged when it already clears the caption / legend / HUD panels, and reserves the measured panel edges only when the candidate would collide. It must load immediately **before** the engine; the engine throws a named error rather than falling back silently if it is missing.

With no required panel reservation, the prior fit arithmetic is preserved while each available axis is at least twice its requested total clearance. On a more constrained positive axis, total clearance degrades continuously and consumes at most half the available space. Within a fixed available rectangle and panel-reservation state, reducing that axis cannot increase its clearance-limited scale contribution.

Because that fit can land below the engine's ordinary zoom-out floor on a constrained viewport, the live floor is the lower of the historical base floor and the most recent Fit — so zoom-out is a no-op at Fit rather than *increasing* the scale. Fit itself is never clamped.

## Update cadence

- topology or milestone change: refresh the source data file
- per-PR repo edits: do not refresh
- per-article work: do not refresh
- ecology-level structural shift: open a new `source-vN`

## Contents

```text
README.md                                       this file
control-surface_architecture-tree.html          renders TREE_D01
control-surface_architecture-tree.source.js     TREE_D01 data
control-surface_intent-inbox-lifecycle.html          renders TREE_D08
control-surface_intent-inbox-lifecycle.source.js     TREE_D08 data (source-v2) — the routed-instance
                                                     lifecycle as a standalone figure: four events,
                                                     state-keyed resolution, the state machine, closure
                                                     coupling, the two evidence axes, _STATE.md, and
                                                     artifact-instance identity.
                                                     Overlay/events/resolution/state-machine/closure/
                                                     axes/queue/instance-identity are owned by
                                                     AGENTS.shared.md; the
                                                     concrete _STATE.md state vocabulary is owned by
                                                     docs/advisor-project-surface-architecture.md
diagrams-fit.js                                 DS-owned shared fit support; loads
                                                immediately BEFORE the engine
diagrams-static-H-engine.js                     layout + pan/zoom engine
diagrams.css                                    compiled Tier 1 + Tier 2 style
export-png.js                                   3840×2880 PNG export
_dsa-tokens/                                    vendored Tier 1 + Tier 2 token mirror
```

### Live navigation surface

- `index.html` — ASK-branded live navigation surface for this folder's two diagram pages. It consumes the local Tier 1 + Tier 2 mirror and vendored `_dsa-surface/` carriers; its locally assigned Tier 3 does not propagate into either diagram.
- `_dsa-surface/` — pinned, byte-identical `surface-shell`, `surface-panel`, and `surface-action` carriers plus the mode-aware ASK wordmark pair used only by `index.html`.

## How to use

- Open `control-surface_architecture-tree.html` directly in a browser, or via GitHub Pages if configured.
- Drag to pan; scroll to zoom; HUD controls in the bottom-left; `⤢` to fit.
- Theme follows the OS preference (`prefers-color-scheme`); the CSS supports explicit `data-theme="light"` or `data-theme="dark"` on `<html>` if a specific theme is needed.
- The PNG export outputs a 3840×2880 image in the resolved theme.

## Lineage

This repo-local diagram originated in the v9 operator-side `ecology-ASK` diagram package and was first absorbed here at `source-v2 // render-v9`.

The current tuple is `source-v7 // render-v18` (2026-07-27). Source advances when the authored architecture changes; render advances only when the renderer realization changes.

The operator-side package and historical render iterations remain in `ecology-ASK-EXTERNAL/scratch/` and are not repo truth.

## What this folder does not carry

- `TREE_D02` (method-ASK topology) — lives in `apexSolarKiss/method-ASK/docs/diagrams/` (landed)
- `TREE_D03` (system-ASK topology) — operator-side only; not authorized for any repo absorption
- Operator-side context architecture substrate (private; conform by reference, do not absorb)
- Tier 3 identity inside the diagram artifacts — excluded by the Tier model; both figures remain Tier 1 + Tier 2. `index.html` is a separate ASK-branded live navigation surface and carries an ASK-assigned Tier-3 value for that surface only: the assignment does not propagate into either diagram, does not make `control-surface` ASK-the-entity, and does not come from `surface-shell`, which ships a slot and no mark.
- Runtime dynamic import from `design-system-ASK` CSS (no; conform at generation time)
