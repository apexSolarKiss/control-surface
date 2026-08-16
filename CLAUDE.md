# CLAUDE.md

@AGENTS.md

This repository's workflow rules live in `AGENTS.md`. They apply to Claude Code the same as they apply to any other executor. Follow `AGENTS.md` for branch discipline, scope discipline, plan-before-execute, single-writer discipline, and structured change summaries.

For repo-external context (project intent, audience, philosophy, foundational premises, durable loose threads), read the grounding note maintained outside this repository.

For project state (what this protocol repo currently contains and how the pieces relate), start from `README.md` and `docs/architecture.md`.

## Compact Instructions

Claude Code manages context automatically as the window approaches capacity: it clears older tool outputs first, then summarizes the conversation if needed. If ASK does not compact earlier, automatic compaction is the normal continuation path. ASK may also run `/compact` manually and name a focus to preserve.

**Context pressure alone is not a reason** to stop, recommend a fresh session, write a recap, transfer a program, or ask ASK to choose between threads. The governing rule is `AGENTS.md` §Verification Claims and Evidence Boundaries.

Before any further action after compaction, **affirmatively re-establish** the portable continuity set required by `AGENTS.md` §Verification Claims and Evidence Boundaries — do not wait to notice a gap:

- the current ASK authorization and approved scope;
- explicit non-actions;
- the current gate and intended terminal state;
- exact durable-owner, review-object, PR, and artifact locators, each carrying the load-bearing state identity that makes it reviewable — PR base and head SHA, commit, version, or hash, as applicable;
- unresolved blockers and write-aperture state.

Recovery differs by limb. **ASK authority:** preserve the exact ASK relay or envelope; if it cannot be independently established after compaction, stop and obtain a fresh ASK relay — **never reconstruct authority** from a program row, plan, recap, PR, review object, artifact, or the compaction summary. **State and evidence:** re-read their durable owners. **Mutable objects:** re-verify the load-bearing state identity, since a PR URL without its approved base and head SHA does not preserve the reviewed state. **The compaction summary is continuation context, not an authoritative replacement for those owners.**

**Compaction is not assumed lossless** — detailed instructions from early in the conversation may be lost. If a concrete source or state item is missing afterward, name it and recover it from its durable owner; a missing **authorization** follows the authority rule above instead, not this one. Report an explicit compaction error as the failure it is; never infer one from thread length or workload. Auto-compaction can genuinely fail: when a single oversized file or tool output refills the window after each summary, Claude Code stops retrying and shows an error rather than looping. Avoid unnecessarily loading or emitting any single file or tool output large enough to refill the context immediately after summarization; whole-file dumps are one common cause.
