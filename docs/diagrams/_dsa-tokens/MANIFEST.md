# _dsa-tokens — local design-system-ASK mirror

Local, pinned mirror of design-system-ASK Tier 1 + Tier 2 foundations for the
diagram bundle in this directory. There is **no runtime fetch** from the
design-system-ASK repo and **no Google Fonts CDN dependency** — the diagram
renders entirely from these local files.

**Synced from:** `apexSolarKiss/design-system-ASK`
**Pinned commit:** `1231d03040c74eb4eedf7be2e3214da9766e63f7`
**Synced:** 2026-06-26
**`colors_and_type.css` sha256:** `bcd11e0efeae2851c8653a425f94a76cb6423c770e23cb18b3a0315519a7375f`

**Re-vendor 2026-07-10 — `export-png.js` fail-closed under `file://` (design-system PR #61 `ed64b42`), render-neutral for http, stamp held.** Follow-up to #60: the exporter now **fails closed** when it can't embed the fonts — under a `file://` page (Chromium blocks the woff2 fetch) or any incomplete embed it blocks the export with a "serve over http" warning instead of silently emitting a fallback-font (clipped) PNG. `export-png.js` re-vendored **byte-identical** from DS @ `ed64b42` (md5 `04aa5177`). **Exporter-only** — tokens/fonts/`diagrams.css`/engine unchanged; the `_dsa-tokens` mirror pin above is untouched. **Render-neutral for this bundle** — the successful http export output is unchanged (this diagram renders over http); the guard only blocks broken `file://` exports, so the `render-vN` stamp is **held**. Exporter pin tracked in the operator consumer-ledger (item 9).

**Re-vendor 2026-07-10 — `export-png.js` font-embed fix (design-system PR #60 `9b05d9a`), render-neutral for this bundle, stamp held.** The shared raster exporter now embeds the page's own `@font-face` faces (base64) into the exported SVG `<defs>` before rasterizing — fixing right-edge node-text clipping in headless / font-absent PNG renders (SVG-as-image is font-isolated from the document's web fonts). `export-png.js` re-vendored **byte-identical** from DS @ `9b05d9a` (the four static copies are byte-identical). **Exporter-only** — tokens, fonts, `diagrams.css`, and the engine are unchanged; the `_dsa-tokens` mirror pin above is untouched. **Render-neutral for this bundle** (no committed raster; visual output is unchanged where the fonts are present, which is how this diagram renders), so the diagram `render-vN` stamp is **held**; the fix corrects only headless / font-absent exports. Exporter pin tracked in the operator consumer-ledger.

**Re-sync 2026-06-26 (`b5d158e` → `1231d03`) — COMMENT-ONLY, render-neutral:** design-system PR #56 corrected two stale **comments** in `colors_and_type.css` ("five-color core" header → "a core identity set"; "Core 5 — backgrounds + text" block label → "Core set — backgrounds, wordmark, dark-mode text"). **No token value, role name, selector, or behavior change** — only the new `colors_and_type.css` sha256 above differs. Fonts byte-identical; `diagrams.css` / engine / `export-png.js` unchanged. **Diagram `render-vN` stamp held.**

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
