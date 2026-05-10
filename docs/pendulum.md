# Pendulum (working name) // The Method

This document is a working-name articulation of the method used to design systems-of-systems. It lives in this meta repo because the method does not yet have its own repo. It will graduate to its own repo when accumulation earns it.

## Posture

```text
methodology layer
working-name doc
not just adversarial iteration
comprehensive statement of the method
will graduate to its own repo when earned
```

This is the methodology layer that complements the meta repo's execution-protocol layer. The execution-protocol layer (`AGENTS.md` rules, two review windows, branch discipline, the cadence per [*Adversarial Collaboration*](https://atomicspacekitten.substack.com/p/adversarial-collaboration)) governs how work gets done within a session. The methodology layer governs how a project navigates its own evolution across phases.

The two layers are at different altitudes:

- **Execution protocol** — per-session, per-PR, multi-agent dialogue at the architectural altitude. Workflow rules live in `control-surface/AGENTS.md`; advisor posture and cadence context are recorded in the meta repo's grounding note. Anchored on [*Adversarial Collaboration*](https://atomicspacekitten.substack.com/p/adversarial-collaboration).
- **Methodology** — cross-phase, across-time, single-mind project rhythm. Lives here. Anchored on [*From Execution Proof Back to Normative Structure*](https://atomicspacekitten.substack.com/p/from-execution-proof-back-to-normative).

This document is named after the swing (the pendulum motion that *From Execution Proof Back to Normative Structure* names as the project's rhythm), but it covers more than the swing. The swing is one element of the method. Other elements — ontology development, vocabulary deconstruction, pressure-surface use of prototypes, evidence-trail integrity, and several more — are equally load-bearing. The working name reflects the most recent and visible metaphor; the contents reflect the broader method.

## What This Doc Captures

The method is the practice of designing systems whose structure is itself worth articulating before, during, and after implementation. The project this method is currently pressure-tested against is `apexSolarKiss/asset-pipeline-ASK` — an information architecture for commercial visual asset production pipelines. The project is the worked example; the method is the durable element.

The method is not a single principle. It is a coherent collection of pre-architecture moves, execution disciplines, synthesis disciplines, cross-phase workflow shape, surface-and-voice discipline, and a recursive observation about methodology itself.

This doc names them in one place so a returning operator or external reader can read the method as itself, not only as residue distributed across other artifacts.

## Pre-Architecture Moves

What happens before any architectural commitment, often before any prototyping.

### Ontology development as primary work

Articulating what concepts exist and how they connect — the structured-definition-of-intent — is the durable architectural deliverable. The interface is a view on top of it; the prototype is a pressure test of it; the method's job is to produce the ontology cleanly.

This is distinct from data modeling or schema design. Data modeling answers "what fields does this record have?" Schema design answers "what tables exist and how are they related?" Ontology development answers a deeper question: "what categories of thing does this work treat as load-bearing? what relationships among them make the structure cohere? what would be lost if any single category collapsed?"

In the asset-pipeline-ASK worked example, the ontology work is the IA layered-content articulation: what kinds of information operate at brand-system, category / product-class, packet, slot, and other layers; how those layers inherit, override, and combine; what is shared upstream and what is specific downstream.

### Vocabulary / language deconstruction

Pressure-test the words you are using before committing them to schema or to architectural claims. Make sure terminology is doing the work you think it is. Surface where two words are being used as synonyms when they should not be. Surface where a single word is hiding distinctions that matter.

In asset-pipeline-ASK, the architecture-vocabulary-pass-v1 was this discipline in operation: five carrier-and-discretion distinctions (runtime curation vs upstream setup; prose vs structural representation; visual inputs vs prose fallback; scoped mode-independence; approximate layer count vs load-bearing inheritance) were surfaced before they could harden into structure, while there was still room to refine them.

### Architecture-attempt-before-prototype

Try to model the architecture against a concrete example before building anything. The failure mode this prevents: the prototype becomes the architecture by default, because the prototype is what got built and the architecture was never articulated.

Architecture-attempt is not the same as architecture-completion. The attempt is allowed to be partial, exit-criterion-bounded, and self-superseding. What matters is that the attempt happens upstream of the prototype, and that the prototype runs against the attempt rather than producing the architecture as residue.

### Attempt-model-before-plan

Try to model the work shape before planning execution. Sister to architecture-attempt-before-prototype, applied at the project-direction altitude rather than the schema altitude.

The principle prevents an analogous failure mode: the plan becomes the model by default, because the plan named tasks but never named the structural shape of the work the tasks were addressing.

### Refusal of premature doctrine / permission to be wrong

Do not lock posture or rules before evidence has earned them. Carry named limitations explicitly. Surface held questions rather than resolving them prematurely.

This is the discipline that allows the method itself to evolve. Self-superseding clauses on artifacts; named limitations carried explicitly; held questions surfaced rather than answered too early — these all preserve the method's ability to update when later swings produce evidence the earlier swing could not have produced.

## Disciplines During Execution

What constrains how the work is done once a swing has begun.

### Pressure-surface use of prototypes

Prototypes are pressure surfaces for studying the architecture. They are not the project's center. The architecture is the project; the prototype is the test rig.

This framing keeps the architecture in the position of being tested, refined, and articulated as itself. The prototype's outputs are evidence for or against architectural claims, not the architecture's substance.

### Smallest honest unit / right-altitude scope discipline

Match the unit of work to the level of the question. For implementation and repo hygiene, prefer the smallest honest unit (small bounded PRs are usually best). For conceptual architecture, prefer the largest tractable structural question. Refuse both bundling at the implementation altitude and ceremony at the architectural altitude.

The corollary: do not let "smallest unit" become a rule that prevents zooming out to the right scale. A series of small honest units at the wrong layer adds up to ceremony without architectural progress.

### Ceremony budget

Do not overspend on process where structure suffices. Workflow rules in `AGENTS.md` are calibrated compensations for what single-node operation collapses relative to split-execution; once the rules carry the discipline, the process ceremony that previously did the work becomes redundant. Removing redundant ceremony is part of the method.

### Evidence-trail integrity

Each phase preserves what it produced for the next phase to build on. Do not retrofit evidence-chain artifacts. Let them age in place. New artifacts can refine forward without rewriting history.

The method's integrity at scale depends on this — without it, each new architectural claim either has to relitigate prior claims or quietly invalidates them.

### Aging-rate principle / source-of-truth split

Different surfaces age at different rates. State ages fast (lives in the repo). Rules age slow (live in `AGENTS.md`). Context ages slow (lives in the grounding note). Per-conversation tracking is ephemeral (lives in operator-side memory).

Each surface is sized to a single aging rate. Mixing aging rates within one surface produces a doc that ages at the rate of its fastest-aging contents — usually badly. Maintaining the aging-rate split is part of the method's surface discipline.

## Synthesis Disciplines

How the project moves between phases without losing what came before.

### Synthesis-attempt-against-concrete-example

A synthesis or architectural-pass should pressure the model against a concrete example, not become a recursive narration of earlier passes.

This discipline applies the architecture-attempt-before-prototype principle to synthesis artifacts: the synthesis is allowed to be partial, exit-criterion-bounded, and self-superseding, but it must engage with concrete material rather than circulating among prior abstractions.

### Proof-chain gravity well guard

No new conceptual artifact unless it changes the model, schema pressure, carrier boundary, or governance seam. Findings that do not change those things belong in concise execution records or in-thread, not in new conceptual artifacts.

This guards against the failure mode where every operational discrepancy or process amendment generates a durable artifact whether or not it changes anything load-bearing. The artifact economy stays proportional to actual architectural movement.

### Self-superseding clauses

Every meaningful artifact names what would supersede it. This holds the work in place without locking it. A reader can see what the artifact intends to remain authoritative for, and what would replace or absorb it under specified conditions.

## Cross-Phase Workflow Shape

How the project navigates its own evolution.

### The swing (adversarial iteration)

The pendulum motion between abstraction and execution. Each swing produces something the other cannot. Pure abstraction produces beautiful diagrams that the world refuses to populate. Pure implementation produces a working system whose underlying model is never articulated. The motion between them is the method.

The swing leaves something for the next swing to do, and leaves something the next swing should preserve. Naming what each swing does *not* undo is what keeps the pendulum honest. Otherwise each swing pretends the previous swing was wasted, and the project loses the cumulative evidence each direction produced.

The swing's shape is asymptotic. The architecture and the execution converge across each swing, approaching each other but never meeting. The work is the approach.

### Threshold pauses at architectural closures

Major junctures earn pauses. Phase 1 closure earns a pause. Sequencing forks earn pauses. Auto-chaining is the failure mode to avoid. Closure is structural, not merely the absence of more work — and the structural closure deserves time to absorb before the next move opens.

### Absorption reviews at major thresholds

In-thread reflective pass at major junctures. The output is sometimes a clean assessment, sometimes a small repo correction, sometimes a memory entry, sometimes nothing. The discipline is that the reflection happens before the next work begins.

Absorption reviews are explicitly not always artifact-producing. The right output of a reflective pass is often "the existing state is honest; proceed."

### Direction-check questions at sequencing forks

"What does milestone-X actually need next?" is sharper than "what is next?" Asked at moments where the next move could be one of several. The question shapes the sequencing rather than the available options.

## Surface and Voice Discipline

The method maintains discipline about which voice belongs in which surface. Different artifact types (workflow rules, methodology articulation, project documentation, grounding notes, external writing) have different audiences and different appropriate voices.

Repo-local prose (this doc, `AGENTS.md`, project documentation) stays in systemic / architectural voice. ASK-positioning voice belongs in operator-side grounding notes and in external writing whose purpose is to position. The full articulation of which vocabulary belongs where lives operator-side; this document references the principle structurally without carrying its content.

The principle is recursive: the rule about voice externality stays operator-side. Naming the rule's specifics inside repo prose would itself name the framing the rule keeps out. This document carries the structural reference (voice categories as method elements) and points to operator-side surfaces for the full articulation.

## Relation to Adversarial Collaboration

Adversarial collaboration is the within-session multi-mind execution-protocol layer. Adversarial iteration is the across-time single-mind methodology motion this document is about. They are different patterns at different altitudes operating on different timescales. Both are load-bearing in the working method.

- **Adversarial collaboration** — multi-mind, one moment. Workflow rules live in `control-surface/AGENTS.md`; advisor posture and cadence context are recorded in the meta repo's grounding note. Per-session, per-PR cadence with two review windows.
- **Adversarial iteration** — single-mind, across time. Lives here. Cross-phase swing motion.

Both preserve productive opposition, but they do so through different structures. Adversarial collaboration separates roles across agents in one moment; adversarial iteration separates pressures across phases in time. Adversarial collaboration produces the within-session friction that surfaces architectural disagreements while they are still resolvable; adversarial iteration produces the across-phase motion that lets each phase's evidence pressure the next phase's claims.

## Methodology as First-Class Subject

The recursive observation: the method itself is part of the project's articulated value. The asset-pipeline-ASK grounding note frames the project as more than a pipeline — *"a prototype system for designing such systems."* The meta-pattern (the moves articulated above) is what makes the project's approach reusable beyond its single domain.

This document is the first move toward making the method legible as itself. Before this document, the method lived diffused across `AGENTS.md` rules, milestone notes, the corrective-principles section of milestone-7, and the article line. A returning operator or external reader could reconstruct the architecture-of-furniture-image-production from the docs much more readily than the architecture-of-arriving-at-such-architectures. If the meta-pattern is load-bearing for how the project is understood beyond its single domain, it should be legible as itself, not only as residue.

The recursive shape: this document applies the method to itself. It is an architecture-attempt-before-prototype for the methodology layer. It is a synthesis-attempt-against-concrete-example (the concrete example being asset-pipeline-ASK). It carries a self-superseding clause. It earns its repo-graduation only when accumulated material justifies the move. The method's own articulation respects the method's own discipline.

## Worked Example: asset-pipeline-ASK

The method is visible in the project's history.

The first swing was pure ontology — abstract architecture work. Then a directional reversal toward implementation produced the v1 prototype: the SKU-driven Furniture v1 base operationalized end-to-end, three other modes probed at probe-depth, the architecture surviving cross-mode pressure without structural mutation.

The prototype phase produced its plateau (milestone-7) and surfaced corrective principles: architecture-attempt-before-prototype, vocabulary deconstruction before architectural commitment, synthesis-attempt-against-concrete-example, proof-chain gravity well guard. These are the moves articulated above, surfaced through the project's actual work rather than imposed in advance.

The second swing was back to abstraction — Phase 1 of the IA layered-content redirection. Four worked-example mode sketches plus a cross-mode synthesis. Phase 2 (brand discovery / digestion architecture) is currently in motion. Eventually a third swing back to demonstration will likely close the gap further; the asymptote does not arrive.

The method is not separate from this history; it is what makes the history coherent.

## Self-Superseding Clause

This document is a working-name doc. It should be superseded by:

- its own graduation to a separate repo (working name `pendulum`, may earn a different name as it accumulates content beyond the swing metaphor)
- subsequent articulations of the method that earn deeper coverage of any single element above
- whatever later synthesis absorbs the methodology layer alongside the project's own evolution

The articulation is not finished. Each method element above could earn its own deeper treatment. Some elements may dissolve as later work shows they were instances of more general principles; others may earn first-class status as their own articulated patterns.

## Anchor Documents

### Article cluster (the methodology articulated externally)

- [*Beyond Vibe Coding: Constraining LLMs*](https://atomicspacekitten.substack.com/p/beyond-vibe-coding-constraining-llms) — the prior argument for constrained LLMs and explicit rules; substrate for the discipline this method runs on
- [*From Normative Structure to Execution Proof*](https://atomicspacekitten.substack.com/p/from-normative-structure-to-execution) — the swing toward implementation; "architecture should not rush to implementation, but it should eventually submit itself to it"
- [*Lessons from the First Prototype Phase*](https://atomicspacekitten.substack.com/p/lessons-from-the-first-prototype) — the structural retrospective; ~50x ceremony reduction; calibrated compensations for what single-node collapses relative to split-execution
- [*Adversarial Collaboration*](https://atomicspacekitten.substack.com/p/adversarial-collaboration) — the within-session multi-mind layer; complement to this document at the execution-protocol altitude
- [*From Execution Proof Back to Normative Structure*](https://atomicspacekitten.substack.com/p/from-execution-proof-back-to-normative) — the swing back to abstraction; introduces *adversarial iteration* alongside adversarial collaboration; the pendulum framing this document is named after

### Meta repo and project anchors

- [`AGENTS.md`](../AGENTS.md) — execution-protocol layer for this meta repo; carries the per-PR cadence rule
- [`control-surface.md`](../control-surface.md) — legacy Model-A external control-surface artifact
- [`docs/architecture.md`](architecture.md) — the meta repo's role-model architecture (refresh held as separate question; may eventually absorb collaboration-vs-iteration distinction)
- `apexSolarKiss/asset-pipeline-ASK` — the worked example the method is currently pressure-tested against
- `apexSolarKiss/mazeASK` — separate worked example; still on legacy Model A operating model
