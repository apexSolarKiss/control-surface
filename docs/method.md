# Method // Bridge

This document is a bridge. `control-surface` readers find here a short explanation of where the methodology layer lives and what it carries. The substance of the method lives upstream in [`apexSolarKiss/method-ASK`](https://github.com/apexSolarKiss/method-ASK).

## What lives upstream

The methodology repo carries:

- the method itself — pre-architecture moves, execution disciplines, synthesis disciplines, cross-phase workflow shape, surface/voice discipline, adversarial iteration and collaboration
- relative externality and the rule/payload doctrine
- source-of-truth and aging-rate doctrine + cross-project lineage
- source-of-intent recovery, validation loop, and external-handoff classification (observation-level)
- worked-example explanations at method altitude
- the method topology
- the absorption discipline that governs when n=1 patterns earn promotion to method-level doctrine

The methodology repo's `docs/method.md` is the primary articulation. Standalone doctrine docs have split out as substrate accumulated — see *Where to read further* below.

## What stays in this repo

`apexSolarKiss/control-surface` remains the execution-protocol layer. It owns:

- [`AGENTS.md`](../AGENTS.md) — workflow rules for repo execution
- [`templates/`](../templates/) — downstream starter files (AGENTS, architecture, grounding note, advisor prompt, overlays)
- [`prompts/`](../prompts/) — instantiation prompt, nudge ladder, critique cycle
- [`examples/`](../examples/) — workflow-asset notes for each worked-example repo
- [`docs/architecture.md`](architecture.md) — this repo's role-model architecture
- [`docs/project-instantiation-workflow.md`](project-instantiation-workflow.md) — instantiation / bootstrap / operational phases
- the architecture-uncertain rules overlay ([`templates/overlays/architecture-uncertain-rules.template.md`](../templates/overlays/architecture-uncertain-rules.template.md))
- legacy Model A artifacts ([`control-surface.md`](../control-surface.md), legacy prompts)

## Why the split

The methodology layer and the execution-protocol layer have different aging rates and different audiences. Holding them in one repo would make the meta-repo legible at neither altitude. Keeping the method upstream lets `control-surface` stay tight as the execution-protocol meta repo while the method evolves at its own cadence.

## Where to read further

- [`apexSolarKiss/method-ASK/docs/method.md`](https://github.com/apexSolarKiss/method-ASK/blob/main/docs/method.md) — the method (current primary articulation)
- [`apexSolarKiss/method-ASK/docs/articles.md`](https://github.com/apexSolarKiss/method-ASK/blob/main/docs/articles.md) — canonical article-line index for the workflow / method series
- [`apexSolarKiss/method-ASK/docs/relative-externality.md`](https://github.com/apexSolarKiss/method-ASK/blob/main/docs/relative-externality.md) — relative externality and the rule/payload doctrine
- [`apexSolarKiss/method-ASK/docs/voice-surface-boundary.md`](https://github.com/apexSolarKiss/method-ASK/blob/main/docs/voice-surface-boundary.md) — voice/surface discipline across artifact tiers
- [`apexSolarKiss/method-ASK/docs/source-of-truth-and-aging-rate.md`](https://github.com/apexSolarKiss/method-ASK/blob/main/docs/source-of-truth-and-aging-rate.md) — source-of-truth split and aging-rate principle
- [`apexSolarKiss/method-ASK/docs/source-of-intent.md`](https://github.com/apexSolarKiss/method-ASK/blob/main/docs/source-of-intent.md) — source-of-intent recovery, validation loop, and external-handoff classification (observation-level)
- [`apexSolarKiss/method-ASK/docs/normative-apex.md`](https://github.com/apexSolarKiss/method-ASK/blob/main/docs/normative-apex.md) — structural source-of-intent / the normative apex
- [`apexSolarKiss/method-ASK/docs/governance.md`](https://github.com/apexSolarKiss/method-ASK/blob/main/docs/governance.md) — governance architecture (the apex/governance split)
- [`apexSolarKiss/method-ASK/docs/bounded-generativity.md`](https://github.com/apexSolarKiss/method-ASK/blob/main/docs/bounded-generativity.md) — bounded discretion + functional-judgment topology
- [`apexSolarKiss/method-ASK/docs/absorption-discipline.md`](https://github.com/apexSolarKiss/method-ASK/blob/main/docs/absorption-discipline.md) — when n=1 patterns earn promotion to method-level doctrine
- [`docs/architecture.md`](architecture.md) — this repo's execution-protocol role-model architecture

## Self-superseding clause

This bridge stays compact. If it grows, the upstream method repo is absorbing too little or this repo is absorbing too much.
