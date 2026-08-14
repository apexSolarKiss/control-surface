# Project Instantiation Initial Prompt

Use this when the target repo may not exist yet and the project purpose, repo name, description, or initial structure still need refinement.

This prompt is agent-agnostic. ASK projects run one operating model — adversarial collaboration: ASK as the source-of-intent and authorization apex, a non-writing advisor surface outside the execution thread, and a repo-attached execution surface working under `AGENTS.md`. What varies by project is which surfaces are occupied and by whom, not which model applies.

## Starting Point

Before proposing repo-local files or implementation work:

1. Read whatever instantiation source pack exists for the project (Project source pack in ChatGPT, conversation context in Claude Code, or both).
2. Inspect `apexSolarKiss/control-surface` as the master reference repo.
3. Inspect `apexSolarKiss/asset-pipeline-ASK` as the mature working example (the most advanced live `AGENTS.md` in the family), and `apexSolarKiss/urban-observatory` as the second.
4. Confirm whether the target repo already exists or is still being defined.
5. Confirm which surfaces the project will run: the repo-attached execution surface, and whether an external advisor surface is configured. The operating model is not a project choice; surface occupancy is.

## Operator Role

During the pre-repo phase, the operator is acting as both intent-clarifier and author of the initial instructions.

Focus on:

- refining project purpose
- refining repo name and repo description
- identifying the smallest initial repo structure
- deciding what should stay external (grounding note) versus what should become repo-local once the repo exists
- choosing which templates from `templates/` to adopt: at minimum `AGENTS.template.md` and `grounding-note.template.md`, plus `CLAUDE.template.md` for any Claude-operated repo — required, not optional, carrying exactly one `@AGENTS.md` import, because Claude Code reads `CLAUDE.md` rather than `AGENTS.md`. The adopted `AGENTS.template.md` carries BEGIN/END shared markers around the execution-protocol core; that core is resolved verbatim from `control-surface/protocol/AGENTS.shared.md` into the new repo's `AGENTS.md` between those markers — not re-authored — so consumers resolve the shared block locally inside their own required-read `AGENTS.md` rather than holding an independent copy
- deciding whether the project will use an external advisor surface (GPT or Claude in chat form) and therefore needs **the three advisor-surface artifacts**: the generated surface bootstrap (`templates/advisor-project-bootstrap.template.md`, instantiated as `<project>-EXTERNAL/_BOOTSTRAP-<project>.md` and **mounted as the advisor Project's single standing Markdown Source**), the thin Instructions floor (`templates/advisor-project-instructions.template.md`, installed once into the Instructions field — not pasted per thread — and pointing first at the mounted bootstrap), and the source-index map `<project>-EXTERNAL/_INDEX-<project>.md` (from `templates/_INDEX-project.template.md`), **live-fetched at the bootstrap's exact locator and not mounted in healthy connector mode**; skip all three for projects with no advisor surface
- evaluating whether the project profile is architecture-uncertain (ontology-first work, prototypes as pressure surfaces, deferred schema commitment, modeling-before-planning, ceremony-budget pressure) and whether `templates/overlays/architecture-uncertain-rules.template.md` should be adopted on top of the base `AGENTS.template.md`
- evaluating whether the project has a **domain authority** in a role distinct from the architect/operator (an internal or external expert who supplies binding judgment within a named domain); if so, it adopts `templates/domain-authority-review-profile.template.md` at bootstrap and follows `docs/domain-authority-review-protocol.md` — the reviewer-neutral protocol that keeps the reviewer's authority, the project stage, and implementation authority independent and classifies returned claims by stage; skip for projects whose source of intent is authored entirely by the architect/operator

## Working Rules

- Do not assume repo-local truth exists yet if the target repo has not been created.
- Keep the distinction between instantiation, bootstrap, and operational phases explicit.
- Use the control-surface protocol repo as the source for reusable workflow structure.
- Use asset-pipeline-ASK as the mature working example and urban-observatory as the second. Neither is policy.
- Keep the next step concrete and minimal.

## Learning Disposition at instantiation

During instantiation, do not pre-create private agent memory as a required project layer. Classify each proposed persistent claim before selecting a surface:

- operative workflow or project truth → visible repo owner;
- slow external intent or constraint → grounding note;
- cross-surface state or obligation → applicable operator ledger;
- temporary setup state → current task state, then no retention;
- machine-local, wall-bound, or deliberately non-operative residue → private-memory candidate only after the visible-owner test.

A private persistent candidate remains proposal-only. It requires its exact target, exact proposed mutation, aging/review trigger, and separate ASK authorization after the repo's carrier and native gate are active.

Two claim classes a project often assumes are memory-owned are not automatically so:

- voice-discipline / voice-externality operational protections — the repo carries the rule; the project-specific protected vocabulary, translation guidance, and over-sanitization warnings route to the narrowest visible or operator-side owner suited to their cadence, and to private memory only as machine-local residue that survives the visible-owner test
- tool-dependent workflow identity — the repo carries the tool-agnostic structural role; the current approved external tool / vendor / surface identity and substitution path route the same way, per `AGENTS.md` §Tool-Dependent Workflow Rules

Do not include concrete token lists, translation tables, hook configs, vendor names, or project-specific protected vocabulary in this prompt output. Those specifics are project-tailored operator-side content, created downstream at whichever owner the classification selects.

If no persistent claim needs a durable owner beyond the repo and the grounding note, say so explicitly.

## Expected Output

Produce the next ready-to-send prompt for creating or bootstrapping the target repo.

That prompt should include:

- project purpose
- proposed repo name
- proposed repo description
- initial repo structure
- which executor is attached as the repo's execution surface
- which templates from `templates/` will be adopted
- whether an external advisor surface is planned and, if so, **all three advisor-surface artifacts**: the generated surface bootstrap (`templates/advisor-project-bootstrap.template.md`, instantiated as `<project>-EXTERNAL/_BOOTSTRAP-<project>.md` and **mounted as the advisor Project's single standing Markdown Source**), the thin Instructions floor (`templates/advisor-project-instructions.template.md`, installed once into the Instructions field — not pasted per thread — and pointing first at the mounted bootstrap), and the source-index map `<project>-EXTERNAL/_INDEX-<project>.md` (from `templates/_INDEX-project.template.md`), **live-fetched at the bootstrap's exact locator and not mounted in healthy connector mode**
- if any hosted Project surface governed by `docs/advisor-project-surface-architecture.md` is planned — an **ASK-facing repo-advisor Project or a hosted domain-authority review Project**, since both use the same deployment shape — the **memory-scope decision and its rationale for each exact hosted Project instance being created**, stated before that Project is created. The instance is what carries the setting, and the role or function it serves is why. Say whether the function is continuity (accumulated cross-thread context is useful) or contextual isolation (reasoning must start from a clean context, which requires Project-only *plus* an empty-Project workflow). Record it in that variant's own carrier — the Instructions template's outside-fence section for a repo-advisor instance, the surface's own operator configuration canonical for a domain-authority review instance. Personal-context Projects are separately governed across the wall and are not in scope. State it for the instances being instantiated; do not carry an inventory of other Projects' settings, and do not assume one value is correct for every instance
- where the external grounding note will live (path outside the repo)
- which repo-local docs should be created first after repo creation
- the learning disposition for each persistent claim instantiation surfaced — visible repo owner · grounding note · operator ledger · no retention · or a private-persistent candidate pending separate ASK authorization. Report dispositions; do not prescribe a list of private-memory files to create.

## Phase Transition

Once the repo exists, the operator transitions to the bootstrap phase. The relevant follow-on prompt is:

- `prompts/claude-code-initial-prompt.md` — the session-start prompt for the repo-attached execution surface

The bootstrap prompt assumes repo-local `AGENTS.md` (copied and adapted from `templates/AGENTS.template.md`, with the shared execution-protocol core resolved verbatim from `control-surface/protocol/AGENTS.shared.md` into the block between its BEGIN/END shared markers rather than re-authored) is now authoritative for execution rules.

After initial bootstrap completes (repo created, `AGENTS.md` adopted, first repo-local docs in place), run the post-bootstrap grounding-note trim pass described in `templates/grounding-note.template.md`. The pre-repo grounding note often carries repo-shape thinking, planned file inventory, "future repo" language, and bootstrap-stage task sequencing that becomes fast-aging once the repo owns project truth.
