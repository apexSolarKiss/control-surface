#!/usr/bin/env bash
# protocol/adapters/claude-code/check-claude-adapter.sh
# Static OWNER-REPO checks for the Claude Code adapter. Deterministic, fail-closed, NO CI, no machine state, no session.
# Deliberately separate from protocol/check.sh: the portable AGENTS checker stays agent-agnostic.
#
# Usage: bash protocol/adapters/claude-code/check-claude-adapter.sh [--root <repo-root>]
# Exit 0 ONLY if every assertion passes. Any FAIL / missing input / missing dep => exit 1.
#
# NOT proven here (base->head propagation evidence, produced at Stage 2):
#   amended_by present on every modified rule · repo-specific CLAUDE.md prose preserved · only authorized paths changed
set -u -o pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../../.." && pwd)"
[ "${1:-}" = "--root" ] && { ROOT="$(cd "${2:?--root needs a path}" && pwd)"; }
FRAGMENT="$ROOT/protocol/adapters/claude-code/native-memory-write-gate.settings.fragment.json"
TEMPLATE="$ROOT/templates/CLAUDE.template.md"
OWNER_ADAPTER="$ROOT/CLAUDE.md"
fail=0
FAIL(){ printf 'FAIL : %s\n' "$*"; fail=1; }; OKAY(){ printf 'ok   : %s\n' "$*"; }

command -v python3 >/dev/null 2>&1 || { FAIL "python3 required, not found"; exit 1; }

# ---- exactly-one @AGENTS.md import, counted as OCCURRENCES and required to be a standalone import line ----
check_import(){ # label file
  local label="$1" f="$2"
  [ -f "$f" ] || { FAIL "$label missing: ${f#$ROOT/}"; return; }
  local out; out=$(python3 - "$f" <<'PY'
import sys,re
t=open(sys.argv[1]).read()
occ=t.count("@AGENTS.md")
standalone=len([l for l in t.splitlines() if l.strip()=="@AGENTS.md"])
print(f"{occ} {standalone}")
PY
)
  local occ standalone; occ=${out% *}; standalone=${out#* }
  [ "$occ" = "1" ] || { FAIL "$label: @AGENTS.md occurs $occ time(s), want exactly 1"; return; }
  [ "$standalone" = "1" ] && OKAY "$label carries exactly one @AGENTS.md import" \
    || FAIL "$label: the single @AGENTS.md occurrence is not a standalone import line"
}

check_import "templates/CLAUDE.template.md" "$TEMPLATE"
check_import "owner CLAUDE.md"              "$OWNER_ADAPTER"

# ---- settings fragment: parses, carries all eight exact ask rules, disables bypass mode ----
if [ ! -f "$FRAGMENT" ]; then
  FAIL "settings fragment missing: ${FRAGMENT#$ROOT/}"
else
  frag_out=$(python3 - "$FRAGMENT" <<'PY'
import sys, json
REQUIRED = [
    "Edit(~/.claude/projects/**/memory/**)",
    "Edit(//**/.claude/agent-memory/**)",
    "Edit(//**/.claude/agent-memory-local/**)",
    "Edit(~/.claude/CLAUDE.md)",
    "Edit(~/.claude/rules/**)",
    "Edit(//**/CLAUDE.local.md)",
    "Edit(//**/.claude/settings.json)",
    "Edit(//**/.claude/settings.local.json)",
]
try:
    d = json.load(open(sys.argv[1]))
except Exception as e:
    print("PARSE|%s" % e); raise SystemExit(0)
print("PARSE|ok")
perms = d.get("permissions")
if not isinstance(perms, dict):
    print("ASK|no permissions object"); print("BYPASS|no permissions object"); raise SystemExit(0)
ask = perms.get("ask")
if not isinstance(ask, list):
    print("ASK|permissions.ask is not a list")
else:
    missing = [r for r in REQUIRED if r not in ask]
    # a Write(...) rule would be accepted by the runtime but never matched by a file permission check
    writes = [r for r in ask if r.startswith("Write(")]
    if missing:
        print("ASK|missing %d of 8: %s" % (len(missing), ", ".join(missing)))
    elif writes:
        print("ASK|unmatchable Write(...) rule(s) present: %s" % ", ".join(writes))
    else:
        print("ASK|ok")
b = perms.get("disableBypassPermissionsMode")
print("BYPASS|%s" % ("ok" if b == "disable" else "is %r, want 'disable'" % (b,)))
PY
)
  frag_parse=$(printf '%s\n' "$frag_out" | sed -n 's/^PARSE|//p')
  frag_ask=$(printf '%s\n'   "$frag_out" | sed -n 's/^ASK|//p')
  frag_byp=$(printf '%s\n'   "$frag_out" | sed -n 's/^BYPASS|//p')
  [ "$frag_parse" = "ok" ] && OKAY "settings fragment parses as JSON" || FAIL "settings fragment does not parse: $frag_parse"
  if [ "$frag_parse" = "ok" ]; then
    [ "$frag_ask" = "ok" ] && OKAY "settings fragment carries all eight exact ask rules" || FAIL "settings fragment ask rules: ${frag_ask:-absent}"
    [ "$frag_byp" = "ok" ] && OKAY "disableBypassPermissionsMode == \"disable\"" || FAIL "disableBypassPermissionsMode ${frag_byp:-absent}"
  fi
fi

[ "$fail" -eq 0 ] && { printf 'ALL CHECKS PASSED (claude-code adapter, static owner-repo)\n'; exit 0; } \
                  || { printf 'CHECKS FAILED (claude-code adapter, static owner-repo)\n'; exit 1; }
