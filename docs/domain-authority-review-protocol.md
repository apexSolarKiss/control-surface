# Domain-authority review protocol

How a project runs a review by a **domain authority** — a person or role that supplies or validates judgment within a named domain, sitting in a role distinct from the project's architect/operator. This is the reviewer-neutral operational kernel. It governs **whose judgment a review carries, what project stage that judgment may affect, how returned claims are classified, and how authority reaches execution.** A project instantiates it through `templates/domain-authority-review-profile.template.md`, and only when it actually has such a role (see [`docs/project-instantiation-workflow.md`](project-instantiation-workflow.md)).

**Method-altitude articulation.** The principle this operationalizes lives upstream in [method-ASK](https://github.com/apexSolarKiss/method-ASK): domain authority as a bounded instance of delegated discretion (`docs/governance.md`), and the stage-aware classification of domain-authority handoffs (`docs/source-of-intent.md`, §External / domain-authority handoff classification). This doc does not restate the principle; it operationalizes it. It is a sibling to [`docs/critique-protocol.md`](critique-protocol.md), which governs a different review class (fresh-context critique instantiation).

## Not SMGI

The seed-mediated generated interface ([method-ASK](https://github.com/apexSolarKiss/method-ASK) `docs/seed-mediated-generated-interface.md`) already generalizes the **delivery substrate** — how a review interface reaches and behaves inside a runtime: carrier and runtime-context classification, loading path and operator distance, access-path survival, human/AI/operator surface separation, and the rule that a generated thread cannot self-authorize. This protocol is a sibling to it, not part of it:

```text
SMGI                     governs seed, loading path, runtime behavior, access-path survival
domain-authority review  governs authority, stage, decision aperture, classification, relay, closure
```

A project that runs a domain-authority review over a seed-mediated surface uses both: SMGI for delivery, this protocol for judgment routing.

## Three independent axes

The most common failure is collapsing these into one. They are declared separately, and none implies another:

```text
review mode  ≠  return mode  ≠  authority
```

- **Review mode** — how the review is conducted: lightweight gut-check, bounded decision, guided decision interview, guided artifact review. Extensible examples, not a closed taxonomy.
- **Return mode** — how the result travels: direct operator relay, structured handoff, or provisional (nothing operative travels yet).
- **Authority** — the binding scope of the judgment: advisory, delegated-binding within a named scope, or apex-level where the same person also owns the project intent.

Do not bind one review mode to one mandatory return mode, and do not infer authority from either.

## Invariants

1. **Authority declaration.** Every review surface names, up front, whose judgment it carries and that judgment's binding scope. Scope is stated, not inferred from expertise.
2. **Expertise is not project authority.** Domain expertise confers no project-stage advancement, implementation architecture, execution, publication, or closure authority; those rights are named explicitly or they are absent.
3. **Stage contract.** Every review declares the project's current lifecycle / method stage, the decisions open in this review, and the commitments explicitly held out of scope.
4. **No implicit stage advancement.** A review cannot advance project maturity by implication. Out-of-stage material is preserved as future roadmap, advisor scratch, or premature implementation architecture — neither adopted as current direction nor silently discarded — until the architect/operator promotes it.
5. **Claim-level classification.** Returned material is classified claim by claim against the method's existing category distinctions ([method-ASK](https://github.com/apexSolarKiss/method-ASK) `docs/source-of-intent.md`, §Category distinctions), not adopted or rejected whole-artifact. One handoff may carry a binding domain fact and a premature implementation proposal at once.
6. **Handoff-necessity gate.** Before a review produces a return handoff, determine whether a handoff is needed at all. A settled, already-relayed decision is not sent back to a source thread to be repackaged (method-ASK `docs/source-of-intent.md`, §Handoff necessity). A complete relay is the instruction.
7. **Direct-relay sufficiency.** When the human decision is explicit, the target is fixed, and the authorized operator forwards the decision with its qualifications and scope with no material meaning lost, the route is direct:

   ```text
   human judgment >> authorized relay >> execution
   ```

8. **Exact-wording preservation.** Where a decision's exact wording is load-bearing (a ratified formulation, a named constraint), it travels verbatim; the relay does not paraphrase it into approximation.
9. **Advisor / generated-thread non-authorization.** A review surface — an advisor connector or a generated thread — elicits and preserves judgment; it cannot supply the answer or self-authorize. Capability is not authorization; every write goes through the executor on the operator's relay (`AGENTS.md` carries the git-workflow relay; [`docs/critique-protocol.md`](critique-protocol.md) carries the advisor read-path discipline).
10. **Routing.** Every review names its return recipient, its execution target, and its closure / recourse route.

## The review profile

A project instantiates `templates/domain-authority-review-profile.template.md`. The profile splits by aging rate:

- **Standing (slow-aging) fields** — project apex / decision owner, architect-operator, the domain authority and its named domain, authority scope, internal / external relationship, confidentiality / disclosure posture, authorized evidence access, return recipient, execution target, closure / recourse route, and any local package / marker conventions. These change rarely.
- **Per-review (fast-aging) stage contract** — the current lifecycle / method stage, the fixed target or question, the decisions open in this review, the commitments held or out of scope, the review mode, the expected return mode, exact-wording requirements, and what evidence is supplied versus unavailable. These are set per review request.

The profile is a **minimum, explicitly extensible contract.** Add the fields a project needs; do not freeze the schema. Held until a second implemented project/profile instance pressure-tests the contract: a closed field taxonomy, a universal package shape, universal artifact classes, and any reviewer-role-design formula (for example a fixed "system owns completeness / expert owns judgment" split) or input-firmness taxonomy not already grounded in method doctrine.

## Related

- [method-ASK](https://github.com/apexSolarKiss/method-ASK) `docs/governance.md` (delegated discretion) and `docs/source-of-intent.md` (§External / domain-authority handoff classification · §Handoff necessity · §Category distinctions) — the principle this operationalizes.
- method-ASK `docs/seed-mediated-generated-interface.md` — the delivery substrate (distinct; see §Not SMGI).
- [`docs/critique-protocol.md`](critique-protocol.md) — fresh-context critique instantiation (a different review class).
- `templates/domain-authority-review-profile.template.md` — the per-project instantiation.
- [`docs/project-instantiation-workflow.md`](project-instantiation-workflow.md) — where a project conditionally adopts this protocol.
