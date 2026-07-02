# control-surface

![control-surface banner](control-surface-banner.png)

Reusable control-surface workflow assets for ASK projects.

**Current default:** single-node Claude Code as both control surface and executor.
**Legacy:** Model A split execution is retained only for projects that explicitly need it.

This repo contains both the live operating files for `control-surface` itself and reusable workflow artifacts for downstream ASK projects, including the upstream instantiation phase before a target repo exists.

## Start Here // Instantiate a New ASK Project

To start a new ASK project from this protocol repo, beginning from zero:

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
     <project-name>_grounding-note.md   # canonical durable context (root)
     scratch/                            # _vN snapshots + iteration
     sources of intent/                  # inbound -TBI handoffs + received records
   ```

   Root is the default durable-context layer of an `*-EXTERNAL` surface; named semantic or structural layers (`scratch/`, `sources of intent/`) override it only where explicitly defined.

4. Instantiate the grounding note from [`templates/grounding-note.template.md`](templates/grounding-note.template.md). The canonical durable-context note lives at the `*-EXTERNAL` **root**; its versioned snapshots live in `scratch/`:

   ```text
   <project-name>-EXTERNAL/<project-name>_grounding-note.md          # canonical (root)
   <project-name>-EXTERNAL/scratch/<project-name>_grounding-note_v1.md
   ```

   The canonical unversioned mirror should equal v1, and both carry their version in the first H1 as `// v1`.

5. Copy and adapt the repo-local starter files into the new repo:

   ```text
   templates/AGENTS.template.md       → AGENTS.md
   templates/architecture.template.md → docs/architecture.md
   templates/CLAUDE.template.md       → CLAUDE.md
   ```

   For a new worked example, treat `docs/architecture.md` as default rather than optional.

6. Create a minimal `README.md` for the new repo if one does not already exist.
7. Use [`prompts/claude-code-initial-prompt.md`](prompts/claude-code-initial-prompt.md) to attach Claude Code to the new repo and begin bootstrap.
8. (Optional) When an external advisor surface is used:
   - Create the source index from [`templates/_INDEX-project.template.md`](templates/_INDEX-project.template.md) as `<project-name>-EXTERNAL/_INDEX-<project-name>.md` (or `_INDEX-<project-name>-<role>.md` per role), and **mount that index** as the advisor Project's **primary Source** — mount the map, not copies of the canonicals; the advisor fetches canonicals live from Dropbox by exact path.
   - Adapt [`templates/advisor-project-instructions.template.md`](templates/advisor-project-instructions.template.md) and install it **once into the advisor Project Instructions** — not pasted per thread (see [`docs/critique-protocol.md`](docs/critique-protocol.md)); the instructions point at the mounted index as the first read. The grounding note itself lives at the `-EXTERNAL` root.
9. (Optional) When the project will use the advisor / nudge / critique surfaces, adapt the protocol repo's reusable nudge and critique prompts into project-flavored operator-side copies in `<project-name>-EXTERNAL/sources of intent/`:

   ```text
   prompts/repo-nudge-prompt.md              → <project-name>_repo-nudge-prompt.md
   prompts/repo-critique-initial-prompt.md   → <project-name>_repo-critique-initial-prompt.md
   prompts/repo-critique-synthesis-prompt.md → <project-name>_repo-critique-synthesis-prompt.md
   prompts/repo-critique-execution-prompt.md → <project-name>_repo-critique-execution-prompt.md
   ```

   The protocol repo's prompts remain canonical reusable sources; the operator-side copies are project-flavored adaptations so the advisor and control surfaces can operate without re-deriving prompt language each time. Adapt only the prompts the project will actually use.

   System-wide ecology critique prompts live separately at the meta level only — they are not adapted into downstream-project operator-side copies:

   ```text
   prompts/ecology-critique-initial-prompt.md
   prompts/ecology-critique-synthesis-prompt.md
   prompts/ecology-critique-execution-prompt.md
   ```

   These are for system-wide critique across `control-surface`, `method-ASK`, `design-system-ASK`, and relevant downstream repos / grounding notes — not ordinary downstream-project critique.

10. Once bootstrap begins, the new repo's `AGENTS.md` governs execution.

Default operating model: single-node Claude Code as both control surface and executor. Legacy Model A prompts are retained only for projects that explicitly need that older split.

For deeper context on the three phases (Instantiation → Bootstrap → Operational), see [`docs/project-instantiation-workflow.md`](docs/project-instantiation-workflow.md).

## Operating Model

The active operating model for new ASK projects is single-node: **Claude Code as both control surface and executor**. An advisor in chat-based form — typically GPT or Claude — remains available outside the execution thread.

An earlier split-execution model — ChatGPT as prompt compiler, Codex as executor, Claude Code as optional advisor — shaped this repo's design and is retained as legacy reference. It is referred to historically as **Model A**. The Model-A-specific external orchestration artifact ([`control-surface.md`](control-surface.md)) and Model-A-only prompts remain in the repo as legacy.

`apexSolarKiss/mazeASK` is still operated on Model A and is the working example for any project that still needs it. New ASK projects should default to single-node.

The workflow rules live in repo-local `AGENTS.md` files and are written agent-agnostically — they apply to whoever is executing.

Three worked examples anchor the family:

- `apexSolarKiss/asset-pipeline-ASK` — mature single-node working example and primary pressure surface from which the protocol repo's rules are discovered, and source of upstream workflow-rule evolution. Operated end-to-end on Claude Code as control surface and executor; has produced the most advanced live `AGENTS.md` in the family. Template changes absorb only the portions that generalize beyond that repo's domain.
- `apexSolarKiss/urban-observatory` — second single-node working example. Newer project, currently in early bootstrap and prototype-planning phase. Pressures the protocol repo at the source-of-intent recovery, post-bootstrap grounding-note freshness, and architecture-uncertain instantiation surfaces.
- `apexSolarKiss/mazeASK` — retained legacy Model A reference (project currently dormant). Operated on the ChatGPT/Codex split; the original concrete instance the boundary model was sketched against.

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

- [`docs/method.md`](docs/method.md) — compact bridge pointing to `apexSolarKiss/method-ASK` as the upstream methodology layer; substantive method articulation now lives in `method-ASK/docs/method.md`

### Workflow docs

- [`docs/project-instantiation-workflow.md`](docs/project-instantiation-workflow.md) — agent-agnostic workflow doc for the pre-repo instantiation phase before a target ASK repo exists
- [`docs/critique-protocol.md`](docs/critique-protocol.md) — how a fresh-context critique is instantiated (two mechanics by executor type), how the advisor surface is bootstrapped (Project Instructions, not a per-thread paste), the coverage-band requirement, and the non-repo package-availability rule

### Reusable templates for downstream ASK repos

- [`templates/AGENTS.template.md`](templates/AGENTS.template.md) — agent-agnostic starter for repo-local execution rules; derived from the shared workflow core of asset-pipeline-ASK's live AGENTS.md (project-specific architecture rules in that repo are not absorbed by default)
- [`templates/grounding-note.template.md`](templates/grounding-note.template.md) — starter for the external grounding note that travels with each ASK project
- [`templates/architecture.template.md`](templates/architecture.template.md) — starter for a downstream repo's architecture doc
- [`templates/CLAUDE.template.md`](templates/CLAUDE.template.md) — optional Claude Code pointer file for downstream single-node repos
- [`templates/advisor-project-instructions.template.md`](templates/advisor-project-instructions.template.md) — the advisor bootstrap (role + fail-closed read-path) for an external advisor surface (GPT or Claude in chat form); adapted per project and installed **once into the advisor Project Instructions**, not pasted per thread (see [`docs/critique-protocol.md`](docs/critique-protocol.md))
- [`templates/_INDEX-project.template.md`](templates/_INDEX-project.template.md) — the **source index / path map** an advisor Project mounts as its primary Source; instantiated as `<project>-EXTERNAL/_INDEX-<project>.md` (or `_INDEX-<project>-<role>.md` per role). Mount the map, not copies of the canonicals — the advisor fetches canonicals live from Dropbox by exact path; mounted copies are fallback only
- [`templates/overlays/architecture-uncertain-rules.template.md`](templates/overlays/architecture-uncertain-rules.template.md) — optional opt-in overlay for downstream projects with active architecture or ontology uncertainty; adds rules calibrated for projects whose work is to discover structural categories (architecture-before-prototype, prototype-as-pressure-surface, attempt-model-before-plan, self-evident-premise stop, ceremony budget, proof-chain gravity well guard, bootstrap doc-alignment check) on top of the base template; not used by projects whose task surface is known

Templates are copyable starters. They are not live for this repo unless explicitly adopted somewhere else.

### Prompts

- [`prompts/project-instantiation-initial-prompt.md`](prompts/project-instantiation-initial-prompt.md) — agent-agnostic startup prompt for the pre-repo instantiation phase
- [`prompts/claude-code-initial-prompt.md`](prompts/claude-code-initial-prompt.md) — session-start prompt for attaching Claude Code to an existing single-node project repo
- [`prompts/repo-nudge-prompt.md`](prompts/repo-nudge-prompt.md) — lightweight boundary nudge at local plateaus / absorptions / unclear next moves; single open-ended question anchored against the grounding note
- [`prompts/repo-critique-initial-prompt.md`](prompts/repo-critique-initial-prompt.md) — open-ended structural critique against repo + grounding note (initial pass of the fresh-context critique cycle)
- [`prompts/repo-critique-synthesis-prompt.md`](prompts/repo-critique-synthesis-prompt.md) — advisor-role synthesis of two independent critiques into an advisory plan (synthesis pass)
- [`prompts/repo-critique-execution-prompt.md`](prompts/repo-critique-execution-prompt.md) — hand the advisory plan back to the execution surface for scoped implementation (execution pass)
- [`prompts/ecology-critique-initial-prompt.md`](prompts/ecology-critique-initial-prompt.md) — open-ended fresh-context critique across the ASK system-building ecology (`control-surface`, `method-ASK`, `design-system-ASK`, downstream repos / grounding notes)
- [`prompts/ecology-critique-synthesis-prompt.md`](prompts/ecology-critique-synthesis-prompt.md) — fold another independent ecology critique into the one just produced and make an advisory plan
- [`prompts/ecology-critique-execution-prompt.md`](prompts/ecology-critique-execution-prompt.md) — hand the ecology advisory synthesis back to the execution surface for per-repo scoped implementation, stopping at exact scoped diff (execution pass)

### Examples

- [`examples/asset-pipeline-ASK/notes.md`](examples/asset-pipeline-ASK/notes.md) — single-node working example (mature pressure surface)
- [`examples/urban-observatory/notes.md`](examples/urban-observatory/notes.md) — single-node working example (newer; instantiation / source-of-intent recovery pressure surface)
- [`examples/mazeASK/notes.md`](examples/mazeASK/notes.md) — legacy Model A reference (project currently dormant)

### Legacy docs

These were active when the canonical operating model was ASK→ChatGPT→Codex with Claude Code as advisory. They are retained for reference and for `apexSolarKiss/mazeASK`, the legacy Model A reference (currently dormant).

- [`control-surface.md`](control-surface.md) — Model-A-specific external control-surface artifact
- [`docs/workflow-boundary.md`](docs/workflow-boundary.md) — earlier boundary categorization, supplanted by [`AGENTS.md`](AGENTS.md)'s Source-of-Truth Boundaries section
- [`prompts/control-surface-initial-prompt.md`](prompts/control-surface-initial-prompt.md) — Model-A ChatGPT-side initial prompt
- [`prompts/codex-initial-prompt.txt`](prompts/codex-initial-prompt.txt) — Model-A Codex-side initial prompt

Each legacy doc carries a deprecation header naming what supersedes it for current single-node work.

## Which File Do I Use?

| If you need to... | Use |
| --- | --- |
| define execution rules inside the current repo | [`AGENTS.md`](AGENTS.md) |
| understand this protocol repo's own architecture | [`docs/architecture.md`](docs/architecture.md) |
| set up the workflow before the target repo exists | [`docs/project-instantiation-workflow.md`](docs/project-instantiation-workflow.md) and [`prompts/project-instantiation-initial-prompt.md`](prompts/project-instantiation-initial-prompt.md) |
| attach Claude Code to an existing single-node repo | [`prompts/claude-code-initial-prompt.md`](prompts/claude-code-initial-prompt.md) |
| attach an external advisor surface (GPT or Claude in chat form) to an existing repo | [`templates/advisor-project-instructions.template.md`](templates/advisor-project-instructions.template.md) + [`templates/_INDEX-project.template.md`](templates/_INDEX-project.template.md) (mount the index as the primary Source) |
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
- Optionally adapt [`templates/advisor-project-instructions.template.md`](templates/advisor-project-instructions.template.md) and install it once into the advisor Project Instructions when an external advisor surface is used (see [`docs/critique-protocol.md`](docs/critique-protocol.md)); alongside it, create `<project>-EXTERNAL/_INDEX-<project>.md` from [`templates/_INDEX-project.template.md`](templates/_INDEX-project.template.md) and mount that index as the Project's primary Source (the map, not copies of the canonicals).
- Optionally adapt the protocol repo's nudge prompt ([`prompts/repo-nudge-prompt.md`](prompts/repo-nudge-prompt.md)) and critique-cycle prompts ([`prompts/repo-critique-initial-prompt.md`](prompts/repo-critique-initial-prompt.md), [`prompts/repo-critique-synthesis-prompt.md`](prompts/repo-critique-synthesis-prompt.md), [`prompts/repo-critique-execution-prompt.md`](prompts/repo-critique-execution-prompt.md)) into project-flavored operator-side copies in `<project-name>-EXTERNAL/sources of intent/` when those surfaces will be used.

## Background Reading

The control-surface design is anchored to a short execution-protocol subset of the broader ASK workflow / method article line. The full chronological article index lives upstream in [`method-ASK/docs/articles.md`](https://github.com/apexSolarKiss/method-ASK/blob/main/docs/articles.md).

- [*Beyond Vibe Coding: Constraining LLMs*](https://atomicspacekitten.substack.com/p/beyond-vibe-coding-constraining-llms) — the case for constrained LLMs and explicit rules; substrate for the discipline this repo operationalizes.
- [*Lessons from the First Prototype Phase*](https://atomicspacekitten.substack.com/p/lessons-from-the-first-prototype) — the structural retrospective; calibrated compensations for what single-node collapses relative to the legacy split.
- [*Adversarial Collaboration*](https://atomicspacekitten.substack.com/p/adversarial-collaboration) — the within-session multi-mind layer; the pattern behind this repo's two review windows and per-PR cadence.
- [*From Conversation to Control Surface*](https://atomicspacekitten.substack.com/p/from-conversation-to-control-surface) — project inception from messy AI-mediated exploration; the recovered intent → validated constraint → repo sequence.
- [*Three Agents Got Into an Argument // The Repo Won*](https://atomicspacekitten.substack.com/p/three-agents-got-into-an-argument) — the repo-as-arbiter operating rule: artifact-owning surface gets the final read on current file contents.

## License

Copyright 2026 Andrew S Klug // ASK

Licensed under the Apache License 2.0 // see [`LICENSE`](LICENSE)
