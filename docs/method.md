# Method // Designing Systems That Build Systems

This document is the methodology layer's articulation of the method used to design systems that produce, govern, template, or instantiate other systems. Some downstream systems are themselves systems-of-systems; the broader target is the system-building layer. It lives in this meta repo as a transitional bridge because the method does not yet have its own repo. It will graduate to its own repo when accumulation earns it.

## Posture

```text
methodology layer
transitional bridge in control-surface
not just adversarial iteration
comprehensive statement of the method
will graduate to its own repo when earned
```

This is the methodology layer that complements the meta repo's execution-protocol layer. The execution-protocol layer (`AGENTS.md` rules, two review windows, branch discipline, the cadence per [*Adversarial Collaboration*](https://atomicspacekitten.substack.com/p/adversarial-collaboration)) governs how work gets done within a session. The methodology layer governs how a project navigates its own evolution across phases.

The two layers are at different altitudes:

- **Execution protocol** — per-session, per-PR, multi-agent dialogue at the architectural altitude. Workflow rules live in `control-surface/AGENTS.md`; advisor posture and cadence context are recorded in the meta repo's grounding note. Anchored on [*Adversarial Collaboration*](https://atomicspacekitten.substack.com/p/adversarial-collaboration).
- **Methodology** — cross-phase, across-time, single-mind project rhythm. Lives here. Anchored on [*From Execution Proof Back to Normative Structure*](https://atomicspacekitten.substack.com/p/from-execution-proof-back-to-normative).

The pendulum / swing motion that *From Execution Proof Back to Normative Structure* names as the project's rhythm is one element of the method, not the whole. Other elements — ontology development, vocabulary deconstruction, pressure-surface use of prototypes, evidence-trail integrity, and several more — are equally load-bearing. The doc covers the broader method; the swing is the most recent and visible metaphor but does not exhaust the content.

## What This Doc Captures

The method is the practice of designing systems whose structure is itself worth articulating before, during, and after implementation. The project this method is currently pressure-tested against is `apexSolarKiss/asset-pipeline-ASK` — an information architecture for commercial visual asset production pipelines. The project is the worked example; the method is the durable element.

The method is not a single principle. It is a coherent collection of pre-architecture moves, execution disciplines, synthesis disciplines, cross-phase workflow shape, surface-and-voice discipline, and a recursive observation about methodology itself.

This doc names them in one place so a returning operator or external reader can read the method as itself, not only as residue distributed across other artifacts.

## Recursive System Roles

The method applies across recursive system roles, not a single fixed level.

- **Articulated system** — a discrete artifact or project whose structure is worth making explicit. [`apexSolarKiss/mazeASK`](https://github.com/apexSolarKiss/mazeASK) is the historical project-scale example: a concrete maze-game repo whose Model-A workflow pressure helped surface the need for a reusable control-surface pattern, later generalized in this meta repo.
- **System-of-systems** — an operational system composed of interacting subsystems. A governed visual asset production pipeline can fit this role: brand inputs, product data, reference systems, generation surfaces, curation seams, governance records, and output assets operate together as one production system.
- **System-building system** — a system that produces, governs, templates, or instantiates other systems. [`apexSolarKiss/asset-pipeline-ASK`](https://github.com/apexSolarKiss/asset-pipeline-ASK) fits this role for governed visual asset production pipelines. [`apexSolarKiss/control-surface`](https://github.com/apexSolarKiss/control-surface) fits this role for AI-native execution workflows.

The method does not change shape across these roles. Ontology development, vocabulary deconstruction, architecture-attempt-before-prototype, pressure-surface prototypes, ceremony budget, evidence-trail integrity, self-superseding clauses, the swing, and the fresh-context critique cycle apply whether the work is an articulated system, a system-of-systems, or a system-building system.

The recursion is part of why the method is worth articulating as itself. This document is itself a structured artifact produced by the method it describes.

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

### Source-of-intent guard

Fresh critique, synthesis, and handoff recaps may surface gaps between stated purpose and current evidence. Those gaps must not automatically become requests for the operator to reauthorize the purpose.

When the grounding note or repo-local premise already states the end, treat the gap as an architectural means problem: what carrier, trace, model attempt, pressure test, inheritance structure, or boundary correction is required to make the stated purpose real?

A held implementation question is not the same as a held purpose question. Do not promote unresolved means into an unresolved source-of-intent fork.

Before naming operator-required input, distinguish:

- source-of-intent premises already supplied
- unresolved architectural means
- sequencing choices among valid routes
- operator-side positioning choices
- evidence-depth assessments

The operator should be asked to decide only the latter categories when the durable sources do not already answer them. Where the premise is already supplied and the means are unresolved, the method should force an architecture attempt against the premise.

### Source-of-intent nudge

At local plateaus, after meaningful absorptions, or when the next move is unclear but the durable purpose may already be sufficient, ask the advisor surface what additional operator source of intent or direction is needed to continue developing the project toward its stated purpose.

The nudge is not the same as asking "what next?" It is a boundary-classification pass. The advisor should distinguish whether the project needs new source intent, a sequencing choice, a bounded architecture attempt, repo-local absorption or routing, external synthesis, or a fresh-context reset.

A good nudge can return "no new purpose-level source-of-intent is needed." That is a successful result. It means the durable sources already contain the premise, and the next move should be derived from the current architecture rather than routed back to the operator as a new decision.

A good nudge can also return a stop signal: the current closure is a real pause point and the next move should not auto-chain. That is also a successful result. It should route to absorption, external synthesis, or fresh-context critique depending on whether the current durable state merely needs sequencing, needs synthesis from current context, or needs independent reconstruction from repo plus grounding note.

This nudge operationalizes the source-of-intent guard. It reduces false stops, where the system asks for operator input even though the intent is already supplied, and false autonomy, where the system continues without noticing that a genuine source-of-intent premise is missing or changed.

The nudge is a lighter-weight control loop than the fresh-context critique cycle. Use it before invoking fresh external critique when the question is local sequencing, absorption, routing, or next-pressure choice. Escalate to fresh-context critique when the nudge surfaces drift, stale durable context, unresolved purpose, or a need for independent reconstruction from repo plus grounding note.

The nudge currently has one live/default reusable prompt and two non-default routing instruments:

- [`prompts/repo-next-source-of-intent-nudge-minimal-prompt.md`](../prompts/repo-next-source-of-intent-nudge-minimal-prompt.md) — live/default lightweight single-question nudge anchored against the grounding note
- [`prompts/repo-next-source-of-intent-nudge-structured-prompt.md`](../prompts/repo-next-source-of-intent-nudge-structured-prompt.md) — non-default structured seven-outcome boundary-classification instrument
- [`prompts/repo-next-source-of-intent-nudge-externality-decision-prompt.md`](../prompts/repo-next-source-of-intent-nudge-externality-decision-prompt.md) — non-default externality-decision instrument for serious pause / routing decisions

Operationally, the minimal nudge is the default cycle prompt. Structured nudge variants are heavier reset / routing instruments, not regular-cycle prompts. Fresh-context critique remains a distinct anti-drift mechanism: the nudge can nominate it, but ASK authorizes it. The critique cycle should not be used merely as a next-step finder when the nudge layer can classify the boundary.

### Fresh-context critique cycle

At larger thresholds where the project's structure, posture, or direction needs re-examination beyond what a source-of-intent nudge can classify, start fresh advisor threads and give each only the durable context — the repo and the grounding note. Do not give them the working thread's accumulated explanations unless the task is to fold a prior critique. The load-bearing property is **context reset**: the critic is denied working-thread momentum and forced to reconstruct the project from durable truth. That reconstruction is what surfaces drift, ceremony, overclaimed architecture, stale navigation, weak naming, missing proof, or mismatched source-of-truth boundaries.

The cycle has three moves, each assigned to a distinct surface:

1. **Independent critique** — each critic thread reads durable truth and produces high-level concerns without seeing the other critique. Same prompt, same inputs, no shared thread momentum.
2. **Advisor-role synthesis** — a separate thread in the advisor surface folds both critiques into one analysis and produces an advisory plan, from outside execution momentum. The role is what matters; the model occupying it does not need to differ from the critique threads. The structural value is exteriority to the threads that produced the critiques.
3. **Bounded absorption** — the execution surface verifies repo state fresh, scopes the advisory plan into implementation work, and stops at exact scoped diff before any commit. Only corrections that survive synthesis and operator approval become repo work, grounding-note updates, or held threads.

This pattern composes both adversarial collaboration and adversarial iteration: the independent critiques create multi-mind opposition in one moment (collaboration); the synthesis and absorption metabolize that opposition into the next cross-time swing of the project (iteration). Adversarial iteration uses adversarial collaboration as a pressure mechanism at the structural-review altitude.

This is distinct from Stage 2 PR review. Stage 2 is targeted advisor review of a pushed branch before merge, scoped to the change at hand. The fresh-context critique cycle is broader: repo- or phase-level critique of accumulated system state at structural-posture moments. Different cadences, different surfaces.

The cycle is not a standing ceremony. It is warranted at thresholds — after a major plateau, when proof-chain gravity has accumulated, when naming or tier ownership has become unstable, or when the project's artifacts feel more coherent locally than globally. Routinizing the cycle would re-introduce the ceremony class the method is calibrated against.

The cycle earns its keep not only by producing better critiques, but by identifying when the current pressure surface has saturated. A successful cycle may end by naming that the thread should stop, that the project needs exterior digestion, or that new operator intent is required before further work would be meaningful. Plateau detection is itself a successful outcome of the cycle, not a failure to produce one.

A third failure mode appears when the cycle works too well: correct moves chained too quickly become their own drift vector. The remedy is the self-diagnostic plateau signal — stop, preserve what landed, and re-enter through a fresh-context pass only when new intent or new pressure is available. The remedy is not more procedure; more procedure is the failure mode this guards against.

The cycle's reusable prompts live in [`prompts/repo-critique-initial-prompt.md`](../prompts/repo-critique-initial-prompt.md), [`prompts/repo-critique-synthesis-prompt.md`](../prompts/repo-critique-synthesis-prompt.md), and [`prompts/repo-critique-execution-prompt.md`](../prompts/repo-critique-execution-prompt.md). The work happens in the durable backbone (repo + grounding note) and in the critics' independent reads. The operator does not direct what any critic should find; the artifacts speak. When the durable backbone is honest enough to serve as ground truth, the critique can be open-ended without losing focus.

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

Repo-local prose (this doc, `AGENTS.md`, project documentation) stays in systemic / architectural voice. ASK-positioning voice belongs in operator-side grounding notes and external writing. The full articulation of which vocabulary belongs where lives operator-side; this document references the principle structurally without carrying its content.

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

The second swing moved back toward abstraction through the IA layered-content redirection: worked-example mode sketches, cross-mode synthesis, and later architecture attempts that pressure layered references, constraints, discretion, and inheritance. Later swings may return to demonstration or operational proof. The method cares about the pattern, not the worked example's current phase state: abstraction and execution keep pressuring each other; the asymptote does not arrive.

The method is not separate from this history; it is what makes the history coherent.

## Self-Superseding Clause

This document is a transitional bridge. It should be superseded by:

- its own graduation to a separate repo when accumulation earns the move
- subsequent articulations of the method that earn deeper coverage of any single element above
- whatever later synthesis absorbs the methodology layer alongside the project's own evolution

Additional methodology artifacts should not accumulate in this repo by default; if the method layer needs more than this bridge document, that is evidence for a separate methodology repo.

The articulation is not finished. Each method element above could earn its own deeper treatment. Some elements may dissolve as later work shows they were instances of more general principles; others may earn first-class status as their own articulated patterns.

## Anchor Documents

### Article cluster (the methodology articulated externally)

- [*Beyond Vibe Coding: Constraining LLMs*](https://atomicspacekitten.substack.com/p/beyond-vibe-coding-constraining-llms) — the prior argument for constrained LLMs and explicit rules; substrate for the discipline this method runs on
- [*From Normative Structure to Execution Proof*](https://atomicspacekitten.substack.com/p/from-normative-structure-to-execution) — the swing toward implementation; "architecture should not rush to implementation, but it should eventually submit itself to it"
- [*Lessons from the First Prototype Phase*](https://atomicspacekitten.substack.com/p/lessons-from-the-first-prototype) — the structural retrospective; ~50x ceremony reduction; calibrated compensations for what single-node collapses relative to split-execution
- [*Adversarial Collaboration*](https://atomicspacekitten.substack.com/p/adversarial-collaboration) — the within-session multi-mind layer; complement to this document at the execution-protocol altitude
- [*From Execution Proof Back to Normative Structure*](https://atomicspacekitten.substack.com/p/from-execution-proof-back-to-normative) — the swing back to abstraction; introduces *adversarial iteration* alongside adversarial collaboration
- [*Method // Designing Systems That Build Systems*](https://atomicspacekitten.substack.com/p/method-designing-systems-that-build) — the external articulation of this document; names the category the method targets (system-building systems) and the productive Russellian shape of the method's self-membership
- [*Machine Builds Machine*](https://atomicspacekitten.substack.com/p/machine-builds-machine) — the recursive limit of AI-native work; the plateau signal as a two-part discipline (when to ask for new operator intent + when not to ask); Russell + Hegel as bracketing anchors
- [*The Nudge Layer*](https://atomicspacekitten.substack.com/p/the-nudge-layer) — the small control layer between normal execution and fresh-context critique; a boundary-classification pass that simulates the external-intent boundary check; reduces false stops and false autonomy; the stack-as-intelligence frame applied at workflow scale

### Meta repo and project anchors

- [`AGENTS.md`](../AGENTS.md) — execution-protocol layer for this meta repo; carries the per-PR cadence rule
- [`control-surface.md`](../control-surface.md) — legacy Model-A external control-surface artifact
- [`docs/architecture.md`](architecture.md) — the meta repo's role-model architecture (refresh held as separate question; may eventually absorb collaboration-vs-iteration distinction)
- `apexSolarKiss/asset-pipeline-ASK` — the worked example the method is currently pressure-tested against
- `apexSolarKiss/mazeASK` — separate worked example; still on legacy Model A operating model
