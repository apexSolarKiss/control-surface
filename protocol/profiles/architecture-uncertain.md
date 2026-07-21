# Profile — architecture-uncertain

**Opt-in.** Adopted only by a downstream project whose task surface is **architecture / ontology-uncertain** — work whose job is to discover structural categories, not to execute against a known task surface. The base shared core suffices for execution-against-a-known-surface projects; if these rules start to read as ceremony rather than discipline, the profile may have shifted away from architecture-uncertain — consider removing it rather than letting it calcify.

**Authoritative owner of the seven rule bodies.** This profile is the **owner** of the seven rule bodies below. `control-surface/templates/overlays/architecture-uncertain-rules.template.md` is the downstream-authoring **twin**: it carries these same seven bodies inside its overlay wrapper plus `When To Adopt` / `How To Adopt` scaffolding that is template-authoring apparatus (not part of this profile). Keep the two surfaces in sync — edit both together; `check.sh` compares the fenced bodies.

> **Not in this profile:** the `Default: Hold or Carry Through Per Adversarial-Collaboration Preconditions` rule is a self-conditional **shared-core** rule, not one of these seven. The **domain-authority review protocol** is separate, governed by `docs/domain-authority-review-protocol.md` and (when instantiated) `templates/domain-authority-review-profile.template.md`; it is **not** folded in here and does not block this profile.

---

<!-- BEGIN profile-body: architecture-uncertain -->
## Architecture-Before-Prototype

When the project is trying to define conceptual architecture or ontology, do not default to prototype probes, tool experiments, or repo evidence chains.

First identify:

- the architectural question
- the candidate model
- the scale of example needed to pressure-test it
- what uncertainty the prototype would resolve
- what the result would change about the architecture

Use prototypes to test architecture.

Do not let the prototype become the object of study instead of the pressure surface for studying the architecture.

If the architectural question is not clear, do not open a prototype chain.

## Prototype-as-Pressure-Surface

A prototype is a pressure surface, not the project center.

A prototype is justified when it exposes, tests, or falsifies a structural distinction in the architecture.

A prototype is not justified merely because a tool behavior is available to test.

Before proposing prototype work, state:

```text
What architectural question does this prototype pressure?
What distinction would become clearer?
What would we know after the prototype that we do not know now?
```

If the answer is only "whether the tool can do X," stop unless that tool capability is strategically load-bearing.

## Attempt-Model-Before-Plan

When the work is architectural, prefer attempting a rough model on a concrete example before creating a broad planning artifact.

Do not produce a planning document that only enumerates layers, questions, or future artifacts without attempting the model.

A useful architecture artifact should do at least one of these:

- apply a candidate model to a concrete example
- show inheritance / override behavior
- reveal where a model breaks
- compare how one structure behaves across modes or contexts
- surface real architecture questions from collision with an example

Permission to be wrong is part of the method.

A sketch can be more valuable than a comprehensive plan.

## Self-Evident-Premise Stop

If a chain of work is mainly proving a premise the project already treats as foundational, stop.

Consult the grounding note for current foundational premises.

Ask whether the finding is worth documenting, or whether the project should move to the next structural layer.

Do not keep proving accepted premises unless the new work materially refines the architecture.

## Ceremony Budget

Before opening an options / decision / probe / findings chain, state what architectural uncertainty the chain resolves.

If the answer is only "whether a tool can do X," do not proceed unless that tool capability itself is strategically load-bearing.

Avoid artifact chains that document local friction without advancing the architecture.

Repo artifacts are justified when they preserve:

- a durable structural decision
- a schema-relevant finding
- a proof outcome that changes the model
- a reopen trigger being acted on
- live prototype state that needs repo-visible explanation

Otherwise, continue in-thread or stop.

## Proof-Chain Gravity Well Guard

No new conceptual artifact unless it changes the model, schema pressure, carrier boundary, or governance seam.

Findings that do not change those things belong in concise execution records or in-thread, not in new conceptual artifacts.

This guards against the failure mode where each operational discrepancy or process amendment generates a durable artifact whether or not it changes anything load-bearing. The artifact economy should stay proportional to actual architectural movement.

## Bootstrap Doc-Alignment Check

After a validated direction lands at one layer (typically the grounding note or a new repo-local doc), check whether earlier repo-local docs still carry pre-validation framing.

If they do, run a scoped doc-alignment pass:

- align repo-local docs with the validated direction
- preserve working-hypothesis posture where final commitment is explicitly deferred
- do not change strategy
- do not create schemas, data files, notebooks, or reports
- do not expand scope

The failure mode: validated direction lands at the grounding-note layer or in a new doc, and the repo-local docs that predate the validation continue to carry open or unresolved framing inconsistent with the rest of the repo. The catch-up pass is its own scoped unit of work, not a side-effect of the validation itself.
<!-- END profile-body: architecture-uncertain -->

---

## Refresh cadence

Same cadence as the rest of `AGENTS.md`: refresh only when a workflow rule is added, removed, or materially revised. If the rules read as ceremony rather than as live guards, the profile may no longer match the project — consider removing it rather than letting unused rules calcify into doctrine.
