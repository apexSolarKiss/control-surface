# control-surface

![control-surface banner](control-surface-banner.png)

Reusable control-surface workflow assets for ASK projects.

**Operating model:** adversarial collaboration — ASK as authorization apex and relay, a non-writing advisor surface, and a repo-attached execution surface. Currently a GPT advisor and Claude Code as executor.

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
     intent-carriers/                    # standing + invocable carrier canonicals (unversioned)
       ZZZ/                              #   frozen _vN snapshots + retired / historical carrier lineage
     intent-INbox/                       # inbound routed handoffs, under the filename lifecycle
       _STATE.md                         #   structural inbox state — not routed intent
   ```

   Root is the default durable-context layer of an `*-EXTERNAL` surface; named semantic or structural layers (`scratch/`, `intent-carriers/`, `intent-INbox/`) override it only where explicitly defined.

   The two intent planes are **not** interchangeable. `intent-carriers/` holds carriers the project *invokes or deploys* — adapted prompts, deployed instruction canonicals — under **canonical lineage**: the unversioned current canonical mirrors the latest accepted `_vN`, and `ZZZ/` holds the frozen `_vN` snapshots plus retired or historical carrier variants. **A prior `_vN` is historical, not superseded** — ordinary version succession is revision, and carrier families are revised, retired, or replaced. Existing legacy filenames containing `SUPERSEDED` are preserved unchanged and acquire no prospective routed-instance meaning.

   `intent-INbox/` holds *addressed routed instances* arriving from another operating surface, each under the filename lifecycle (`-TBI` → `-ingested` → a terminal disposition suffix, or `-supersededA` before ingestion). That specialization is the **fresh routed handoff's**; terminal `-TBI` is an orthogonal feed-obligation overlay that may sit above any artifact, and for anything not awaiting first ingestion it is simply removed. Prospective supersession belongs to that plane only. A standing carrier never takes a handoff lifecycle *suffix* — though it may carry the overlay; a routed instance never becomes a carrier by being ingested.

   `intent-INbox/_STATE.md` is **structural, not routed intent**: no lifecycle suffix, excluded from queue counts, updated in place, and read immediately before ingestion. A structural artifact is exempt only where the surface's structural contract **names** it — a leading `_` alone confers no exemption.

   **This tree is the target convention.** A surface that has not yet recorded its cutover keeps its current mapped intake path, and its `_INDEX` remains the operative locator until then; the absence of `intent-INbox/_STATE.md` before cutover is not nonconformance.

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
   - Create the source index from [`templates/_INDEX-project.template.md`](templates/_INDEX-project.template.md) as `<project-name>-EXTERNAL/_INDEX-<project-name>.md` (or `_INDEX-<project-name>-<role>.md` per advisor role). It is **fetched live**, not mounted.
   - Generate the surface bootstrap from [`templates/advisor-project-bootstrap.template.md`](templates/advisor-project-bootstrap.template.md) and mount it as the advisor Project's **single standing Source**; adapt [`templates/advisor-project-instructions.template.md`](templates/advisor-project-instructions.template.md) — the thin pre-bootstrap floor — and install it once into the Project Instructions. Placement contract: [`docs/advisor-project-surface-architecture.md`](docs/advisor-project-surface-architecture.md).
9. (Optional) When the project will use the advisor / nudge / critique surfaces, adapt the protocol repo's reusable nudge and critique prompts into project-flavored operator-side copies in `<project-name>-EXTERNAL/intent-carriers/` — an adapted prompt is an **invocable carrier**, not a routed handoff, so it never lands in `intent-INbox/` and never takes a lifecycle suffix:

   ```text
   prompts/repo-nudge-prompt.md              → <project-name>_repo-nudge-prompt.md
   prompts/repo-critique-initial-prompt.md   → <project-name>_repo-critique-initial-prompt.md
   prompts/repo-critique-synthesis-prompt.md → <project-name>_repo-critique-synthesis-prompt.md
   prompts/repo-critique-execution-prompt.md → <project-name>_repo-critique-execution-prompt.md
   ```

   The protocol repo's prompts remain canonical reusable sources; the operator-side copies are project-flavored adaptations so the advisor and control surfaces can operate without re-deriving prompt language each time. Adapt only the prompts the project will actually use.

   Distinct from this copy-and-adapt flow: a new repo also **resolves** the shared protocol carrier ([`protocol/AGENTS.shared.md`](protocol/AGENTS.shared.md)) locally into its own `AGENTS.md` between the `BEGIN`/`END` shared markers. The shared core is resolved in place, not copied-and-adapted like a prompt or template starter.

   System-wide ecology critique prompts are the **ecology-level flavor** of the reusable critique family. The repo
   files below remain the canonical reusable sources; ASK invokes one deployed ecology-level operator-carrier
   family from the ecology surface's `intent-carriers/`. They are not adapted into downstream-project
   operator-side copies:

   ```text
   prompts/ecology-critique-initial-prompt.md
   prompts/ecology-critique-synthesis-prompt.md
   prompts/ecology-critique-execution-prompt.md
   ```

   These are for system-wide critique across `control-surface`, [`method-ASK`](https://github.com/apexSolarKiss/method-ASK), [`design-system-ASK`](https://github.com/apexSolarKiss/design-system-ASK), and relevant downstream repos / grounding notes — not ordinary downstream-project critique.

10. Once bootstrap begins, the new repo's `AGENTS.md` governs execution.

New projects run the adversarial-collaboration operating model described below.

For deeper context on the three phases (Instantiation → Bootstrap → Operational), see [`docs/project-instantiation-workflow.md`](docs/project-instantiation-workflow.md).

## Operating Model

ASK projects run an **adversarial-collaboration operating model** — an ASK-apexed advisor–executor topology:

- **ASK** is the source-of-intent and authorization apex, the relay across surfaces, and the final adjudicator.
- The **advisor surface** supplies external challenge, reconstruction, and verification. It holds no repo-write authority and sits outside the execution thread.
- The **execution surface** plans and performs authorized work in the repo under `AGENTS.md`, under single-writer-per-branch discipline.

In the current stack a GPT advisor fills the advisor role and Claude Code fills the execution role. Model identity is operational, not architectural.

The friction at the advisor/executor boundary is deliberate: differently situated adversarial challenge mitigates the risk that hallucination, confabulation, or drift will persist into landed work. The surfaces are correlated, not independent; named canonicals and exact repo state arbitrate factual disagreement, while ASK adjudicates source-of-intent and authorization questions. Much of what this protocol requires — the plan, the structured change summary, the exact scoped diff, the pushed PR — exists so that boundary has something precise to work on.

**Direct execution** is the bounded variant: ASK drives the executor without an advisor pass where a separate pass would not materially reduce uncertainty. It is a proportional path within the same model, not a separate model.

In short: **multi-surface in reasoning, single-writer in mutation, single-apex in authority.**

The workflow rules live in a shared protocol core ([`protocol/AGENTS.shared.md`](protocol/AGENTS.shared.md)) resolved locally into each repo's own `AGENTS.md`, plus repo-local `AGENTS.md` rules — all written agent-agnostically, so they apply to whoever is executing.

Two current working examples anchor the family:

- [`apexSolarKiss/asset-pipeline-ASK`](https://github.com/apexSolarKiss/asset-pipeline-ASK) — primary pressure surface from which the protocol repo's rules are discovered, and source of upstream workflow-rule evolution. Operated end-to-end under this model; has produced the most advanced live `AGENTS.md` in the family. Template changes absorb only the portions that generalize beyond that repo's domain.
- [`apexSolarKiss/urban-observatory`](https://github.com/apexSolarKiss/urban-observatory) — second active working example. Pressures the protocol repo at the source-of-intent recovery, post-bootstrap grounding-note freshness, and architecture-uncertain instantiation surfaces.

## Source-of-Truth Split

ASK project work uses three durable sources of truth, plus two non-durable surfaces that are **not** interchangeable:

- **Repo** = project state (artifacts, decisions, current navigation)
- **[`AGENTS.md`](AGENTS.md)** (in-repo) = workflow rules, agent-agnostic, applies to whoever executes
- **Grounding note** (external) = repo-external context: intent, audience, philosophy, foundational premises, durable loose threads
- **Per-conversation / task state** (current chat, ChatGPT thread history, task lists, in-flight session context) = ephemeral; does not flow into the durable sources
- **Private agent memory** (Claude Code's auto memory — `MEMORY.md` and its topic files) = **persistent, not ephemeral**: a non-authoritative, read-mostly operator cache. Never a durable owner, never the home for in-flight tracking. Every mutation is governed by [`AGENTS.md`](AGENTS.md) §Learning Disposition and §Private-Memory Write Gate — classify to a visible owner first, and each write is a separate ASK approval unit.

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
- [`CLAUDE.md`](CLAUDE.md) — the Claude Code adapter: Claude Code reads `CLAUDE.md`, not `AGENTS.md`, so its `@AGENTS.md` import is what delivers the resolved carrier into context. Required for a Claude-operated repo, not a convenience pointer
- [`docs/architecture.md`](docs/architecture.md) — execution-protocol architecture of this repo and the role model behind it

### Shared protocol carriers

Live, authoritative carriers of the distributable execution protocol. Consumers resolve the shared block **locally** — it lands inside their own `AGENTS.md` (already a required read) — rather than each holding an independent copy.

- [`protocol/AGENTS.shared.md`](protocol/AGENTS.shared.md) — the distributable shared execution-protocol body, resolved verbatim into each repo's own `AGENTS.md` between the `BEGIN`/`END` shared markers
- [`protocol/manifest.json`](protocol/manifest.json) — normative registry for the protocol carriers
- [`protocol/profiles/`](protocol/profiles/) — per-profile overlays on the shared body
- [`protocol/fragments/standing-upstream-conformance-grant.md`](protocol/fragments/standing-upstream-conformance-grant.md) — opt-in consumer fragment for a standing upstream-conformance grant
- [`protocol/check.sh`](protocol/check.sh) — deterministic local validator for the resolved shared block (run locally; not CI)
- [`protocol/adapters/`](protocol/adapters/) — typed, executor-specific adapters providing **runtime enforcement for a supported write path** of an agent-agnostic shared rule on a given runtime. They do **not** claim OS-level enforcement over arbitrary Bash, Python, Node, or other subprocess writes; the shared protocol prohibits that circumvention semantically, and sandbox hardening remains a separate out-of-scope capability question. **Not shared-protocol text and never inherited into a consumer's `AGENTS.md`.** [`protocol/adapters/claude-code/`](protocol/adapters/claude-code/) carries the native permission fragment for the private-persistent write gate, a static owner-repo check, a machine-local verifier, and their fixtures — run separately from `check.sh`, which stays agent-agnostic

### Methodology docs

- [`docs/method.md`](docs/method.md) — compact bridge pointing to [`apexSolarKiss/method-ASK`](https://github.com/apexSolarKiss/method-ASK) as the upstream methodology layer; substantive method articulation now lives in `method-ASK/docs/method.md`

### Workflow docs

- [`docs/project-instantiation-workflow.md`](docs/project-instantiation-workflow.md) — agent-agnostic workflow doc for the pre-repo instantiation phase before a target ASK repo exists
- [`docs/advisor-project-surface-architecture.md`](docs/advisor-project-surface-architecture.md) — how an advisor surface is deployed into a hosted Project: the pre-retrieval floor, the mounted bootstrap, the live-fetched index, and the requirement registry they are generated from
- [`docs/advisor-surface-compression-loss.md`](docs/advisor-surface-compression-loss.md) — the audited failure that produced it: what a size-capped, always-applied contract field silently drops
- [`docs/critique-protocol.md`](docs/critique-protocol.md) — how a fresh-context critique is instantiated (two mechanics by executor type), how the advisor surface is bootstrapped (a mounted bootstrap carrying the contract plus a thin Project Instructions floor, neither pasted per thread), the coverage-band requirement, and the non-repo package-availability rule
- [`docs/domain-authority-review-protocol.md`](docs/domain-authority-review-protocol.md) — the reviewer-neutral protocol for a review by a domain authority in a role distinct from the architect/operator: the three independent axes (review mode ≠ return mode ≠ authority), the stage contract, claim-level classification, the handoff-necessity gate, and how it stays distinct from SMGI (delivery) and critique-protocol (fresh-context critique)

### Reusable templates for downstream ASK repos

- [`templates/AGENTS.template.md`](templates/AGENTS.template.md) — agent-agnostic starter for repo-local execution rules; the shared workflow core now lives in [`protocol/AGENTS.shared.md`](protocol/AGENTS.shared.md) (originally derived from asset-pipeline-ASK's live AGENTS.md), and this template is a copyable starter for the repo-local remainder alongside the resolved shared core (project-specific architecture rules in that repo are not absorbed by default)
- [`templates/grounding-note.template.md`](templates/grounding-note.template.md) — starter for the external grounding note that travels with each ASK project
- [`templates/architecture.template.md`](templates/architecture.template.md) — starter for a downstream repo's architecture doc
- [`templates/CLAUDE.template.md`](templates/CLAUDE.template.md) — the Claude Code adapter for a downstream repo; **required** for any Claude-operated repo, carrying exactly one `@AGENTS.md` import above its repo-specific prose
- [`templates/advisor-project-bootstrap.template.md`](templates/advisor-project-bootstrap.template.md) — the full advisor contract, generated from the requirement registry; the one standing Source an advisor Project mounts
- [`templates/advisor-project-instructions.template.md`](templates/advisor-project-instructions.template.md) — the **thin pre-bootstrap floor** for the Project Instructions field: what must bind before any fetch, and still hold when every fetch fails
- [`templates/_INDEX-project.template.md`](templates/_INDEX-project.template.md) — the **source index / path map** an advisor surface fetches live at the locator its bootstrap declares; instantiated per project (and per advisor role)
- [`templates/overlays/architecture-uncertain-rules.template.md`](templates/overlays/architecture-uncertain-rules.template.md) — optional opt-in overlay for downstream projects with active architecture or ontology uncertainty; adds rules calibrated for projects whose work is to discover structural categories (architecture-before-prototype, prototype-as-pressure-surface, attempt-model-before-plan, self-evident-premise stop, ceremony budget, proof-chain gravity well guard, bootstrap doc-alignment check) on top of the base template; not used by projects whose task surface is known
- [`templates/domain-authority-review-profile.template.md`](templates/domain-authority-review-profile.template.md) — conditional profile a downstream project instantiates **only if** it has a domain authority in a role distinct from the architect/operator; a minimum, extensible standing-fields + per-review stage-contract profile, governed by [`docs/domain-authority-review-protocol.md`](docs/domain-authority-review-protocol.md)

Templates in `templates/` are copyable starters. They are not live for this repo unless explicitly adopted somewhere else. The `protocol/` carriers are different: they are live and authoritative, resolved locally by consumers into their own `AGENTS.md`, not copy-only starters.

### Prompts

- [`prompts/project-instantiation-initial-prompt.md`](prompts/project-instantiation-initial-prompt.md) — agent-agnostic startup prompt for the pre-repo instantiation phase
- [`prompts/claude-code-initial-prompt.md`](prompts/claude-code-initial-prompt.md) — session-start prompt for attaching Claude Code to an existing ASK project repo as the execution surface
- [`prompts/repo-nudge-prompt.md`](prompts/repo-nudge-prompt.md) — lightweight boundary nudge at local plateaus / absorptions / unclear next moves; single open-ended question anchored against the grounding note
- [`prompts/repo-critique-initial-prompt.md`](prompts/repo-critique-initial-prompt.md) — open-ended structural critique against repo + grounding note (initial pass of the fresh-context critique cycle)
- [`prompts/repo-critique-synthesis-prompt.md`](prompts/repo-critique-synthesis-prompt.md) — advisor-role synthesis of two independent critiques into an advisory plan (synthesis pass)
- [`prompts/repo-critique-execution-prompt.md`](prompts/repo-critique-execution-prompt.md) — hand the advisory plan back to the execution surface for scoped implementation (execution pass)
- [`prompts/ecology-critique-initial-prompt.md`](prompts/ecology-critique-initial-prompt.md) — open-ended fresh-context critique across the ASK system-building ecology (`control-surface`, [`method-ASK`](https://github.com/apexSolarKiss/method-ASK), [`design-system-ASK`](https://github.com/apexSolarKiss/design-system-ASK), downstream repos / grounding notes)
- [`prompts/ecology-critique-synthesis-prompt.md`](prompts/ecology-critique-synthesis-prompt.md) — fold another independent ecology critique into the one just produced and make an advisory plan
- [`prompts/ecology-critique-execution-prompt.md`](prompts/ecology-critique-execution-prompt.md) — hand the ecology advisory synthesis back to the execution surface for per-repo scoped implementation, stopping at exact scoped diff (execution pass)
- [`prompts/cross-repo-propagation-wave.md`](prompts/cross-repo-propagation-wave.md) — coordinator runbook for a multi-consumer propagation wave: phase contract, subagent evidence-packet schema, and the two typed profiles (design-system vendor propagation · execution-protocol carrier propagation)

### Examples

- [`examples/asset-pipeline-ASK/notes.md`](examples/asset-pipeline-ASK/notes.md) — primary pressure surface (mature working example)
- [`examples/urban-observatory/notes.md`](examples/urban-observatory/notes.md) — second working example (instantiation / source-of-intent recovery pressure surface)

## Which File Do I Use?

| If you need to... | Use |
| --- | --- |
| define execution rules inside the current repo | [`AGENTS.md`](AGENTS.md) |
| understand this protocol repo's own architecture | [`docs/architecture.md`](docs/architecture.md) |
| set up the workflow before the target repo exists | [`docs/project-instantiation-workflow.md`](docs/project-instantiation-workflow.md) and [`prompts/project-instantiation-initial-prompt.md`](prompts/project-instantiation-initial-prompt.md) |
| attach Claude Code to an existing ASK repo as the execution surface | [`prompts/claude-code-initial-prompt.md`](prompts/claude-code-initial-prompt.md) |
| attach an external advisor surface (GPT or Claude in chat form) to an existing repo | [`templates/advisor-project-bootstrap.template.md`](templates/advisor-project-bootstrap.template.md) + [`templates/advisor-project-instructions.template.md`](templates/advisor-project-instructions.template.md) + [`templates/_INDEX-project.template.md`](templates/_INDEX-project.template.md) |
| run a review by a domain authority in a role distinct from the architect/operator | [`docs/domain-authority-review-protocol.md`](docs/domain-authority-review-protocol.md) + [`templates/domain-authority-review-profile.template.md`](templates/domain-authority-review-profile.template.md) |
| create repo-local starter docs for a downstream repo | [`templates/AGENTS.template.md`](templates/AGENTS.template.md), [`templates/grounding-note.template.md`](templates/grounding-note.template.md), [`templates/architecture.template.md`](templates/architecture.template.md), [`templates/CLAUDE.template.md`](templates/CLAUDE.template.md) |
| see how the structure mapped onto a real ASK project | [`examples/`](examples/) |

## Minimal Adaptation Checklist

For a new ASK project:

- Identify the project purpose, repo name, and initial structure.
- Use the adversarial-collaboration operating model: ASK apex + advisor surface + execution surface.
- Copy [`templates/AGENTS.template.md`](templates/AGENTS.template.md) into the new repo as `AGENTS.md` and adapt project-specific defaults.
- Copy [`templates/grounding-note.template.md`](templates/grounding-note.template.md) into the external grounding-note location and fill in intent, audience, philosophy, foundational premises, and durable loose threads.
- Optionally copy [`templates/architecture.template.md`](templates/architecture.template.md) into the new repo as `docs/architecture.md`.
- For a Claude-operated repo, copy [`templates/CLAUDE.template.md`](templates/CLAUDE.template.md) into the new repo as `CLAUDE.md` — required, not optional; keep exactly one `@AGENTS.md` import.
- Optionally adopt [`templates/overlays/architecture-uncertain-rules.template.md`](templates/overlays/architecture-uncertain-rules.template.md) when the project profile is architecture-uncertain (ontology-first work, prototypes as pressure surfaces, deferred schema commitment, modeling-before-planning). Append after the base `AGENTS.md` rules; skip when the task surface is known and the work is execution against it.
- Identify protected paths, constraints, and required verification steps in the new repo's `AGENTS.md`.
- Use [`prompts/claude-code-initial-prompt.md`](prompts/claude-code-initial-prompt.md) to attach Claude Code after the repo exists.
- Optionally generate a surface bootstrap from [`templates/advisor-project-bootstrap.template.md`](templates/advisor-project-bootstrap.template.md), install the thin floor from [`templates/advisor-project-instructions.template.md`](templates/advisor-project-instructions.template.md) into the advisor Project Instructions, and create the live-fetched source index from [`templates/_INDEX-project.template.md`](templates/_INDEX-project.template.md).
- Optionally adapt the protocol repo's nudge prompt ([`prompts/repo-nudge-prompt.md`](prompts/repo-nudge-prompt.md)) and critique-cycle prompts ([`prompts/repo-critique-initial-prompt.md`](prompts/repo-critique-initial-prompt.md), [`prompts/repo-critique-synthesis-prompt.md`](prompts/repo-critique-synthesis-prompt.md), [`prompts/repo-critique-execution-prompt.md`](prompts/repo-critique-execution-prompt.md)) into project-flavored operator-side copies in `<project-name>-EXTERNAL/intent-carriers/` when those surfaces will be used.

## Background Reading

The control-surface design is anchored to a short execution-protocol subset of the broader ASK workflow / method article line. The full chronological article index lives upstream in [`method-ASK/docs/articles.md`](https://github.com/apexSolarKiss/method-ASK/blob/main/docs/articles.md).

- [*Beyond Vibe Coding: Constraining LLMs*](https://atomicspacekitten.substack.com/p/beyond-vibe-coding-constraining-llms) — the case for constrained LLMs and explicit rules; substrate for the discipline this repo operationalizes.
- [*Lessons from the First Prototype Phase*](https://atomicspacekitten.substack.com/p/lessons-from-the-first-prototype) — the structural retrospective that sharpened the protocol's constraints, review surfaces, and evidence discipline.
- [*Adversarial Collaboration*](https://atomicspacekitten.substack.com/p/adversarial-collaboration) — the within-session multi-mind layer; the pattern behind this repo's two review windows and per-PR cadence.
- [*From Conversation to Control Surface*](https://atomicspacekitten.substack.com/p/from-conversation-to-control-surface) — project inception from messy AI-mediated exploration; the recovered intent → validated constraint → repo sequence.
- [*Three Agents Got Into an Argument // The Repo Won*](https://atomicspacekitten.substack.com/p/three-agents-got-into-an-argument) — the repo-as-arbiter operating rule: artifact-owning surface gets the final read on current file contents.

## License

Copyright 2026 Andrew S Klug // ASK

Licensed under the Apache License 2.0 // see [`LICENSE`](LICENSE)
