# Repo Source-of-Intent Nudge // Structured Advisor Prompt

Use this prompt in the advisor surface at local plateaus, after meaningful absorptions, or when the next move is unclear but the durable purpose may already be sufficient. It is a lightweight boundary-classification pass, not generic "what next?"

The nudge is assigned to the advisor role. The role, not the model: the value comes from exteriority to execution-thread momentum, not from which model occupies the role. The same model can occupy the execution role or the advisor role in different threads.

The advisor should not ask the operator to reauthorize a purpose that is already supplied by the durable sources (the repo and the grounding note). If the premise is supplied and the means are unresolved, name the architecture attempt, carrier, trace, pressure test, or routing move that the premise implies — do not promote unresolved means into an unresolved source-of-intent fork.

The direction produced by this nudge is advisory only. It does not authorize execution. Execution still goes through the project's normal scope-discipline and approval gates via `repo-critique-execution-prompt.md` or the execution surface's standard cadence.

---

Read the current repo state and the grounding note before answering. Pay particular attention to the grounding note's higher-level project purpose, foundational premises, and durable loose threads.

Rely on durable truth:

- the repo as it currently is
- the grounding note maintained outside the repo

First, briefly restate the higher-level purpose or source-of-intent premise that is relevant to the current repo state. Anchor the classification against durable intent rather than current thread momentum.

Then answer:

What additional external operator source of intent or direction is needed next to keep developing this repo toward its higher-level purpose?

Classify the answer into one of the following:

1. **No new source intent needed.** The durable sources already contain the premise. The next move should be derived from the current architecture, not routed back to the operator as a new decision. Name the bounded next move the durable sources imply (architecture attempt / carrier / trace / pressure test / routing).
2. **New source intent needed.** A purpose-level question is missing or has changed. Name the specific source-of-intent question the operator should resolve. Do not extend it into procedure.
3. **Sequencing choice.** The means and intent are clear, but the order is not. Name the candidate sequences and what each would pressure.
4. **Bounded architecture attempt.** The premise is supplied but the architecture has not been attempted against it. Name the attempt — its scope, its exit criterion, and what it would pressure.
5. **Repo-local absorption or routing.** The current state has produced something that should be absorbed into the durable structure (repo-side or grounding-note-side) or routed to a different part of the architecture, rather than producing a new artifact.
6. **External synthesis from current durable state.** The repo holds enough material that a synthesis from the current state would be load-bearing — without needing a fresh-context reset. Name what the synthesis would consolidate.
7. **Fresh-context critique.** The durable context itself needs independent reconstruction from repo + grounding note: drift, stale durable context, unresolved purpose, or global-coherence concerns. Escalate to `repo-critique-initial-prompt.md`.

A response of *"no new purpose-level source-of-intent is needed"* is a successful result.

A response of *"real pause point; do not auto-chain"* is also a successful result, but it requires routing: name whether the pause routes to absorption, external synthesis, or fresh-context critique, and why.

Do not route every plateau to the operator. Do not route every plateau to fresh-context critique. Classify the boundary first.
