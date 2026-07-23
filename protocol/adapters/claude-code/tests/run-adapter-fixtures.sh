#!/usr/bin/env bash
# protocol/adapters/claude-code/tests/run-adapter-fixtures.sh
# Fixtures for the Claude Code adapter checks. NO hardcoded workspace paths; builds temporary owner copies.
# Requires: python3.
#
# Usage:  bash protocol/adapters/claude-code/tests/run-adapter-fixtures.sh [OUTPUT_REPORT.md]
#   OUTPUT_REPORT.md  optional path for the run report (PR/ecology evidence; NOT committed here).
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$HERE/../../../.." && pwd)"
WORK="$(mktemp -d "${TMPDIR:-/tmp}/cs-adapter-fixtures.XXXXXX")"
OUT="${1:-$WORK/ADAPTER-FIXTURE-RESULTS.md}"
trap 'rm -rf "$WORK"' EXIT

command -v python3 >/dev/null 2>&1 || { echo "MISSING DEP: python3"; exit 2; }

ADAPTER_REL="protocol/adapters/claude-code"
CHECK="$REPO/$ADAPTER_REL/check-claude-adapter.sh"
VERIFY="$REPO/$ADAPTER_REL/check-native-memory-gate.py"
FRAG_REL="$ADAPTER_REL/native-memory-write-gate.settings.fragment.json"

# a minimal owner copy: only the surfaces check-claude-adapter.sh reads
owner_copy(){
  local d="$WORK/$1"; rm -rf "$d"; mkdir -p "$d/templates" "$d/$ADAPTER_REL"
  cp "$REPO/CLAUDE.md" "$d/CLAUDE.md"
  cp "$REPO/templates/CLAUDE.template.md" "$d/templates/CLAUDE.template.md"
  cp "$REPO/$FRAG_REL" "$d/$FRAG_REL"
  echo "$d"
}
jsonpatch(){ python3 - "$1" "$2" <<'PY'
import json,sys
p,expr=sys.argv[1],sys.argv[2]
d=json.load(open(p)); exec(expr,{"d":d})
json.dump(d,open(p,"w"),indent=2)
PY
}

{ echo "# claude-code adapter — reproducible fixture results"; echo;
  echo "Static owner-repo checks + machine verifier outcome states. Fixtures are temporary; no workspace paths.";
  echo; echo "| fixture | exit | want | expected diagnostic | result |"; echo "|---|---|---|---|---|"; } > "$OUT"
PASSES=0; FAILS=0
record(){ # desc expect_rc expect_diag cmd...
  local desc="$1" erc="$2" ediag="$3"; shift 3
  local o rc; o=$("$@" 2>&1); rc=$?
  local hit="n/a"; [ -n "$ediag" ] && { echo "$o" | grep -qF "$ediag" && hit="found" || hit="MISSING"; }
  local pass="FAIL"; { [ "$rc" = "$erc" ] && { [ -z "$ediag" ] || [ "$hit" = "found" ]; }; } && pass="PASS"
  [ "$pass" = "PASS" ] && PASSES=$((PASSES+1)) || FAILS=$((FAILS+1))
  printf "| %-52s | %s | %s | %s | %s |\n" "$desc" "$rc" "$erc" "${ediag:-—}" "$pass" >> "$OUT"
  printf "  %-52s rc=%s(want %s) diag=%s -> %s\n" "$desc" "$rc" "$erc" "$hit" "$pass"
}
runcheck(){ bash "$CHECK" --root "$1"; }

# ---------- static owner-repo checks ----------
record "POS adapter checks on the live owner repo" 0 "ALL CHECKS PASSED" runcheck "$REPO"

d=$(owner_copy A1); perl -0pi -e 's/^\@AGENTS\.md\n\n//m' "$d/templates/CLAUDE.template.md"
record "NEG template missing @AGENTS.md" 1 "occurs 0 time(s)" runcheck "$d"

d=$(owner_copy A2); perl -0pi -e 's/^(\@AGENTS\.md)$/$1\n\n\@AGENTS.md/m' "$d/templates/CLAUDE.template.md"
record "NEG template duplicate @AGENTS.md" 1 "occurs 2 time(s)" runcheck "$d"

d=$(owner_copy A3); perl -0pi -e 's/^\@AGENTS\.md\n\n//m' "$d/CLAUDE.md"
record "NEG owner CLAUDE.md missing @AGENTS.md" 1 "occurs 0 time(s)" runcheck "$d"

d=$(owner_copy A4); rm -f "$d/CLAUDE.md"
record "NEG owner CLAUDE.md absent" 1 "owner CLAUDE.md missing" runcheck "$d"

d=$(owner_copy A5); perl -0pi -e 's/^(\@AGENTS\.md)$/see $1 for the rules/m' "$d/CLAUDE.md"
record "NEG @AGENTS.md present but not an import line" 1 "not a standalone import line" runcheck "$d"

d=$(owner_copy A6); jsonpatch "$d/$FRAG_REL" 'd["permissions"]["ask"].remove("Edit(//**/CLAUDE.local.md)")'
record "NEG fragment missing one required ask rule" 1 "missing 1 of 8" runcheck "$d"

d=$(owner_copy A7); jsonpatch "$d/$FRAG_REL" 'd["permissions"]["ask"].append("Write(//**/CLAUDE.local.md)")'
record "NEG fragment carries an unmatchable Write(...) rule" 1 "unmatchable Write(...) rule" runcheck "$d"

d=$(owner_copy A8); jsonpatch "$d/$FRAG_REL" 'd["permissions"]["disableBypassPermissionsMode"]="allow"'
record "NEG disableBypassPermissionsMode != disable" 1 "disableBypassPermissionsMode" runcheck "$d"

d=$(owner_copy A9); printf '{ not json' > "$d/$FRAG_REL"
record "NEG fragment malformed JSON" 1 "does not parse" runcheck "$d"

d=$(owner_copy A10); rm -f "$d/$FRAG_REL"
record "NEG fragment absent" 1 "settings fragment missing" runcheck "$d"

# ---------- machine verifier: outcome states ----------
GOOD="$WORK/settings-good.json"
python3 - "$REPO/$FRAG_REL" "$GOOD" <<'PY'
import json,sys
frag=json.load(open(sys.argv[1]))
# a realistic installed settings file: the fragment merged into unrelated pre-existing keys
out={"model":"opusplan","inputNeededNotifEnabled":True,"permissions":frag["permissions"]}
json.dump(out,open(sys.argv[2],"w"),indent=2)
PY
CLEANLOG="$WORK/startup-clean.log"; printf 'Claude Code started.\nno warnings\n' > "$CLEANLOG"
WARNLOG="$WORK/startup-warn.log";   printf 'Warning: permission rule Write(~/x) will never match\n' > "$WARNLOG"

v(){ python3 "$VERIFY" --fragment "$REPO/$FRAG_REL" "$@"; }

record "POS verifier: conformant static installation" 0 "STATIC-CONFORMANT / ACTIVE-SESSION-UNVERIFIED" \
  v --settings "$GOOD" --version 2.1.212 --startup-log "$CLEANLOG"

# the correction this fixture exists to hold: a file inspection must never claim an active session
record "POS verifier never emits ACTIVE-CONFORMANT" 0 "" bash -c \
  'out=$(python3 "'"$VERIFY"'" --fragment "'"$REPO/$FRAG_REL"'" --settings "'"$GOOD"'" --version 2.1.212 --startup-log "'"$CLEANLOG"'"); \
   printf "%s\n" "$out" | grep -q "^VERDICT: ACTIVE-CONFORMANT" && exit 1 || exit 0'

MISS="$WORK/settings-missing.json"
python3 - "$GOOD" "$MISS" <<'PY'
import json,sys
d=json.load(open(sys.argv[1])); d["permissions"]["ask"].remove("Edit(~/.claude/rules/**)")
json.dump(d,open(sys.argv[2],"w"),indent=2)
PY
record "NEG verifier: installed settings missing a rule" 1 "BLOCKED-MISSING-RULE" \
  v --settings "$MISS" --version 2.1.212 --startup-log "$CLEANLOG"

record "NEG verifier: runtime below tested floor" 1 "BLOCKED-VERSION" \
  v --settings "$GOOD" --version 2.1.100 --startup-log "$CLEANLOG"

record "NEG verifier: version undetermined (fail closed)" 1 "BLOCKED-VERSION" \
  v --settings "$GOOD" --version "no-version-here" --startup-log "$CLEANLOG"

record "NEG verifier: unmatched-rule warning at startup" 1 "BLOCKED-UNMATCHED-RULE" \
  v --settings "$GOOD" --version 2.1.212 --startup-log "$WARNLOG"

record "NEG verifier: settings file absent" 1 "BLOCKED-MISSING-RULE" \
  v --settings "$WORK/nope.json" --version 2.1.212

echo; echo "=== $OUT ==="; cat "$OUT"
echo; echo "PASS=$PASSES  FAIL=$FAILS"
[ "$FAILS" -eq 0 ]
