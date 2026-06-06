# _dsa-tokens — local design-system-ASK mirror

Local, pinned mirror of design-system-ASK Tier 1 + Tier 2 foundations for the
diagram bundle in this directory. There is **no runtime fetch** from the
design-system-ASK repo and **no Google Fonts CDN dependency** — the diagram
renders entirely from these local files.

**Synced from:** `apexSolarKiss/design-system-ASK`
**Pinned commit:** `2e1ab4cca45d05a4e32b285e5aaea338611bab1c`
**Synced:** 2026-06-06
**`colors_and_type.css` sha256:** `1aeed0fda84cef41a60789613e2a5195b0cae3c208cb047d592f27959bca973c`

**Re-sync 2026-06-06 (`3ecc03e` → `2e1ab4c`):** picks up the foundation light-mode foreground ramp (design-system PR #18 / `f9eed18`) — light `--fg-1/-2/-3` now resolve to dark ink instead of white, fixing white-on-lavender primary text in light mode. Only `colors_and_type.css` changed (new sha256 above); the four font files are byte-identical to the prior snapshot; the diagram engine / `diagrams.css` / `export-png.js` were already current. Diagram `render-vN` stamp bumped (v12 → v13).

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
