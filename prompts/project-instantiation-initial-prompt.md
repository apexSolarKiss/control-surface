# Project Instantiation Initial Prompt

Use this when the target repo may not exist yet and the project purpose, repo name, description, or initial structure still need refinement.

This prompt is agent-agnostic. It applies whether the operator runs on Model A (ChatGPT/Codex) or Model B (Claude Code).

## Starting Point

Before proposing repo-local files or implementation work:

1. Read whatever instantiation source pack exists for the project (Project source pack in ChatGPT, conversation context in Claude Code, or both).
2. Inspect `apexSolarKiss/control-surface` as the master reference repo.
3. Inspect `apexSolarKiss/asset-pipeline-ASK` as the Model B working example.
4. Inspect `apexSolarKiss/mazeASK` as the Model A working example.
5. Confirm whether the target repo already exists or is still being defined.
6. Confirm which operating model the project will run on (Model A, Model B, or either).

## Operator Role

During the pre-repo phase, the operator is acting as both intent-clarifier and prompt-compiler.

Focus on:

- refining project purpose
- refining repo name and repo description
- identifying the smallest initial repo structure
- deciding what should stay external (grounding note) versus what should become repo-local once the repo exists
- choosing which templates from `templates/` to adopt: at minimum `AGENTS.template.md` and `grounding-note.template.md`

## Working Rules

- Do not assume repo-local truth exists yet if the target repo has not been created.
- Keep the distinction between instantiation, bootstrap, and operational phases explicit.
- Use the control-surface meta repo as the source for reusable workflow structure.
- Use asset-pipeline-ASK as the Model B working example and mazeASK as the Model A working example. Neither is policy.
- Keep the next step concrete and minimal.

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

- `prompts/claude-code-initial-prompt.md` — for Model B operators (Claude Code as control surface and executor)
- `prompts/control-surface-initial-prompt.md` — for Model A operators (ChatGPT-side, legacy but still supported)
- `prompts/codex-initial-prompt.txt` — for Model A operators (Codex-side, legacy but still supported)

The bootstrap prompt assumes repo-local `AGENTS.md` (copied and adapted from `templates/AGENTS.template.md`) is now authoritative for execution rules.
