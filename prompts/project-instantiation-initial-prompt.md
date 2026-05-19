# Project Instantiation Initial Prompt

Use this when the target repo may not exist yet and the project purpose, repo name, description, or initial structure still need refinement.

This prompt is agent-agnostic. It applies whether the operator runs the default single-node model (Claude Code as control surface and executor) or the legacy split-execution model (ChatGPT/Codex with Claude Code as advisor — referred to historically as Model A).

## Starting Point

Before proposing repo-local files or implementation work:

1. Read whatever instantiation source pack exists for the project (Project source pack in ChatGPT, conversation context in Claude Code, or both).
2. Inspect `apexSolarKiss/control-surface` as the master reference repo.
3. Inspect `apexSolarKiss/asset-pipeline-ASK` as the single-node working example (the default model for new projects).
4. Inspect `apexSolarKiss/mazeASK` as the legacy Model A working example (still active for that project).
5. Confirm whether the target repo already exists or is still being defined.
6. Confirm the operating model. Default to single-node unless the project has a specific reason to run on legacy Model A.

## Operator Role

During the pre-repo phase, the operator is acting as both intent-clarifier and prompt-compiler.

Focus on:

- refining project purpose
- refining repo name and repo description
- identifying the smallest initial repo structure
- deciding what should stay external (grounding note) versus what should become repo-local once the repo exists
- choosing which templates from `templates/` to adopt: at minimum `AGENTS.template.md` and `grounding-note.template.md`
- evaluating whether the project profile is architecture-uncertain (ontology-first work, prototypes as pressure surfaces, deferred schema commitment, modeling-before-planning, ceremony-budget pressure) and whether `templates/overlays/architecture-uncertain-rules.template.md` should be adopted on top of the base `AGENTS.template.md`

## Working Rules

- Do not assume repo-local truth exists yet if the target repo has not been created.
- Keep the distinction between instantiation, bootstrap, and operational phases explicit.
- Use the control-surface meta repo as the source for reusable workflow structure.
- Use asset-pipeline-ASK as the single-node working example (default) and mazeASK as the legacy Model A working example. Neither is policy.
- Keep the next step concrete and minimal.

## Operator-side memory layer

During instantiation, identify whether the project needs operator-side memory entries for durable execution context that should guide the control surface but should not live repo-locally.

Examples include:

- voice-discipline / voice-externality operational protections, where the repo may carry the rule but operator-side memory carries project-specific protected vocabulary, translation guidance, or over-sanitization warnings
- tool-dependent workflow identity, where the repo may carry a tool-agnostic workflow rule but operator-side memory carries the current approved external tool / vendor / surface identity and substitution path
- other project-specific operator-side specifics that repo rules depend on but should not be copied into repo-local artifacts

The instantiation advisor should name which operator-side memory entries, if any, are needed for the project and what category each entry serves. Do not include concrete token lists, translation tables, hook configs, vendor names, or project-specific protected vocabulary in this prompt output. Those specifics are project-tailored operator-side content and should be created only in the downstream project's operator-side memory layer.

If no operator-side memory entries are needed yet, say so explicitly.

## Expected Output

Produce the next ready-to-send prompt for creating or bootstrapping the target repo.

That prompt should include:

- project purpose
- proposed repo name
- proposed repo description
- initial repo structure
- which operating model the project will use
- which templates from `templates/` will be adopted
- where the external grounding note will live (path outside the repo)
- which repo-local docs should be created first after repo creation

## Phase Transition

Once the repo exists, the operator transitions to the bootstrap phase. The relevant follow-on prompt is:

- `prompts/claude-code-initial-prompt.md` — for the default single-node model (Claude Code as control surface and executor)
- `prompts/control-surface-initial-prompt.md` — for legacy Model A (ChatGPT-side, retained for `mazeASK` and any other project still on Model A)
- `prompts/codex-initial-prompt.txt` — for legacy Model A (Codex-side, retained for `mazeASK` and any other project still on Model A)

The bootstrap prompt assumes repo-local `AGENTS.md` (copied and adapted from `templates/AGENTS.template.md`) is now authoritative for execution rules.

After initial bootstrap completes (repo created, `AGENTS.md` adopted, first repo-local docs in place), run the post-bootstrap grounding-note trim pass described in `templates/grounding-note.template.md`. The pre-repo grounding note often carries repo-shape thinking, planned file inventory, "future repo" language, and bootstrap-stage task sequencing that becomes fast-aging once the repo owns project truth.
