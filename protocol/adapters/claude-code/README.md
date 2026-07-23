# protocol/adapters/claude-code/ — Claude Code adapter artifacts

The shared execution protocol in `../../AGENTS.shared.md` is **agent-agnostic**: it names structural roles and required dispositions, never a vendor. This namespace holds the **Claude-Code-specific artifacts** that provide runtime enforcement for the supported built-in file-edit and auto-memory write path of one of those rules — §Private-Memory Write Gate — on a machine running Claude Code.

It does **not** claim OS-level enforcement over arbitrary Bash, Python, Node, or other subprocess writes. The shared protocol prohibits that circumvention semantically; subprocess sandbox hardening remains a separate, out-of-scope capability question unless a demonstrated bypass reopens it.

Nothing here is shared-protocol text, and nothing here is inherited by a consumer's `AGENTS.md`. A different executor would carry a sibling namespace with its own artifacts and the same shared rule above it.

```text
native-memory-write-gate.settings.fragment.json  merge-only settings fragment (the native permission rules)
check-claude-adapter.sh                          static owner-repo checks for this namespace + the CLAUDE.md adapter
check-native-memory-gate.py                      machine-local verifier of the installed gate (static class only)
tests/run-adapter-fixtures.sh                    negative fixtures for check-claude-adapter.sh
```

## The settings fragment is merge-only

`native-memory-write-gate.settings.fragment.json` is **never** copied over a settings file. It is semantically merged into `~/.claude/settings.json`, preserving every pre-existing key. Overwriting a live settings file would silently drop hooks, model selection, and status-line configuration that the fragment says nothing about.

Eight `Edit(...)` ask rules cover the private persistent surfaces the shared gate governs:

```text
~/.claude/projects/**/memory/**      auto-memory topic files and MEMORY.md
//**/.claude/agent-memory/**         subagent memory
//**/.claude/agent-memory-local/**   subagent memory (local)
~/.claude/CLAUDE.md                  user-scope instructions
~/.claude/rules/**                   user-scope rules
//**/CLAUDE.local.md                 gitignored repo-local instructions
//**/.claude/settings.json           the gate's own carrier
//**/.claude/settings.local.json     the gate's own carrier (local)
```

A **checked-in** repo `CLAUDE.md` is deliberately absent from that list: it is a visible carrier under ordinary diff and review gates, not a private persistent surface.

The list is a floor, not a ceiling. A `CLAUDE.md` may import an instruction file from an arbitrary absolute or home-relative path, and imports may recurse; such a path is governed by the shared gate and needs its own `Edit(...)` rule before use. Coverage of the actually-loaded set is an **active-session** fact (see below), not something these eight fixed rules can guarantee.

## Path and matching facts

Verified against the Claude Code documentation and a live 2.1.212 build:

- Only `Edit(path)` and `Read(path)` are matched by file permission checks. **On the tested Claude Code 2.1.212 build, path-scoped `Write` rules are accepted but not matched by file permission checks; use `Edit(path)`.** An unmatched rule is reported at startup.
- `//abs` is absolute-from-filesystem-root; `~/` is home-relative; a bare `/path` is relative to the settings file's own source.
- Precedence is deny → ask → allow. A matching **ask** rule prompts regardless of any allow rule in any scope.
- `disableBypassPermissionsMode: "disable"` is defense in depth, not a repair. Explicit ask rules already prompt in `bypassPermissions`; what that mode *does* skip is the protected-path layer, and a security-bearing gate should not rest on a single carve-out.

## Three evidence classes — keep them separate

**1. Static owner-repo checks — `check-claude-adapter.sh`.** Runs against this repository. Proves the fragment parses, carries all eight exact rules and the bypass setting, and that both `CLAUDE.md` adapters import `AGENTS.md` exactly once. No machine state, no session.

**2. Static machine checks — `check-native-memory-gate.py`.** Runs against an installed `settings.json`. Its terminal outcomes are:

```text
STATIC-CONFORMANT / ACTIVE-SESSION-UNVERIFIED
BLOCKED-MISSING-RULE
BLOCKED-UNMATCHED-RULE
BLOCKED-VERSION
```

It **never** emits `ACTIVE-CONFORMANT`. It cannot: `autoMemoryDirectory` is read from any settings scope — user, project, local, policy, or `--settings`, with project and local additionally gated by workspace trust — so a static read of one file cannot establish the effective memory root, and no file inspection can enumerate the instruction imports a session actually loaded.

**3. Active-session receipt — operator evidence.** The classification `ACTIVE-CONFORMANT` is attached by the operator to a receipt combining:

```text
/permissions          every required rule present, with its source scope
/context              every loaded instruction file and recursive import, each classified as
                        checked-in reviewed carrier | managed policy | private path covered by an ask rule
                      no unclassified private instruction path
effective memory root observed, canonicalized, and covered by an ask rule
active mode           acceptable for private persistent-context maintenance
```

An uncovered nondefault memory root or an uncovered private instruction import yields `BLOCKED-UNCOVERED-PRIVATE-PATH`, and the receipt names the exact additional rule required:

```text
Edit(//<canonical-absolute-path>/**)
```

There is deliberately **no `setup-token` prerequisite** for routine verification. Headless authentication carries its own credential-exposure cost; an interactive `/permissions` + `/context` receipt is sufficient and safer.

## What is not proven here

Change-relative facts — that a modified rule gained an `amended_by` entry, that repo-specific `CLAUDE.md` prose survived an adapter insertion, that only authorized consumer paths changed — cannot be deduced from a current tree. They are **base→head propagation evidence**, produced and reviewed at Stage 2. No base-aware checker is implied by this namespace.
