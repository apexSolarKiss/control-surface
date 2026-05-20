# control-surface

![control-surface banner](control-surface-banner.png)

Reusable control-surface workflow assets for ASK projects.

**Current default:** single-node Claude Code as both control surface and executor.
**Legacy:** Model A split execution is retained only for projects that explicitly need it.

This repo contains both the live operating files for `control-surface` itself and reusable workflow artifacts for downstream ASK projects, including the upstream instantiation phase before a target repo exists.

## Start Here // Instantiate a New ASK Project

To start a new ASK project from this meta repo, beginning from zero:

1. Create a new GitHub repo for the target ASK project.

   Repo pattern:

   ```text
   apexSolarKiss/<project-name>
   ```

   Example:

   ```text
   apexSolarKiss/new-working-example-ASK
   ```

2. Clone the new repo to the local ASK workspace.
3. Create the repo-external project folder beside the repo:

   ```text
   <project-name>-EXTERNAL/
     scratch/
     sources of intent/
   ```

4. Instantiate the grounding note from [`templates/grounding-note.template.md`](templates/grounding-note.template.md) into the external folder:

   ```text
   <project-name>-EXTERNAL/sources of intent/<project-name>_grounding-note_v1.md
   <project-name>-EXTERNAL/sources of intent/<project-name>_grounding-note.md
   ```

   The canonical unversioned mirror should equal v1.

5. Copy and adapt the repo-local starter files into the new repo:

   ```text
   templates/AGENTS.template.md       → AGENTS.md
   templates/architecture.template.md → docs/architecture.md
   templates/CLAUDE.template.md       → CLAUDE.md
   ```

   For a new worked example, treat `docs/architecture.md` as default rather than optional.

6. Create a minimal `README.md` for the new repo if one does not already exist.
7. Use [`prompts/claude-code-initial-prompt.md`](prompts/claude-code-initial-prompt.md) to attach Claude Code to the new repo and begin bootstrap.
8. (Optional) When an external advisor surface is used, adapt [`templates/advisor-initial-prompt.template.md`](templates/advisor-initial-prompt.template.md) into an operator-side advisor-startup prompt, typically alongside the grounding note in `<project-name>-EXTERNAL/sources of intent/`.
9. (Optional) When the project will use the advisor / nudge / critique surfaces, adapt the meta-repo's reusable nudge and critique prompts into project-flavored operator-side copies in `<project-name>-EXTERNAL/sources of intent/`:

   ```text
   prompts/repo-nudge-prompt.md                                            → <project-name>_repo-nudge-prompt.md                          (default)
   prompts/repo-next-source-of-intent-nudge-structured-prompt.md           → <project-name>_repo-nudge-structured-prompt.md               (non-default structured)
   prompts/repo-next-source-of-intent-nudge-externality-decision-prompt.md  → <project-name>_repo-nudge-externality-decision-prompt.md     (non-default externality-decision)
   prompts/repo-critique-initial-prompt.md                                 → <project-name>_repo-critique-initial-prompt.md               (default)
   prompts/repo-critique-initial-structured-prompt.md                      → <project-name>_repo-critique-initial-structured-prompt.md    (non-default structured)
   prompts/repo-critique-synthesis-prompt.md                               → <project-name>_repo-critique-synthesis-prompt.md             (default)
   prompts/repo-critique-synthesis-structured-prompt.md                    → <project-name>_repo-critique-synthesis-structured-prompt.md  (non-default structured)
   prompts/repo-critique-execution-prompt.md                               → <project-name>_repo-critique-execution-prompt.md             (default)
   prompts/repo-critique-execution-structured-prompt.md                    → <project-name>_repo-critique-execution-structured-prompt.md  (non-default structured)
   ```

   The meta-repo prompts remain canonical reusable sources; the operator-side copies are project-flavored adaptations so the advisor and control surfaces can operate without re-deriving prompt language each time. Not every project needs all nine immediately — adapt only the ones the project will actually use.

10. Once bootstrap begins, the new repo's `AGENTS.md` governs execution.

Default operating model: single-node Claude Code as both control surface and executor. Legacy Model A prompts are retained only for projects that explicitly need that older split.

For deeper context on the three phases (Instantiation → Bootstrap → Operational), see [`docs/project-instantiation-workflow.md`](docs/project-instantiation-workflow.md).

## Operating Model

The active operating model for new ASK projects is single-node: **Claude Code as both control surface and executor**. An advisor in chat-based form — typically GPT or Claude — remains available outside the execution thread.

An earlier split-execution model — ChatGPT as prompt compiler, Codex as executor, Claude Code as optional advisor — shaped this repo's design and is retained as legacy reference. It is referred to historically as **Model A**. The Model-A-specific external orchestration artifact ([`control-surface.md`](control-surface.md)) and Model-A-only prompts remain in the repo as legacy.

`apexSolarKiss/mazeASK` is still operated on Model A and is the working example for any project that still needs it. New ASK projects should default to single-node.

The workflow rules live in repo-local `AGENTS.md` files and are written agent-agnostically — they apply to whoever is executing.

Three live working examples anchor the family:

- `apexSolarKiss/asset-pipeline-ASK` — mature single-node working example and primary pressure surface from which the meta repo's rules are discovered, and source of upstream workflow-rule evolution. Operated end-to-end on Claude Code as control surface and executor; has produced the most advanced live `AGENTS.md` in the family. Template changes absorb only the portions that generalize beyond that repo's domain.
- `apexSolarKiss/urban-observatory` — second single-node working example. Newer project, currently in early bootstrap and prototype-planning phase. Pressures the meta repo at the source-of-intent recovery, post-bootstrap grounding-note freshness, and architecture-uncertain instantiation surfaces.
- `apexSolarKiss/mazeASK` — Model A working example. Operated on the ChatGPT/Codex split; the original concrete instance the boundary model was sketched against. Still active for that project.

## Source-of-Truth Split

ASK project work uses three durable sources of truth plus operator-side ephemeral memory:

- **Repo** = project state (artifacts, decisions, current navigation)
- **[`AGENTS.md`](AGENTS.md)** (in-repo) = workflow rules, agent-agnostic, applies to whoever executes
- **Grounding note** (external) = repo-external context: intent, audience, philosophy, foundational premises, durable loose threads
- **Per-conversation memory** (operator-side: Claude Code's MEMORY.md, ChatGPT thread history, task lists) = ephemeral session state, does not flow into the durable sources

### Aging-Rate Principle

The split is not just separation of concerns. It is separation by *aging rate*:

- A doc that *tracks state* ages fast and must be refreshed often.
- A doc that *points to state* ages slowly and stays useful across many sessions.
- A rules doc that contains rules only ages slowly.
- A context doc that contains context only ages slowly.
- A doc that mixes rules, context, and state ages at the rate of its fastest-aging contents.

This is the load-bearing rationale for the source-of-truth split. Each source is sized to a single aging rate.

## Repo Layout

### Live operating files for this repo

- [`AGENTS.md`](AGENTS.md) — repo-local workflow rules that govern execution inside this repo
- [`CLAUDE.md`](CLAUDE.md) — pointer to `AGENTS.md` for Claude Code operators
- [`docs/architecture.md`](docs/architecture.md) — meta architecture of this repo and the role model behind it

### Methodology docs

- [`docs/method.md`](docs/method.md) — methodology layer; articulation of the method for designing systems that build systems; transitional bridge that may graduate to its own repo when accumulation earns it

### Workflow docs

- [`docs/project-instantiation-workflow.md`](docs/project-instantiation-workflow.md) — agent-agnostic workflow doc for the pre-repo instantiation phase before a target ASK repo exists

### Reusable templates for downstream ASK repos

- [`templates/AGENTS.template.md`](templates/AGENTS.template.md) — agent-agnostic starter for repo-local execution rules; derived from the shared workflow core of asset-pipeline-ASK's live AGENTS.md (project-specific architecture rules in that repo are not absorbed by default)
- [`templates/grounding-note.template.md`](templates/grounding-note.template.md) — starter for the external grounding note that travels with each ASK project
- [`templates/architecture.template.md`](templates/architecture.template.md) — starter for a downstream repo's architecture doc
- [`templates/CLAUDE.template.md`](templates/CLAUDE.template.md) — optional Claude Code pointer file for downstream single-node repos
- [`templates/advisor-initial-prompt.template.md`](templates/advisor-initial-prompt.template.md) — optional starter for attaching an external advisor surface (GPT or Claude in chat form) to a downstream repo; the project-specific instantiation typically lives operator-side alongside the grounding note
- [`templates/overlays/architecture-uncertain-rules.template.md`](templates/overlays/architecture-uncertain-rules.template.md) — optional opt-in overlay for downstream projects with active architecture or ontology uncertainty; adds rules calibrated for projects whose work is to discover structural categories (architecture-before-prototype, prototype-as-pressure-surface, attempt-model-before-plan, self-evident-premise stop, ceremony budget, proof-chain gravity well guard, bootstrap doc-alignment check) on top of the base template; not used by projects whose task surface is known

Templates are copyable starters. They are not live for this repo unless explicitly adopted somewhere else.

### Prompts

- [`prompts/project-instantiation-initial-prompt.md`](prompts/project-instantiation-initial-prompt.md) — agent-agnostic startup prompt for the pre-repo instantiation phase
- [`prompts/claude-code-initial-prompt.md`](prompts/claude-code-initial-prompt.md) — session-start prompt for attaching Claude Code to an existing single-node project repo
- [`prompts/repo-critique-initial-prompt.md`](prompts/repo-critique-initial-prompt.md) — open-ended structural critique against repo + grounding note (initial pass of the fresh-context critique cycle)
- [`prompts/repo-critique-synthesis-prompt.md`](prompts/repo-critique-synthesis-prompt.md) — advisor-role synthesis of two independent critiques into an advisory plan (synthesis pass)
- [`prompts/repo-critique-execution-prompt.md`](prompts/repo-critique-execution-prompt.md) — hand the advisory plan back to the execution surface for scoped implementation (execution pass)
- [`prompts/repo-nudge-prompt.md`](prompts/repo-nudge-prompt.md) — default nudge prompt; lightweight boundary nudge at local plateaus / absorptions / unclear next moves; single open-ended question anchored against the grounding note
- [`prompts/repo-next-source-of-intent-nudge-structured-prompt.md`](prompts/repo-next-source-of-intent-nudge-structured-prompt.md) — non-default seven-outcome boundary-classification pass; not the default prompt
- [`prompts/repo-next-source-of-intent-nudge-externality-decision-prompt.md`](prompts/repo-next-source-of-intent-nudge-externality-decision-prompt.md) — non-default externality-decision instrument for deciding whether the pause needs external synthesis, fresh-context critique, new operator intent, or simultaneous operator + fresh critique; not the default prompt

### Examples

- [`examples/asset-pipeline-ASK/notes.md`](examples/asset-pipeline-ASK/notes.md) — single-node working example (mature pressure surface)
- [`examples/urban-observatory/notes.md`](examples/urban-observatory/notes.md) — single-node working example (newer; instantiation / source-of-intent recovery pressure surface)
- [`examples/mazeASK/notes.md`](examples/mazeASK/notes.md) — Model A working example (still active for that project)

### Legacy docs

These were active when the canonical operating model was ASK→ChatGPT→Codex with Claude Code as advisory. They are retained for reference and for `apexSolarKiss/mazeASK`, which still runs on Model A.

- [`control-surface.md`](control-surface.md) — Model-A-specific external control-surface artifact
- [`docs/workflow-boundary.md`](docs/workflow-boundary.md) — earlier boundary categorization, supplanted by [`AGENTS.md`](AGENTS.md)'s Source-of-Truth Boundaries section
- [`prompts/control-surface-initial-prompt.md`](prompts/control-surface-initial-prompt.md) — Model-A ChatGPT-side initial prompt
- [`prompts/codex-initial-prompt.txt`](prompts/codex-initial-prompt.txt) — Model-A Codex-side initial prompt

Each legacy doc carries a deprecation header naming what supersedes it for current single-node work.

## Which File Do I Use?

| If you need to... | Use |
| --- | --- |
| define execution rules inside the current repo | [`AGENTS.md`](AGENTS.md) |
| understand this meta repo's own architecture | [`docs/architecture.md`](docs/architecture.md) |
| set up the workflow before the target repo exists | [`docs/project-instantiation-workflow.md`](docs/project-instantiation-workflow.md) and [`prompts/project-instantiation-initial-prompt.md`](prompts/project-instantiation-initial-prompt.md) |
| attach Claude Code to an existing single-node repo | [`prompts/claude-code-initial-prompt.md`](prompts/claude-code-initial-prompt.md) |
| attach an external advisor surface (GPT or Claude in chat form) to an existing repo | [`templates/advisor-initial-prompt.template.md`](templates/advisor-initial-prompt.template.md) |
| create repo-local starter docs for a downstream repo | [`templates/AGENTS.template.md`](templates/AGENTS.template.md), [`templates/grounding-note.template.md`](templates/grounding-note.template.md), [`templates/architecture.template.md`](templates/architecture.template.md), [`templates/CLAUDE.template.md`](templates/CLAUDE.template.md) |
| see how the structure mapped onto a real ASK project | [`examples/`](examples/) |
| understand the previous canonical Model-A operating doc | [`control-surface.md`](control-surface.md) (legacy) |

## Minimal Adaptation Checklist

For a new ASK project:

- Identify the project purpose, repo name, and initial structure.
- Default to the single-node operating model unless the project has a specific reason to run on legacy Model A.
- Copy [`templates/AGENTS.template.md`](templates/AGENTS.template.md) into the new repo as `AGENTS.md` and adapt project-specific defaults.
- Copy [`templates/grounding-note.template.md`](templates/grounding-note.template.md) into the external grounding-note location and fill in intent, audience, philosophy, foundational premises, and durable loose threads.
- Optionally copy [`templates/architecture.template.md`](templates/architecture.template.md) into the new repo as `docs/architecture.md`.
- Optionally copy [`templates/CLAUDE.template.md`](templates/CLAUDE.template.md) into the new repo as `CLAUDE.md` when using Claude Code.
- Optionally adopt [`templates/overlays/architecture-uncertain-rules.template.md`](templates/overlays/architecture-uncertain-rules.template.md) when the project profile is architecture-uncertain (ontology-first work, prototypes as pressure surfaces, deferred schema commitment, modeling-before-planning). Append after the base `AGENTS.md` rules; skip when the task surface is known and the work is execution against it.
- Identify protected paths, constraints, and required verification steps in the new repo's `AGENTS.md`.
- Use [`prompts/claude-code-initial-prompt.md`](prompts/claude-code-initial-prompt.md) to attach Claude Code after the repo exists.
- Optionally adapt [`templates/advisor-initial-prompt.template.md`](templates/advisor-initial-prompt.template.md) into an operator-side advisor-startup prompt when an external advisor surface is used.
- Optionally adapt the meta-repo's nudge prompts ([`prompts/repo-nudge-prompt.md`](prompts/repo-nudge-prompt.md), [`prompts/repo-next-source-of-intent-nudge-structured-prompt.md`](prompts/repo-next-source-of-intent-nudge-structured-prompt.md), [`prompts/repo-next-source-of-intent-nudge-externality-decision-prompt.md`](prompts/repo-next-source-of-intent-nudge-externality-decision-prompt.md)) and critique prompts ([`prompts/repo-critique-initial-prompt.md`](prompts/repo-critique-initial-prompt.md), [`prompts/repo-critique-initial-structured-prompt.md`](prompts/repo-critique-initial-structured-prompt.md), [`prompts/repo-critique-synthesis-prompt.md`](prompts/repo-critique-synthesis-prompt.md), [`prompts/repo-critique-synthesis-structured-prompt.md`](prompts/repo-critique-synthesis-structured-prompt.md), [`prompts/repo-critique-execution-prompt.md`](prompts/repo-critique-execution-prompt.md), [`prompts/repo-critique-execution-structured-prompt.md`](prompts/repo-critique-execution-structured-prompt.md)) into project-flavored operator-side copies in `<project-name>-EXTERNAL/sources of intent/` when those surfaces will be used.

## Background Reading

The control-surface design recorded in this repo is anchored to nine pieces of external writing:

- [*Beyond Vibe Coding: Constraining LLMs*](https://atomicspacekitten.substack.com/p/beyond-vibe-coding-constraining-llms) — the prior argument that reliable AI-native execution requires *constrained* LLMs, with explicit rules, explicit boundaries, explicit reasoning surfaces, and ready-to-send prompts that already encode the workflow rather than asking the human to reconstruct it on every turn. The original case for the structural friction that the legacy split-execution control surface (Model A) operationalized.
- [*Lessons from the First Prototype Phase*](https://atomicspacekitten.substack.com/p/lessons-from-the-first-prototype) — the structural retrospective that justifies the current state. Records the migration of structural friction into rules in the repo, the sunset of Model A, the ~50x ceremony reduction that single-node operation produces, and the reframe of the rules as calibrated compensations for what single-node collapses relative to the legacy split.
- [*Adversarial Collaboration*](https://atomicspacekitten.substack.com/p/adversarial-collaboration) — the next workflow piece, recording where dual-agent dialogue went after Model A retired. Once execution-layer friction had compressed into rules, the dual-agent surface relocated to the architectural layer — where the work hasn't yet compressed and may never compress that way. Names adversarial collaboration (Kahneman / Mellers) as the working term, with multi-agent debate and actor-critic as adjacent shapes of the same family. The pattern's tractability depends on the durable backbone of repo, grounding note, and `AGENTS.md` rules.
- [*From Execution Proof Back to Normative Structure*](https://atomicspacekitten.substack.com/p/from-execution-proof-back-to-normative) — the next workflow piece after *Adversarial Collaboration*. Names two related-but-distinct patterns: adversarial collaboration (multi-mind, one moment) and adversarial iteration (single-mind, across time / the swing methodology). Both are load-bearing in the working method.
- [*Method // Designing Systems That Build Systems*](https://atomicspacekitten.substack.com/p/method-designing-systems-that-build) — the next workflow piece after *From Execution Proof Back to Normative Structure*. Names the category the method targets: system-building systems, whose output is itself a system or governed family of systems. Distinguishes generation from composition (a system-building system from a system-of-systems) and articulates three recursive roles a project can occupy (articulated system / system-of-systems / system-building system). Observes that the method does not change shape across roles, and that the recursion forces the method to be a member of the category it defines — a productive Russellian shape rather than a destructive paradox.
- [*Machine Builds Machine*](https://atomicspacekitten.substack.com/p/machine-builds-machine) — the next workflow piece after *Method // Designing Systems That Build Systems*. Names the recursive limit of AI-native work: not model intelligence, but the source of intent. The recursive system can refine structure, detect plateau, and propose next pressure surfaces, but cannot originate the highest-level value function. Articulates the plateau signal as a two-part discipline — the system must know when to ask for new operator intent and when not to ask, because a gap between stated purpose and current evidence is not automatically a request for reauthorization. Russell and Hegel as bracketing anchors for the typed recursion that ascends rather than collapses.
- [*The Nudge Layer*](https://atomicspacekitten.substack.com/p/the-nudge-layer) — the next workflow piece after *Machine Builds Machine*. Names the small control layer that appeared between normal execution and the fresh-context critique cycle: a boundary-classification pass that asks whether the system has reached a real source-of-intent boundary or merely the next architectural move implied by intent already supplied. Articulates two opposite failure modes — false stops (asking the operator to reauthorize a premise already supplied) and false autonomy (chaining correct moves until they become drift) — and frames the nudge as a small simulation of the external-intent boundary check. Connects to Max Bennett's account of intelligence as a layered evolutionary accumulation: the system becomes smarter not because the model changes but because the stack adds a control layer that classifies when external intent is needed.
- [*The Drift Audit*](https://atomicspacekitten.substack.com/p/the-drift-audit) — the next workflow piece after *The Nudge Layer*. Names the methodological refinement that follows once the nudge layer takes over next-direction discovery: fresh-context critique can return to its proper role as anti-drift inspection — independent reconstruction of the project from durable truth, run to test whether the project's self-map has drifted from what the durable sources actually describe. Articulates the load-bearing asymmetry that anti-drift critique cannot be deterministically triggered from inside the system it inspects: the system can nominate a fresh critique, but the operator authorizes it. The audit earns its value from externality; milestones are admissible evidence, not triggers. Names the four-layer ladder (minimal nudge / structured nudge / externality-decision nudge / fresh-context critique), each with a distinct job and a distinct cost, with the calibration recorded so the instruments do not collapse into one another. Extends the stack-as-intelligence frame: the system becomes smarter not because any layer in it has more power, but because each layer has come to understand the size of its own job.
- [*From Conversation to Control Surface*](https://atomicspacekitten.substack.com/p/from-conversation-to-control-surface) — the next workflow piece after *The Drift Audit*. Stress-tests the method on a different moment: project inception from messy AI-mediated exploration, instantiated on `urban-observatory`. Names the load-bearing sequence — recovered intent → validated constraint → repo — and the discipline that keeps AI from authoring the source of intent it is supposed to serve. Source-of-intent recovery becomes architecture: reconciling overlapping conversation captures into a coherent source pack before any synthesis can begin; validation loops that prevent the model from immediately producing another polished frame; a grounding note that holds external context the public repo cannot carry. Connects to a prior piece on structural LLM reasoning failures: catastrophic forgetting, weak inhibitory control, weak cognitive flexibility, pattern completion, and dispersal of focus are reframed not as bugs but as the reported failure signature of the current paradigm — and `control-surface` is what designing around them looks like at workflow scale. The repo is not the first artifact; the first artifact is recovered intent, and the repo comes after.

Together they describe why the control-surface rules look the way they do, why the operating model evolved from split-execution to single-node, and where dual-agent dialogue still earns its keep above the rules.

## License

Copyright (c) 2026 Andrew S Klug // ASK

Licensed under the Apache License 2.0 // see [`LICENSE`](LICENSE)
