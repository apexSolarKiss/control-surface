# asset-pipeline-ASK Notes

[`apexSolarKiss/asset-pipeline-ASK`](https://github.com/apexSolarKiss/asset-pipeline-ASK) is the mature working example for the control-surface workflow and the primary pressure surface for rule evolution. [`apexSolarKiss/mazeASK`](https://github.com/apexSolarKiss/mazeASK) is the dormant historical origin case, retained as provenance rather than as a current example.

## Operating Model

Adversarial collaboration — ASK is the source-of-intent and authorization apex, the relay across surfaces, and the final adjudicator. A GPT advisor supplies external challenge, reconstruction, and verification from outside the execution thread; Claude Code is the repo-attached execution surface.

The project ran on the legacy split-execution model (Model A) earlier in its history. Model A was sunset once direct ASK-to-Claude Code execution proved out at scale — substantially less ceremony, faster iteration, and direct ASK-to-Claude conversation in place of operator-as-go-between. AP later adopted the current advisor–executor topology, adding GPT as an external review surface without restoring the old prompt-compiler/executor chain.

The repo's `AGENTS.md` is the most advanced live working example in the family and a pressure-source for the protocol repo's shared execution-protocol core, `protocol/AGENTS.shared.md` — the distributable body each consuming repo resolves verbatim into its own `AGENTS.md` between the shared markers.

## Lifecycle Stage

Operational. The target repo exists, repo-local files are authoritative, milestone-anchored learnings are accumulating, and the workflow is producing artifacts at meaningful pace.

The earlier instantiation-phase note (used when the repo did not yet exist) is preserved here as an example of how an instantiation-first project transitions through bootstrap into operational use.

## Selected Anchors

These are not policy, but they show what the workflow has produced when applied at scale:

- **Curation event modeled as first-class.** The project's load-bearing creative-discretionary act (curation) is encoded directly in the schema with provenance fields (`capture_reason`, `captured_at`, `source_attachment_id`, `capture_notes`, `curation_pattern`, `curator`) plus the asset itself carried via `asset_attachment`. Generic process rules cannot stand in for domain-specific structural decisions like this.
- **Curation patterns surfaced through real test work.** Five distinct curation patterns (algorithmic, agent-proposed-human-ratified, batch-output-no-curator-selection, agent-vision-proposed-human-ratified, human-cross-round-authorship-bearing-curation) — each anchored to a specific test artifact and PR.
- **Milestone-5 thin-bridge limitation surfaced and resolved.** Earlier governed-asset rows were text-references only; an asset_attachment field (multipleAttachments with attachment-copy writeback) made governed assets self-contained. Backfill resolved 9 of 11 prior rows; 2 unrecoverable rows surfaced the architectural cost of the thin-bridge.
- **Plan-Before-Execute and Structured Change Summary replaced per-action authorization** for Airtable schema mutations. The discipline is encoded in `AGENTS.md`; it is what makes the executor's reasoning inspectable before it becomes a mutation, in a form ASK or the advisor surface can challenge.
- **Article anchors.** Four published Substack articles are linked from the repo's architecture as the public-facing thread of the work.

## What This Example Surfaced For The Protocol Repo

- The aging-rate principle as the load-bearing rationale for the source-of-truth split
- Session topology / single-writer discipline as a real failure mode worth encoding as a rule
- Why-the-rules-exist framing: workflow rules make reasoning inspectable across ASK, the executor, and any configured advisor while preserving single-writer mutation; the advisor/executor seam is the standard pressure surface, not the only valid path
- The grounding note's narrower scope when ephemeral task state handles per-conversation tracking and private agent memory remains a persistent, non-authoritative cache rather than a tracking surface

These all flow into the protocol repo's current `AGENTS.md`, `docs/architecture.md`, and the templates.
