# CLAUDE.md

@AGENTS.md

This repository's workflow rules live in `AGENTS.md`. They apply to Claude Code the same as they apply to any other executor. Follow `AGENTS.md` for branch discipline, scope discipline, plan-before-execute, single-writer discipline, and structured change summaries.

For repo-external context (project intent, audience, philosophy, foundational premises, durable loose threads), read the grounding note maintained outside this repository.

For project state (what this protocol repo currently contains and how the pieces relate), start from `README.md` and `docs/architecture.md`.

## Compact Instructions

Claude Code manages context automatically as the window approaches capacity: it clears older tool outputs first, then summarizes the conversation if needed. If ASK does not compact earlier, automatic compaction is the normal continuation path. ASK may also run `/compact` manually and name a focus to preserve.

**Context pressure alone is not a reason** to stop, recommend a fresh session, write a recap, transfer a program, or ask ASK to choose between threads. The governing rule is `AGENTS.md` §Verification Claims and Evidence Boundaries.

Before any further action after compaction, **affirmatively re-establish** the portable continuity set required by `AGENTS.md` §Verification Claims and Evidence Boundaries — do not wait to notice a gap:

- the current ASK authorization and approved scope;
- explicit non-actions;
- the current gate and intended terminal state;
- exact durable-owner, review-object, PR, and artifact locators, each carrying the load-bearing state identity that makes it reviewable — PR base and head SHA, commit, version, or hash, as applicable. Read mutable owners live at use, reconcile them against that pin, and classify the movement before proceeding; see `AGENTS.md` §Source-of-Truth Boundaries / Aging-Rate Principle;
- unresolved blockers and write-aperture state.

Recovery differs by limb. **ASK authority:** preserve the exact ASK relay or envelope; if it cannot be independently established after compaction, stop and obtain a fresh ASK relay — **never reconstruct authority** from a program row, plan, recap, PR, review object, artifact, or the compaction summary. **State and evidence:** re-read their durable owners. **Mutable objects:** re-verify the load-bearing state identity, since a PR URL without its approved base and head SHA does not preserve the reviewed state. **The compaction summary is continuation context, not an authoritative replacement for those owners.**

**Compaction is not assumed lossless** — detailed instructions from early in the conversation may be lost. If a concrete source or state item is missing afterward, name it and recover it from its durable owner; a missing **authorization** follows the authority rule above instead, not this one. Report an explicit compaction error as the failure it is; never infer one from thread length or workload. Auto-compaction can genuinely fail: when a single oversized file or tool output refills the window after each summary, Claude Code stops retrying and shows an error rather than looping. Avoid unnecessarily loading or emitting any single file or tool output large enough to refill the context immediately after summarization; whole-file dumps are one common cause.

## Shell and Verification Mechanics

The general obligations are `AGENTS.md` §Verification Claims and Evidence Boundaries. This section is the runtime recipe for meeting them through Claude Code's Bash tool, where recorded failures produced wrong evidence while the command still appeared to succeed.

- **Identify the interpreter.** The Bash tool runs commands in the user's shell, which on this workstation is zsh, not bash. Check it with `printf '%s|%s\n' "${ZSH_VERSION:-}" "${BASH_VERSION:-}"` rather than assume. Run a script under a named interpreter (`bash script.sh`, `zsh -f script.zsh`, `python3 -I script.py`) when its semantics matter.
- **Brace a variable that a colon follows.** In zsh, a colon after an unbraced name can start a modifier: `"$task_ref:apex/x"` expands as `"$task_ref:a"`, the absolute path of `$task_ref`, followed by `pex/x`. Write a Git object specification as `"${task_ref}:${task_relpath}"`, or pass `ref:path` as one element of a subprocess argument array. `"${task_ref}:a"` is literal concatenation; `"${task_ref:a}"` is the intentional modifier. A slash starts no modifier, so `"$task_ref/file"` is unaffected.
- **Use task-specific variable names.** Shell-owned names change behavior when assigned. In zsh, `path` is tied to `PATH`, so assigning it can empty the command search path, and `status` is read-only. Prefer names such as `task_ref`, `task_relpath` and `task_out`.
- **Parse structured data from files or captured bytes.** zsh's `echo` interprets backslash escapes, so the `\n` inside a JSON string becomes a raw newline and the document no longer parses. Write the data to a file and parse the file, or emit it with `printf '%s'` when literal shell output is necessary.
- **Prove the intended blob exists before hashing it.** A failed `git cat-file` leaves an empty file, and its SHA-256 (`e3b0c442…`) looks like any other hash. Check `git cat-file -e "${task_ref}:${task_relpath}"`, write the blob to a file, check the exit status, and confirm that `git hash-object` of the file equals `git rev-parse "${task_ref}:${task_relpath}"` before comparing raw bytes.
- **Follow expected redirects and verify where they end.** Without `-L`, a 308 response's body is the redirect, not the page, and curl still exits 0. Use `curl -sS -L --fail -o <file> -w '%{http_code} %{url_effective}'`, and confirm that the final status and the final URL are the expected ones before treating the body as the artifact.
- **A failed retrieval stops the comparison.** Check each retrieval's exit status, and keep a pipeline's failure visible with `set -o pipefail`, which both zsh and bash accept. Empty, missing or stale output is never fresh evidence: the comparison exits nonzero instead of running against it.
