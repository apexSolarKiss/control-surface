# Advisor-surface compression loss

The audited failure that produced
[`docs/advisor-project-surface-architecture.md`](advisor-project-surface-architecture.md), recorded because
the failure mode is general: it appears wherever an operative contract is deployed into a fixed-size,
always-applied field.

This is the generalizable finding. The surface-specific audit — exact paths, version lineage, byte counts,
and per-clause probes — lives in the operator record it cites, not here.

## The mechanism

An advisor contract was deployed into a hosted Project's Instructions field, which has a hard character limit.
The contract grew. Each new requirement then had to be paid for by compressing or removing an existing one.

That trade was made repeatedly, under space pressure, at the moment of installation. It was recorded as
*"compressed to make room"* — never as *what was removed, and what still carries it.*

Three properties made the loss invisible:

1. **The judgment happened at install time**, not at authoring time — the point of least attention.
2. **Every version banner recorded additions.** None recorded removals. A reader auditing the lineage sees a
   monotonically growing feature list over a monotonically shrinking carrier and cannot tell the difference
   between "moved" and "deleted."
3. **A claim stood in for a diff.** One banner asserted the compressed prose was "already carried by" the
   mounted index. Some of it was. No diff was produced, so the rest went with it.

## What was lost

At the 2026-07-25 audit of the ASK deployments, against a searched carrier set of the deployed fields, the
mounted indexes, this repo's advisor template, and `protocol/AGENTS.shared.md`:

```text
4  requirements wholly absent — no carrier anywhere in the searched set
     · historical chronology must not substitute for fresh verification
     · bind a disagreement to the exact rule or premise it pressures
     · state the advisory authority boundary during disagreement
     · do not produce an unsolicited competing implementation

4  requirements surviving only in weakened form — the topic kept, the operative constraint dropped
     · direct verification of live external prototype state before discussing it
     · the criterion defining when ceremony is unearned
     · the reason a conditional Stage-2 approval cannot self-convert
     · the startup check that the protocol owner is reachable

4  requirements present in this repo's template but never propagated to any deployment
     · the epistemic rationale for having an advisor surface at all
     · pressure-testing against the grounding note's foundational premises
     · never infer HEAD from commit search
     · never reconstruct directory state from README prose
```

**The loss propagated forward.** Surfaces instantiated *after* the compression inherited the compressed shape
as their starting point. They did not lose these requirements — they were created without them. A compression
performed once on one surface became a birth defect of every surface instantiated from it afterwards. That is
what makes this architectural rather than incidental.

## What the audit did not find

The protected clause set that each compression explicitly checked — wall boundaries, connector authority,
shared-protocol preflight, review-object retrieval, Stage-2, lifecycle discipline, the no-write boundary —
**survived intact.** The compressions were not careless about what they were watching.

They were lossy about what they were *not* watching, and nothing in the process was watching everything. That
is the point: the defect is structural, not a lapse in diligence. A checked protected set is not an
equivalence proof.

## The rules this produced

**1 · An operative contract does not live in a size-capped, always-applied field.** That field carries only the
pre-retrieval floor — what must bind before any fetch, and must still hold when every fetch fails. The contract
lives in a carrier that can grow.

**2 · A requirement may leave a carrier only with a recorded disposition** — `MOVED` with the exact surviving
carrier named, `REVISED` with the replacement, `RETIRED` with the reason, or `NOT-APPLICABLE` with the surface.
**`DROP-AS-DUPLICATE` without a named surviving carrier is not deduplication; it is deletion.**

**3 · Change records carry removals, not only additions.** Each revision records
`ADDED · REVISED · REMOVED-with-surviving-carrier`. Under a size-capped field this was impossible — there was
no room for it. In a Markdown carrier it costs nothing.

**4 · Recovery reads the union, not the latest copy.** When rebuilding a contract that has been through
compression, the input is the union of current owners, the template, historical carriers, and current
rulings — never the most recent compressed artifact, which is the very object whose completeness is in
question. Historical carriers are *recovery evidence*, not authority: a clause enters the new contract only
through an explicit ruling, and several recovered clauses are correctly retired or revised rather than
restored.

## Reusing this check

Any surface deploying an operative contract into a capped field can run the same audit:

```text
1  identify the compression events in the carrier's version lineage — a large drop in carrier size, or a
   banner mentioning a character limit
2  recover the pre-compression carrier
3  enumerate its operative clauses as requirements, not sentences
4  probe each against every current carrier — the deployed field, the map, the template, the protocol owner
5  re-check every apparent absence semantically; a rephrased requirement is present, not lost
6  disposition each survivor: preserve · restore · revise · retire — with a reason
7  count what is unowned. That number should be zero, and it is the only number that matters
```

Step 5 matters: a substring miss is a hypothesis about absence, not evidence of it. Step 7 matters more: a
requirement with no carrier and no retirement is not a style question.
