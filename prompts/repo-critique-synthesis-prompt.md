# Repo Critique Synthesis Prompt

Use this prompt to fold another independent fresh-context critique into the critique just produced above and produce an advisory plan.

Following or attached is another independent critique of `<project>` produced by a separate fresh-context thread.

1. Consider and fold it into your above critique.
2. Make an advisory plan to address the issues that survive synthesis.

**Carry through any second-lens findings.** If either critique surfaced relationship-scope / language-governance observations — terms that mis-scope a relationship or silently flatten a distinction — fold them into the synthesis at that altitude; do not drop them as wording nits. Preserve each with its **decision owner** (executor wording fix · advisor-review issue · ASK source-of-intent call).

## Delivery

Open with a `By:` line stating who produced this synthesis (e.g. `By: claude-code`), in both the reply and the saved file — the **`<source>` token is required** so a Claude synthesis and an advisor synthesis can be told apart. This `<source>` token is a critique-cycle disambiguator, not a default model/source suffix for handoffs or other artifact classes.

Deliver the synthesis (the folded critique + advisory plan) in two forms:

1. **In reply** — the full synthesis inline in your response.
2. **As a saved Markdown artifact** — the same synthesis as a standalone `.md` file:
   - **If you can write files** (a file-capable executor, e.g. Claude Code): save it into the repo's operator-side scratch, `<repo>-EXTERNAL/scratch/`.
   - **If you cannot save directly** (a save-blocked advisor): emit it as a downloadable `.md` file, same filename, for the operator to place there.

Name the file per the protocol below (consistent with ASK's file-naming conventions in the context-architecture ADR every surface carries in context):

`YYYY-MM-DD_<repo>_repo-critique-synthesis-<source>[-rN].md`

- `<source>` — `claude-code` / `advisor-gpt` / `advisor-claude`.
- example: `2026-06-07_urban-observatory_repo-critique-synthesis-advisor-gpt.md`

## Other independent critique to fold in

Paste or attach the other critique below.
