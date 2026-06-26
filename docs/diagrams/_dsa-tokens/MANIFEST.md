# _dsa-tokens — local design-system-ASK mirror

Local, pinned mirror of design-system-ASK Tier 1 + Tier 2 foundations for the
diagram bundle in this directory. There is **no runtime fetch** from the
design-system-ASK repo and **no Google Fonts CDN dependency** — the diagram
renders entirely from these local files.

**Synced from:** `apexSolarKiss/design-system-ASK`
**Pinned commit:** `b5d158e6b2a74faf7dae92e3d15a6ee0a3baba59`
**Synced:** 2026-06-26
**`colors_and_type.css` sha256:** `d3a94ac725e76ac8fdd290797ac1288799cf6f5c02e51f269c3cb666be4cb4fa`

**Re-sync 2026-06-26 (`2e1ab4c` → `b5d158e`) — RENDER-NEUTRAL conformance:** picks up the light-mode foreground conformance (design-system PR #52) and the diagram foreground-alias de-dup (PR #53). In `colors_and_type.css`: `--ask-white`/`--fg-1` comments corrected (white = wordmark, not body text), `--ask-fg-light` (`#6A637F`) + `--fg-high-contrast` (reserved `#201D26`) added, `--fg-on-card` rebound to `var(--fg-1)`, `.bg-ask-light` text white→`var(--fg-1)`. In `diagrams.css`: the scoped text roles `--diagram-ink/muted/faint` now **alias** `var(--fg-1/-2/-3)` instead of hardcoding the ramp (redundant dark-text redefs dropped; structural strokes stay local). **Resolved values are unchanged in both themes** — this diagram uses none of the rebind-affected roles (`--fg-on-card` / `.bg-ask-light`), and `--fg-1` still resolves to `#6A637F`. Only `colors_and_type.css` + `diagrams.css` changed (new sha256 above); the four font files are byte-identical; the diagram engine / `export-png.js` were already current. **Diagram `render-vN` stamp held** (render-neutral).

| File | Upstream source | Role |
|---|---|---|
| `colors_and_type.css` | `/colors_and_type.css` | Tier 1 + Tier 2 tokens + `@font-face` (light default · `[data-theme="dark"]` · `prefers-color-scheme` auto-bridge) |
| `fonts/InterVariable.woff2` | `/fonts/` | display family |
| `fonts/InterVariable-Italic.woff2` | `/fonts/` | display italic |
| `fonts/JetBrainsMono.woff2` | `/fonts/` | mono family |
| `fonts/JetBrainsMono-Italic.woff2` | `/fonts/` | mono italic |
| `fonts/Inter-OFL.txt`, `fonts/JetBrainsMono-OFL.txt` | `/fonts/` | SIL OFL license texts |

Re-sync this mirror (and bump the pin above + the diagram's `render-vN` stamp)
when the upstream tokens or fonts change.
