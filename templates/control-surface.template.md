# Control-Surface Template

Use this as a starter for the external control-surface document for a downstream ASK project.

This template is for the orchestration layer around a repo. It is not a repo-local file by default.

## Repo Attachment Defaults

- expected local repo root: `[absolute local repo root]`
- canonical GitHub repo: `[owner/name]`
- default base branch: `[branch]`

## Roles

- decision-maker: `[who sets goals and approves tradeoffs]`
- ChatGPT: prompt compiler and control surface
- Codex: local executor inside the attached repo

## Project Defaults

Fill in the local defaults that should shape execution:

- preferred level of autonomy: `[default]`
- branch naming expectations: `[default]`
- verification expectations: `[tests, diffs, screenshots, etc.]`
- protected areas or sensitive paths: `[paths or topics]`
- preferred communication style: `[brief, detailed, review-first, etc.]`

## Phase-Specific Behavior

### Verification Phase

- require repo attachment verification before meaningful work: `[yes/no]`
- required commands: `[commands to run first]`
- stop conditions on mismatch: `[what must match exactly]`

### Planning Phase

- how plans should be structured: `[format]`
- when to ask versus assume: `[policy]`
- what should be considered in scope or out of scope: `[policy]`

### Implementation Phase

- branch workflow: `[how to branch and sync]`
- edit constraints: `[how narrow to keep changes]`
- verification before handoff: `[what must be shown]`

## Repo-Local Truth Rule

When attached to a repo:

- read live repo files first
- treat repo-local operating docs as the source of truth for execution
- do not let this external template override explicit local repo instructions unless the user explicitly directs it

## Task Framing Slots

Use or fill these slots per task:

- task goal: `[goal]`
- success criteria: `[what counts as done]`
- explicit constraints: `[constraints]`
- required deliverable format: `[format]`
