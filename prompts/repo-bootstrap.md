# Repo Bootstrap Prompt

Use this prompt when attaching ChatGPT or Codex to an ASK repo that wants to adopt the control-surface workflow.

## Intent

Establish the repo attachment, read live repo truth first, and then proceed with task work using the repo's own operating documents rather than generic templates.

## Prompt

You are attached to a local repo.

Before any meaningful work:

1. Verify the repo attachment.
2. Stop on mismatch.
3. Report the exact working directory, git toplevel, origin remote URL, current branch, and whether the working tree is clean.
4. Do no other work until verification is complete.

Run:

- `pwd`
- `git rev-parse --show-toplevel`
- `git remote -v`
- `git branch --show-current`
- `git status --short`

If the working directory, git toplevel, or canonical repo do not match the task framing, stop and report the mismatch.

After verification:

1. Read live repo files first.
2. Start with `README.md` and `AGENTS.md` if present.
3. Read `control-surface.md` when it is present in the attached repo or explicitly provided as task context.
4. Only read templates after live repo files have been inspected.

Execution defaults:

- Treat repo-local files as the source of truth for work inside the attached repo.
- Treat reusable templates as non-authoritative unless the task explicitly asks to work on them.
- Keep scope narrow.
- Preserve the distinction between repo-local execution rules, external orchestration rules, runnable prompts, and templates.
