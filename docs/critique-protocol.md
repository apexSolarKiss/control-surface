# Critique protocol

How a fresh-context critique of a repo or the ecology is instantiated, and how the advisor surface that produces one is bootstrapped. This doc governs *instantiation mechanics*; the critique prompts themselves (`prompts/repo-critique-*`, `prompts/ecology-critique-*`) govern *what to read and assess*.

## Two kinds of entry prompt

There are two distinct kinds of prompt, and conflating them is a launch misfire:

- **Read-reliably prompts** set up *how a surface reads* before it does anything — the advisor bootstrap (advisor role + fail-closed connector read-path discipline) and the working-session bootstrap (`prompts/claude-code-initial-prompt.md`).
- **Read-and-assess prompts** set up *what to read and what to judge* — the critique prompts.

A critique takes a read-and-assess prompt **directly**. The read-reliably setup either is already true by construction (a filesystem executor) or is installed **once at the project level** (a connector advisor) — never re-pasted per invocation ahead of the critique prompt.

## Advisor bootstrap lives in the GPT Project's Instructions

A GPT advisor surface is bootstrapped by the **GPT Project's Instructions**, not by pasting an advisor prompt into each thread. The advisor role + fail-closed read-path discipline is installed once at the Project-Instructions level; `templates/advisor-project-instructions.template.md` is the copyable master for that text.

**Why once at the project level, not per thread:** re-pasting the advisor prompt into a Project that already holds a prior version in its thread history makes the model *review the revision* instead of *adopt the role* — a launch misfire that Project Instructions sidestep. The advisor discipline (role + fail-closed connector read-path) is the durable asset; this is a relocation of *where* it lives, not a change to *what* it says.

The former per-thread paste (`advisor-initial-prompt`) is deprecated in favor of this. The template file is retained and repointed as the Project-Instructions master.

## Fresh-context critique: two instantiation mechanics, one per executor type

"Fresh context" is achieved differently on each side, and **both skip any per-invocation bootstrap paste and take the critique prompt directly**:

- **Claude executor side** — the critique runs as a **subagent** (fresh context via the Agent tool) spawned from the persistent main control-surface Claude thread. The main thread is *compacted over time* to manage its context window — not replaced by a fresh thread. The subagent has filesystem access, so it reads reliably by construction and takes the critique prompt directly. It does **not** stack the working-session bootstrap.
- **GPT advisor side** — the critique runs as a **fresh thread inside a separate, empty mirror GPT project** carrying **identical mounted Sources + Project Instructions** to the working project but holding no other threads. The empty mirror project is what guarantees a genuinely fresh advisor thread: a fresh thread inside the working project would still inherit that project's conversation history ambiently. The Project Instructions carry the advisor bootstrap, so the fresh thread takes the critique prompt directly too.

**The unifying rule:** a **filesystem executor** (Claude subagent) reads reliably by construction → straight to the critique prompt; a **connector advisor** (GPT) needs read-path calibration → installed once at the Project-Instructions level, not re-pasted per thread → then straight to the critique prompt. "Fresh context" = a spawned subagent on the Claude side, an empty-mirror-project fresh thread on the GPT side.

## The session-start prompt is not critique instantiation

`prompts/claude-code-initial-prompt.md` is a **working-session bootstrap** — "you are about to *operate* on this repo: orient and await direction." It is scoped to one repo and ends by awaiting direction. It is **not** stacked before a critique: doing so mis-scopes a system- or repo-wide critique to a single working repo and stalls it on "await direction." A working session may open with it; a critique subagent does not.

## Coverage band — declare it first

A critique — especially an ecology critique — asks for a large surface area. Without a declared band, successive passes drift toward coverage-theater (implying total coverage while sampling). Every critique **opens by declaring the band it actually covers**, for example:

```
band: core ecology (control-surface · method-ASK · design-system-ASK · ASK front door)
      + publication/propagation drift; downstream deep-state excluded except AP/UO front doors
```

The band is an honesty instrument: it states what was and was not in scope, so a reader never mistakes a scoped pass for an exhaustive one.

## Package availability — non-repo surfaces are conditional on the reader

Some critique inputs are not repo files: the operator-side diagram packages (D03 topology, D04 wall/grant boundary), the live `A-S-K.studio` render, the operator-side trackers and source-of-intent masters. Whether these are readable **depends on the surface running the critique**:

- a **filesystem executor** (Claude subagent) reads them directly from disk;
- a **connector advisor** (GPT) reads them through whatever connectors the surface exposes: with a **Dropbox connector**, it can **search/fetch the operator-side source directly** (`VERSION.md`, `*.html`, `*.source.js`, scratch, root-canonicals) from the named `*-EXTERNAL/` path; without one, the source must be **mounted into the advisor Project's Sources** or uploaded.

So the rule is: **the connector advisor fetches the package source directly when a Dropbox connector is available; otherwise mount/upload it — and if neither reaches it, the advisor declares that leg "not reviewed."** A critique never claims to have reviewed a surface it could not read — the same read-path honesty required for repo files and PRs. Connector access is a read path, not a status change (a fetched scratch file stays scratch), and never browses private personal roots unless ASK names the exact path — see the read-path + wall guard in `templates/advisor-project-instructions.template.md`.

**Consequence:** do **not** remount operator-side canonicals into the advisor Project's Sources by default. Where the connector exists, Dropbox is the **preferred live read path** for operator-side canonicals (mounted Sources are for bootstrap / fallback / connector-failure resilience, not routine canonical mirroring). Mounting a package source is the exception — for a critique whose package Dropbox cannot reach or whose path is ambiguous.

## Related

- `prompts/repo-critique-initial-prompt.md` · `prompts/ecology-critique-initial-prompt.md` — what to read and assess (single repo · whole ecology).
- `prompts/repo-critique-synthesis-prompt.md` · `prompts/ecology-critique-synthesis-prompt.md` — fold a second independent critique into an advisory plan.
- `prompts/repo-critique-execution-prompt.md` · `prompts/ecology-critique-execution-prompt.md` — hand the plan back to the execution surface for scoped implementation.
- `templates/advisor-project-instructions.template.md` — the advisor bootstrap master installed once into a GPT Project's Instructions.
- `prompts/claude-code-initial-prompt.md` — the working-session bootstrap (distinct from critique instantiation).
