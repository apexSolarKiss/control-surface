# Project Instantiation Workflow

This doc explains the workflow before a target ASK repo exists, and how that upstream phase transitions into normal operational use.

It is agent-agnostic. The default operating model for new ASK projects is single-node (Claude Code as control surface and executor). The legacy split-execution model (ChatGPT/Codex with Claude Code as advisor — historically referred to as Model A) is retained for projects already running on it.

## Phases

### 1. Instantiation

Use this phase when the project is being defined and the target repo does not yet exist.

During instantiation:

- read whatever instantiation source pack exists (Project source pack in ChatGPT, conversation context in Claude Code, or both)
- use `apexSolarKiss/control-surface` as the master reference repo
- use `apexSolarKiss/asset-pipeline-ASK` as the single-node working example (default)
- use `apexSolarKiss/mazeASK` as the legacy Model A working example (still active for that project)
- refine project purpose, repo name, repo description, and initial structure
- confirm the operating model — default to single-node unless the project has a specific reason to run on legacy Model A
- decide which assets should remain external versus which should eventually live in the repo
- decide where the external grounding note will live (path outside the repo)

At this point, there is no repo-local truth yet because the target repo does not exist. The instantiation prompt is `prompts/project-instantiation-initial-prompt.md`.

### 2. Bootstrap

Use this phase once the target repo exists and the first repo-local files can be established.

During bootstrap:

- verify the new repo attachment
- copy `templates/AGENTS.template.md` into the repo as `AGENTS.md` and adapt project-specific defaults
- copy `templates/grounding-note.template.md` into the external grounding-note location and fill in intent, audience, philosophy, foundational premises, and durable loose threads
- optionally copy `templates/architecture.template.md` into the repo as `docs/architecture.md`
- if running single-node, optionally add `CLAUDE.md` as a pointer to `AGENTS.md`
- identify the first repo-local entry points

This is the phase where repo-local truth begins to exist. The transition prompt is:

- `prompts/claude-code-initial-prompt.md` for the default single-node model (Claude Code as control surface and executor)
- `prompts/control-surface-initial-prompt.md` and `prompts/codex-initial-prompt.txt` for legacy Model A (retained for projects already running on it)

### 3. Operational

Use this phase once the target repo has active repo-local docs and normal work can proceed.

During operational use:

- treat repo-local files as the source of truth for work inside the repo
- treat the external grounding note as the source of truth for repo-external context
- use prompts for startup or handoff, not as permanent repo policy
- treat per-conversation memory (Claude Code's MEMORY.md, ChatGPT thread history, task lists) as ephemeral session state — do not promote it into the durable sources

## What Stays External

Keep these external unless a project has a deliberate reason to mirror them:

- the grounding note (always external, by design)
- ChatGPT Project instructions (legacy Model A only)
- startup prompts used to frame or hand off work

## What Usually Becomes Repo-Local

Once the repo exists, these are typical local candidates:

- `AGENTS.md` (always)
- `CLAUDE.md` pointer (single-node convenience)
- a project architecture doc
- project-specific entry-point docs

## Practical Output

The normal output of instantiation is not code yet.

It is a ready-to-send next prompt that can:

- create or attach the target repo
- copy and adapt the relevant templates
- begin bootstrap using the agreed project purpose, structure, and operating model
