# templates/ — AGENTS carrier authoring

`AGENTS.template.md` is a **payload-free bootstrap shell** for a downstream ASK repo. It does not contain the shared protocol bodies; those live once in `../protocol/AGENTS.shared.md` and are resolved into a consumer carrier by the propagation wave.

## The one resolution model (identical to protocol/README.md)

```text
consumer AGENTS.md  =  resolved shared block   (from protocol/AGENTS.shared.md, verbatim, between BEGIN/END shared markers)
                    +  applicable profiles     (protocol/profiles/*.md fenced body, between BEGIN/END profile markers)
                    +  opt-in fragments        (protocol/fragments/*.md, verbatim, between BEGIN/END grant markers — opt-in only)
                    +  repo-local delta         (between BEGIN/END local-delta markers)
```

All four parts are present in the template as marker pairs so the wave can fill them and `check.sh` can verify each.

## The `CLAUDE.md` adapter

`CLAUDE.template.md` is **required**, not optional, for a Claude-operated repo. Claude Code reads `CLAUDE.md`, not `AGENTS.md`, so its `@AGENTS.md` import is what actually delivers the resolved carrier into an executor's context. Exactly one `@AGENTS.md` import; repo-specific prose may follow it. `../protocol/adapters/claude-code/check-claude-adapter.sh` verifies that.

## Why payload-free

A full protocol copy in the template would be a second independently-maintained payload that drifts from the owner canonical. The template carries only the shell + carrier-selection metadata + the four marker surfaces. `protocol/check.sh --local` fails if the template inlines the shared payload or the grant body.

## Overlays

`overlays/architecture-uncertain-rules.template.md` is the downstream-authoring twin of `protocol/profiles/architecture-uncertain.md`; both carry a `<!-- BEGIN/END profile-body: architecture-uncertain -->` fence and `check.sh` byte-compares the fenced bodies. Keep them in sync (edit together).
