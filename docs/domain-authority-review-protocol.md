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
- **Return mode** — how the result travels: direct operator relay, structured handoff, or provisional (nothing operative travels yet). Return mode is semantic. Where it requires an artifact to be physically written somewhere, that write is a separately declared grant (§Return transport), never an implication of the mode.
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
11. **Return transport is a declared grant, not an implication.** A return mode describes how judgment travels; it never authorizes a write. Where a return produces a physical artifact, the provider, the one exact destination, the confirmation trigger, the collision behavior, and the receipt are declared before first use — and the grant is create-only and transport-only (§Return transport).

## Return transport

Naming a return recipient (invariant 10) says who the result is *for*. It does not say who may write what, where. When a return mode requires a physical artifact — a file created on a surface the reviewer or their tooling can reach — that write is a **separate, explicitly declared grant**.

A return-transport grant is bounded to create-only, and names before first use:

```text
provider              the connector, service, or surface performing the write
destination           one exact inbox path — not a folder tree, not a search result
admissible payload    the confirmed return body, and nothing else
confirmation trigger  what must be true before the write is permitted
collision behavior    target exists >> stop and ask
receipt               path, byte size, and provider file ID where one exists
fallback              what happens when the provider is unavailable
```

Outside the grant, always:

```text
overwrite · update · rename · move · delete
create a folder · create a shared or public link
write anywhere but the exact destination
attach, strip, or alter a lifecycle marker after the write
report a failed write as saved
```

**The grant is transport only.** It confers no ingestion, absorption, adoption, implementation, publication, or closure authority. It does not soften invariant 9: a surface permitted to create a return artifact still cannot supply the judgment or self-authorize its content. A project that runs its returns by direct operator relay needs no grant at all — declaring `none` is the expected answer, not a gap.

**Two boundaries this section does not cross.**

- **Marker and queue lifecycle.** What a lifecycle marker means, when it attaches, how an item moves through and exits an intake queue, and what evidence proves ingestion are owned elsewhere ([method-ASK](https://github.com/apexSolarKiss/method-ASK) `docs/source-of-intent.md`; `AGENTS.md` §Inbound Handoff TBI Marker). This section owns only who may create which file, where. The two answer different questions and must not be merged into one rule.
- **Reviewer format and package shape.** A declared destination, a collision rule, and a receipt are *authorization* mechanics, and they are what this section adds. A closed field taxonomy, a universal package shape, and universal artifact classes remain **held** (§The review profile) until a second implemented instance earns them.

**Open.** Whether a standing profile may pre-authorize an entire *class* of returns, rather than requiring per-artifact approval of the recipient-facing substance, is unsettled. Until it is settled, a standing grant authorizes the **route**; it does not authorize the **substance** of any particular return.

## The review profile

A project instantiates `templates/domain-authority-review-profile.template.md`. The profile splits by aging rate:

- **Standing (slow-aging) fields** — project apex / decision owner, architect-operator, the domain authority and its named domain, authority scope, internal / external relationship, confidentiality / disclosure posture, authorized evidence access, return recipient, execution target, closure / recourse route, the return-transport grant or its explicit absence, and any local package / marker conventions. These change rarely.
- **Per-review (fast-aging) stage contract** — the current lifecycle / method stage, the fixed target or question, the decisions open in this review, the commitments held or out of scope, the review mode, the expected return mode, whether this return requires a transport write, exact-wording requirements, and what evidence is supplied versus unavailable. These are set per review request.

The profile is a **minimum, explicitly extensible contract.** Add the fields a project needs; do not freeze the schema. Held until a second implemented project/profile instance pressure-tests the contract: a closed field taxonomy, a universal package shape, universal artifact classes, and any reviewer-role-design formula (for example a fixed "system owns completeness / expert owns judgment" split) or input-firmness taxonomy not already grounded in method doctrine.

## Related

- [method-ASK](https://github.com/apexSolarKiss/method-ASK) `docs/governance.md` (delegated discretion) and `docs/source-of-intent.md` (§External / domain-authority handoff classification · §Handoff necessity · §Category distinctions) — the principle this operationalizes.
- method-ASK `docs/seed-mediated-generated-interface.md` — the delivery substrate (distinct; see §Not SMGI).
- [`docs/critique-protocol.md`](critique-protocol.md) — fresh-context critique instantiation (a different review class).
- `templates/domain-authority-review-profile.template.md` — the per-project instantiation.
- [`docs/project-instantiation-workflow.md`](project-instantiation-workflow.md) — where a project conditionally adopts this protocol.
