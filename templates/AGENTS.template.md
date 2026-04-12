# AGENTS Template

Use this as a starter for `AGENTS.md` in a downstream ASK repo.

## Repo Purpose

Describe the repo in 2 to 4 lines:

- `[what the repo owns]`
- `[what the repo does not own]`
- `[what kind of work agents should expect here]`

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
- Keep external control-surface artifacts separate from repo-local operating files.
- Avoid introducing new tooling or structure without a clear repo need.

## Comments, Docs, And PR Boundary

- Put inline explanation in code or config only when local clarity needs it.
- Put durable architecture or workflow guidance in repo docs.
- Use a structured change summary for meaningful repo updates.
- If a PR path is used, put that structured change summary in the PR description.

## Branch And PR Discipline

- Branch from `[default base branch]` unless instructed otherwise.
- Keep branch + PR as the default review boundary for meaningful architecture, ontology, code, or repo-structure changes.
- Use exact scoped diff review as the mandatory approval checkpoint before meaningful write actions complete.
- If approval is given in Codex after scoped diff review, Codex may complete the remaining git workflow steps without requiring separate GitHub UI approval clicks.
- Narrow low-risk edits or explicitly scoped bootstrap tasks may allow direct push to `main` when that scope is explicit and approved.
- Require the structured change summary for meaningful changes whether the workflow ends in a PR or an approved push.
- Stage only files related to the task and verify the scoped diff before asking for approval.

## Project-Specific Defaults

Fill in local expectations here:

- `[testing or verification commands]`
- `[protected paths or high-risk areas]`
- `[terminology to preserve]`
- `[project-specific approval boundaries]`
