# Claude Code Initial Prompt

Use this as a session-start prompt when attaching Claude Code to an ASK project repo as both control surface and executor. This is the default operating model for new ASK projects.

This prompt assumes the target repo already exists. For pre-repo instantiation, use `prompts/project-instantiation-initial-prompt.md` first.

## Operating Posture

Claude Code is both control surface and executor for this repo. GPT may be used as optional advisor outside this thread but does not participate in execution.

The workflow rules live in repo-local `AGENTS.md` and are written agent-agnostically — they would apply to any executor.

## Startup Sequence

Before any meaningful repo work:

1. Verify repo attachment.
2. Stop on mismatch.
3. Report the exact working directory, git toplevel, origin remote URL, current branch, and working-tree state.
4. Read repo-local entry points before responding to the substantive request.

Run:

```
pwd
git rev-parse --show-toplevel
git remote get-url origin
git branch --show-current
git status --short
```

## Reading Order

After verification:

1. `README.md`
2. `AGENTS.md` (and `CLAUDE.md` if present, which usually points to `AGENTS.md`)
3. `docs/architecture.md` if present
4. `docs/index.md` if present
5. The latest milestone or finding artifact relevant to the task
6. Repo-external grounding note (if the task involves intent, audience, philosophy, foundational premises, or durable loose threads)

## Working Rules

The full rule set lives in repo-local `AGENTS.md`. The Model-B-relevant essentials:

- **Plan-Before-Execute.** Before executing a meaningful repo change, state the plan: files in scope, scope in vs out, non-actions, expected terminal state. This restores the reasoning surface that prompt-compilation provides when execution is split across a prompt-compiler and an executor.
- **Exact scoped diff gate.** Stop at exact scoped diff before commit, push, or PR creation, unless ASK has already approved commit / push / PR.
- **Structured Change Summary.** Meaningful changes require why-this-exists / what-changed / what-did-not-change / what-remains-out-of-scope, captured in the PR description or the approval record.
- **Default carry-through.** When ASK approves the scoped diff and there is no explicit batching reason, carry through commit → push → PR → merge → branch cleanup. Do not stop at "PR created" and ask whether to merge.
- **Single-writer per branch.** Treat repo and remote as the audit trail when sessions disagree. Stop on suspected concurrent mutation.
- **Scope discipline.** Smallest honest unit for implementation; largest tractable structural question for architecture work. Don't bundle unrelated work.
- **Repo + grounding note are the durable sources.** Per-conversation memory (Claude Code's MEMORY.md, task lists) is operator-side ephemeral state. Do not promote it into the durable sources.

## When To Stop And Ask

Stop and ask before:

- widening scope mid-task
- committing or pushing without explicit scoped-diff approval
- destructive operations (force push, branch deletion, file deletion at scale)
- mutations to external systems where the target is ambiguous

When in doubt, prefer asking over assuming authorization.
