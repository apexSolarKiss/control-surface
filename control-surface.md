# control-surface.md

This file is the canonical reusable external control-surface artifact published by `control-surface` for ASK projects.

## Roles

- Decision-maker: chooses goals, boundaries, and approval points
- ChatGPT: acts as prompt compiler and control surface, helping shape instructions, constraints, and review framing
- Codex: executes inside the attached local repo, verifies state, reads repo truth, makes changes, and reports results

The control surface should decide what work is being asked for. Codex should execute against local repo truth rather than inventing repo policy.

## Intended Use

Use this artifact as the external orchestration layer around a target ASK repo.

It is intentionally outside the repo it governs, even if a project chooses to store a copy locally for convenience.

## Boundary Model

Keep a clear separation between:

- external control-surface rules in this document
- repo-local execution rules in the target repo's `AGENTS.md`
- runnable startup prompts used to attach ChatGPT or Codex
- explanatory docs that describe the workflow system
- examples that show how a project maps onto the model

Those categories are related, but they are not interchangeable.

## Repo Attachment Defaults

- expected local repo root: `[absolute local repo root]`
- canonical GitHub repo: `[owner/name]`
- default base branch: `[branch]`
- repo entry points to read first: `[README.md, AGENTS.md, docs/... ]`
- protected paths or constraints: `[constraints]`

## Execution Defaults

- verify repo attachment before meaningful work
- stop on mismatch
- report the exact working directory, git toplevel, origin remote URL, current branch, and working-tree state
- read repo-local files first after verification
- treat repo-local files as the source of truth for work inside the attached repo

## Phase Guidance

### Planning

- clarify goal, scope, constraints, and deliverable format
- prefer the smallest honest scaffold or change
- do not treat templates or examples as live policy unless the task explicitly says so
- identify which repo-local files are authoritative before proposing changes

### Implementation

- branch from the current base when the workflow calls for implementation
- keep changes scoped to one coherent intent
- show the exact diff and resulting repo state before final handoff when requested
- package the task so Codex knows the exact files, constraints, and expected verification output

### Review And Handoff

- keep durable repo truth in repo files
- keep migration framing and review context in the PR
- keep comments for local clarification rather than policy storage
- state whether the handoff is planning-only, implementation, review, or PR-stage

## Handoff Packaging

When sending work to Codex, package:

- repo root, canonical repo, and base branch
- task goal and success criteria
- exact files or artifact classes to inspect
- explicit constraints, protected paths, or out-of-scope areas
- expected diff, verification, and PR-stage output

## Adaptation Notes

Adapt this artifact by filling the repo attachment defaults first, then replacing the project slots with repo-specific constraints and response expectations.

Keep repo-local execution rules in the target repo, and keep this artifact focused on external orchestration and handoff quality.

## Project Slots

Fill or adapt these project-specific fields when using this artifact:

- project-specific defaults: `[defaults]`
- protected paths or constraints: `[constraints]`
- required verification steps: `[checks]`
- preferred response format: `[format]`
