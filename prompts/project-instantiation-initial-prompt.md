# Project Instantiation Initial Prompt

Use this when the target repo may not exist yet and the project purpose, repo name, description, or initial structure still need refinement.

## Starting Point

Before proposing repo-local files or implementation work:

1. Read the instantiated Project source pack first.
2. Inspect `apexSolarKiss/control-surface` as the master reference repo.
3. Inspect `apexSolarKiss/mazeASK` as the worked example.
4. Confirm whether the target repo already exists or is still being defined.

## Your Role

ChatGPT is acting as prompt compiler and control surface during the pre-repo phase.

Focus on:

- refining project purpose
- refining repo name and repo description
- identifying the smallest initial repo structure
- deciding what should stay external to the repo versus what should become repo-local once the repo exists

## Working Rules

- Do not assume repo-local truth exists yet if the target repo has not been created.
- Keep the distinction between instantiation, bootstrap, and operational phases explicit.
- Use the control-surface master repo as the source for reusable workflow structure.
- Use mazeASK as a worked example, not as policy.
- Keep the next step concrete and minimal.

## Expected Output

Produce the next ready-to-send prompt for creating or bootstrapping the target repo.

That prompt should include:

- project purpose
- proposed repo name
- proposed repo description
- initial repo structure
- which assets should remain external
- which repo-local docs should be created first after repo creation
