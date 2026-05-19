# Architecture-Uncertain Rules Overlay

Use this as an opt-in overlay for downstream ASK projects with active architecture or ontology uncertainty.

The base [`templates/AGENTS.template.md`](../AGENTS.template.md) carries the shared workflow discipline that applies to all ASK projects. This overlay layers additional rules that are calibrated for projects whose work is to discover structural categories, not merely execute known tasks.

## When To Adopt

Adopt this overlay when the project profile matches several of the following:

- **Ontology-first work** — the project's durable deliverable is a structured definition layer (categories, relationships, inheritance) ahead of any single implementation.
- **Prototype as pressure surface** — prototypes are built to test architectural distinctions, not as the project's primary output.
- **Refusal of premature schema doctrine** — final schema commitment is explicitly deferred while structural categories are still being discovered.
- **Need to model before planning** — planning artifacts derive value from prior architectural attempts, not from layer enumeration alone.
- **Ceremony-budget pressure** — operational friction tends to produce artifact chains that do not advance the architecture.

Do not adopt this overlay when:

- the project's task surface is known and the work is execution against it
- the architecture is settled and the project is in operational / production mode
- the additional rules would create ceremony without addressing a real failure mode

The base template suffices for projects whose work is execution against a known task surface. The overlay is opt-in.

## How To Adopt

Copy the rules below into the downstream project's `AGENTS.md` after the rules from `AGENTS.template.md`. The overlay does not modify the base template's rules — it adds to them.

When adopted, note in the downstream `AGENTS.md` that the architecture-uncertain overlay is in effect, so the source is legible to future readers.

---

# Architecture-Uncertain Rules

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

---

## Refresh Cadence

These rules belong to the same refresh cadence as the rest of the downstream project's `AGENTS.md`. Refresh only when a workflow rule is added, removed, or materially revised.

If the project starts to find these rules ceremony rather than discipline, that is a signal the project profile may have shifted away from architecture-uncertain. Consider removing the overlay rather than letting unused rules calcify into doctrine.
