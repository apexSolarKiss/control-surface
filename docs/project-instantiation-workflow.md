# Project Instantiation Workflow

This doc explains the workflow before a target ASK repo exists, and how that upstream phase transitions into normal control-surface usage.

## Phases

### 1. Instantiation

Use this phase when the ChatGPT Project and source pack are instantiated before the target repo exists.

During instantiation:

- read the Project source pack first
- use `apexSolarKiss/control-surface` as the master reference repo
- use `apexSolarKiss/mazeASK` as the worked example
- refine project purpose, repo name, repo description, and initial structure
- decide which assets should remain external versus which should eventually live in the repo

At this point, there is no repo-local truth yet because the target repo does not exist.

### 2. Bootstrap

Use this phase once the target repo exists and the first repo-local files can be established.

During bootstrap:

- verify the new repo attachment
- identify the first repo-local entry points
- decide which starter docs from `templates/` should be adopted
- establish the initial boundary between repo-local files and external control-surface artifacts

This is the phase where repo-local truth begins to exist.

### 3. Operational

Use this phase once the target repo has active repo-local docs and normal work can proceed through the external control surface.

During operational use:

- treat repo-local files as the source of truth for work inside the repo
- use the external control-surface artifact to package work for Codex
- use prompts for startup or handoff, not as permanent repo policy

## What Stays External

Keep these external unless a project has a deliberate reason to mirror them:

- the control-surface artifact
- ChatGPT Project instructions
- startup prompts used to frame or hand off work

## What Usually Becomes Repo-Local

Once the repo exists, these are typical local candidates:

- `AGENTS.md`
- a workflow-boundary doc
- an architecture doc
- project-specific entry-point docs

## Practical Output

The normal output of instantiation is not code yet.

It is a ready-to-send next prompt that can:

- create or attach the target repo
- establish the initial repo-local docs
- begin bootstrap using the agreed project purpose and structure
