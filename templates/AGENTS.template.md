# AGENTS Template

Use this as a starter for `AGENTS.md` in a downstream ASK repo.

## Repo Purpose

Describe the repo in 2 to 4 lines:

- what the repo owns
- what it does not own
- what kind of work agents should expect here

## Entry Points

List the files or directories an agent should read first:

1. `README.md`
2. `[primary architecture doc]`
3. `[repo-specific operating doc]`
4. `[key app or package paths]`

## Working Style

- Prefer the smallest coherent change.
- Read live repo files before making assumptions.
- Match the repo's architecture and naming conventions.
- Avoid unrelated cleanup unless explicitly requested.

## Scope Discipline

- Keep changes aligned to the task at hand.
- Separate durable repo docs from temporary migration notes.
- Avoid introducing new tooling or structure without a clear repo need.

## Comments, Docs, And PR Boundary

- Put inline explanation in code or config only when local clarity needs it.
- Put durable architecture or workflow guidance in repo docs.
- Put change motivation, rollout notes, and reviewer framing in the PR.

## Branch And PR Discipline

- Branch from `[default base branch]` unless instructed otherwise.
- Keep PRs small enough to review in one pass.
- Stage only files related to the task.
- Verify the scoped diff before asking for review.

## Project-Specific Defaults

Fill in local expectations here:

- testing or verification commands
- protected paths or high-risk areas
- terminology to preserve
- project-specific approval boundaries
