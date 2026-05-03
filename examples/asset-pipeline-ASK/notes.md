# asset-pipeline-ASK Notes

`apexSolarKiss/asset-pipeline-ASK` is the single-node working example for the control-surface workflow — the default operating model for new ASK projects. `apexSolarKiss/mazeASK` is the legacy Model A working example, still active for that project.

## Operating Model

Single-node — Claude Code is both control surface and executor. GPT remains available as optional advisor but is rarely used in current operation.

The project ran on the legacy split-execution model (Model A) earlier in its history. Model A was sunset on this project once the single-node path proved out at scale (substantially less ceremony, faster iteration, direct ASK-to-Claude conversation in place of operator-as-go-between).

The repo's `AGENTS.md` is the most advanced live working example in the family and is the source the meta repo's `templates/AGENTS.template.md` is now aligned to.

## Lifecycle Stage

Operational. The target repo exists, repo-local files are authoritative, milestone-anchored learnings are accumulating, and the workflow is producing artifacts at meaningful pace.

The earlier instantiation-phase note (used when the repo did not yet exist) is preserved here as an example of how an instantiation-first project transitions through bootstrap into operational use.

## Selected Anchors

These are not policy, but they show what the workflow has produced when applied at scale:

- **Curation event modeled as first-class.** The project's load-bearing creative-discretionary act (curation) is encoded directly in the schema with provenance fields (`capture_reason`, `captured_at`, `source_attachment_id`, `capture_notes`, `curation_pattern`, `curator`) plus the asset itself carried via `asset_attachment`. Generic process rules cannot stand in for domain-specific structural decisions like this.
- **Curation patterns surfaced through real test work.** Five distinct curation patterns (algorithmic, agent-proposed-human-ratified, batch-output-no-curator-selection, agent-vision-proposed-human-ratified, human-cross-round-authorship-bearing-curation) — each anchored to a specific test artifact and PR.
- **Milestone-5 thin-bridge limitation surfaced and resolved.** Earlier governed-asset rows were text-references only; an asset_attachment field (multipleAttachments with attachment-copy writeback) made governed assets self-contained. Backfill resolved 9 of 11 prior rows; 2 unrecoverable rows surfaced the architectural cost of the thin-bridge.
- **Plan-Before-Execute and Structured Change Summary replaced per-action authorization** for Airtable schema mutations. The discipline is encoded in `AGENTS.md` and is the primary compensation rule for the single-node model's collapsed prompt-compilation step.
- **Article anchors.** Four published Substack articles are linked from the repo's architecture as the public-facing thread of the work.

## What This Example Surfaced For The Meta Repo

- The aging-rate principle as the load-bearing rationale for the source-of-truth split
- Session topology / single-writer discipline as a real failure mode worth encoding as a rule
- Why-the-rules-exist framing: most workflow rules are calibrated compensations for what the single-node model collapses relative to legacy Model A
- The grounding note's narrower scope when operator-side memory handles per-conversation tracking

These all flow into the meta repo's current `AGENTS.md`, `docs/architecture.md`, and the templates.
