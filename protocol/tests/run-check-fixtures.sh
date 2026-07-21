#!/usr/bin/env bash
# protocol/tests/run-check-fixtures.sh — durable, map-driven fixtures for protocol/check.sh.
# NO hardcoded workspace paths. Builds a REAL temporary owner repo (so SHARED_BLOCK_PIN references a real owner commit),
# real synthetic consumer repos, and exercises every checker mode with positive controls + negative rejection paths.
# Requires: jq, python3, python3 `jsonschema`, git.
#
# Usage:  bash protocol/tests/run-check-fixtures.sh [OUTPUT_REPORT.md]
#   OUTPUT_REPORT.md  optional path for the run report (PR/ecology evidence; NOT committed here). Default: a temp file.
#   env REAL_ECOLOGY_MAP=<map.json>  optional: also run `check.sh --all` against a real workspace map and expect
#                                    UNRESOLVED (e.g. PCS held). Skipped by default so the durable runner stays path-free.
set -u
REPO="$(cd "$(dirname "$0")/../.." && pwd)"          # tests/ is protocol/tests/ -> repo root is ../..
WORK="$(mktemp -d "${TMPDIR:-/tmp}/cs-fixtures.XXXXXX")"
OUT="${1:-$WORK/CHECK-FIXTURE-RESULTS.md}"
CORE="control-surface method-ASK design-system-ASK personal-context-system ASK"
trap 'rm -rf "$WORK"' EXIT

for dep in jq python3 git; do command -v "$dep" >/dev/null 2>&1 || { echo "MISSING DEP: $dep"; exit 2; }; done
python3 -c "import jsonschema" 2>/dev/null || { echo "MISSING DEP: python3 jsonschema"; exit 2; }

# ---- build a REAL temporary owner repo from the live repo's owner files ----
OWNER="$WORK/owner"; mkdir -p "$OWNER"
( cd "$REPO" && cp -R protocol AGENTS.md templates docs "$OWNER/" 2>/dev/null )
( cd "$OWNER" && git init -q && git config user.email t@t && git config user.name t && git checkout -q -b main \
  && git add -A && git commit -qm "owner snapshot" )
OWNER_PIN=$(git -C "$OWNER" rev-parse HEAD)
CHECK="$OWNER/protocol/check.sh"
SHAREDF="$OWNER/protocol/AGENTS.shared.md"; FRAGF="$OWNER/protocol/fragments/standing-upstream-conformance-grant.md"

pbody(){ awk -v p="$1" 'index($0,"<!-- BEGIN profile-body: "p" -->"){f=1;next} index($0,"<!-- END profile-body: "p" -->"){f=0} f' "$OWNER/protocol/profiles/$1.md"; }

# build_consumer NAME  "profs|-"  grant(y/n)  surface  pin
build_consumer(){
  local name="$1" profs="$2" grant="$3" surf="$4" pin="$5"
  local d="$WORK/consumers/$name" b="$WORK/consumers/$name.git"
  rm -rf "$d" "$b"; mkdir -p "$d"
  git init -q --bare "$b"; git init -q "$d"; ( cd "$d" && git config user.email t@t && git config user.name t && git checkout -q -b main )
  {
    echo "# AGENTS.md"
    echo "<!-- BEGIN carrier-metadata -->"
    echo "CARRIER_TYPE: resolved-local"
    echo "SHARED_BLOCK_SOURCE: apexSolarKiss/control-surface/protocol/AGENTS.shared.md"
    echo "SHARED_BLOCK_PIN: $pin"
    if [ "$profs" = "-" ]; then echo "PROFILES: []"; else echo "PROFILES: [$(echo $profs | tr ' ' ',')]"; fi
    if [ "$grant" = "y" ]; then echo "GRANT_FRAGMENT: standing-upstream-conformance-grant@$pin"; else echo "GRANT_FRAGMENT: none"; fi
    echo "OPERATING_SURFACE: $surf"
    echo "<!-- END carrier-metadata -->"
    echo "<!-- BEGIN shared: AGENTS.shared.md -->"; cat "$SHAREDF"; echo "<!-- END shared -->"
    if [ "$profs" != "-" ]; then for p in $profs; do echo "<!-- BEGIN profile: $p -->"; pbody "$p"; echo "<!-- END profile: $p -->"; done; fi
    if [ "$grant" = "y" ]; then echo "<!-- BEGIN grant: standing-upstream-conformance-grant -->"; cat "$FRAGF"; echo "<!-- END grant -->"; fi
    echo "<!-- BEGIN local-delta -->"; echo "## Required Reading — repo-local delta"; echo "- README.md"; echo "<!-- END local-delta -->"
  } > "$d/AGENTS.md"
  ( cd "$d" && git add AGENTS.md && git commit -qm init && git remote add origin "$b" && git push -q origin main )
}

# consumer-map entry
entry(){ # name surface
  printf '"%s": {"path":"%s","ref":"origin/main","operating_surface":"%s"}' "$1" "$WORK/consumers/$1" "$2"
}
surf_of(){ case "$1" in asset-pipeline-ASK|urban-observatory) echo separately-operated;; *) echo direct-core;; esac; }
pin_of(){ case "$1" in control-surface) echo self-resolving-owner-root;; *) echo "$OWNER_PIN";; esac; }
profs_of(){ case "$1" in asset-pipeline-ASK|urban-observatory) echo "-";; *) echo "core-ecology";; esac; }
grant_of(){ case "$1" in asset-pipeline-ASK|urban-observatory) echo y;; *) echo n;; esac; }

# ---- build the complete synthetic ecology ----
for n in $CORE asset-pipeline-ASK urban-observatory; do
  build_consumer "$n" "$(profs_of "$n")" "$(grant_of "$n")" "$(surf_of "$n")" "$(pin_of "$n")"
done

# maps
allc=$(for n in $CORE asset-pipeline-ASK urban-observatory; do entry "$n" "$(surf_of "$n")"; echo ,; done | sed '$s/,$//')
printf '{ "consumers": { %s } }\n' "$allc" > "$WORK/map-all.json"
wavec=$(for n in asset-pipeline-ASK urban-observatory; do entry "$n" separately-operated; echo ,; done | sed '$s/,$//')
printf '{ "wave_consumers":["asset-pipeline-ASK","urban-observatory"], "excluded": { %s }, "consumers": { %s } }\n' \
  "$(for n in $CORE; do printf '"%s":{"reason":"direct-core reset in a later wave"},' "$n"; done | sed 's/,$//')" "$wavec" > "$WORK/map-wave.json"

# ---- record harness ----
{ echo "# check.sh — reproducible fixture results"; echo; echo "Owner pin: \`$OWNER_PIN\` (temp owner repo). Positive controls exercise every mode; each negative asserts its intended diagnostic. Fixtures are temporary.";
  echo; echo "| fixture | mode | exit | want | expected diagnostic | result |"; echo "|---|---|---|---|---|---|"; } > "$OUT"
PASSES=0; FAILS=0
record(){ # desc  expect_rc  expect_diag  cmd...
  local desc="$1" erc="$2" ediag="$3"; shift 3
  local o rc; o=$("$@" 2>&1); rc=$?
  local hit="n/a"; [ -n "$ediag" ] && { echo "$o" | grep -qF "$ediag" && hit="found" || hit="MISSING"; }
  local pass="FAIL"; { [ "$rc" = "$erc" ] && { [ -z "$ediag" ] || [ "$hit" = "found" ]; }; } && pass="PASS"
  [ "$pass" = "PASS" ] && PASSES=$((PASSES+1)) || FAILS=$((FAILS+1))
  local mode; mode=$(printf '%s ' "$@" | grep -oE '\-\-(local|wave|all)' | head -1); [ -n "$mode" ] || mode="--"
  printf "| %-44s | %s | %s | %s | %s | %s |\n" "$desc" "$mode" "$rc" "$erc" "${ediag:-—}" "$pass" >> "$OUT"
  printf "  %-44s rc=%s(want %s) diag=%s -> %s\n" "$desc" "$rc" "$erc" "$hit" "$pass"
}
runlocal(){ ( cd "$1" && bash protocol/check.sh --local ); }
runmode(){ ( bash "$CHECK" "$1" "$2" ); }
owner_copy(){ local d="$WORK/$1"; rm -rf "$d"; cp -R "$OWNER" "$d"; echo "$d"; }
# mutate a consumer's committed AGENTS.md in place (perl expr), commit, push
mutate_consumer(){ local name="$1" expr="$2"; local d="$WORK/consumers/$name"; ( cd "$d" && perl -0pi -e "$expr" AGENTS.md && git commit -qam mut && git push -q -f origin main ); }
one_wave_map(){ printf '{ "wave_consumers":["%s"], "excluded":{}, "consumers": { %s } }\n' "$1" "$(entry "$1" "$2")"; }

# ---- POSITIVE CONTROLS (every mode) ----
record "POS --local (owner)"                         0 "ALL CHECKS PASSED" runlocal "$OWNER"
record "POS --wave (AP+UO resolved, core excluded)"  0 "ALL CHECKS PASSED" runmode --wave "$WORK/map-wave.json"
record "POS --all (whole ecology resolved)"          0 "ALL CHECKS PASSED" runmode --all "$WORK/map-all.json"

# ---- LOCAL NEGATIVES (mutate an owner copy, run --local) ----
d=$(owner_copy L1); rm -f "$d/protocol/AGENTS.shared.md";                                                         record "NEG shared body removed" 1 "missing owner file" runlocal "$d"
d=$(owner_copy L2); perl -0pi -e "s/A verification statement is bounded by the evidence actually gathered/CORRUPT/" "$d/protocol/AGENTS.shared.md"; record "NEG shared rule body changed" 1 "root shared-block missing/DIFFERS" runlocal "$d"
d=$(owner_copy L3); for f in protocol/AGENTS.shared.md AGENTS.md; do sed -i.bak "/<!-- rule-id: scope-discipline -->/d" "$d/$f"; rm -f "$d/$f.bak"; done; record "NEG rule-id marker removed" 1 "rules missing marker" runlocal "$d"
d=$(owner_copy L4); perl -0pi -e "s/(BEGIN profile-body: architecture-uncertain -->)/\$1\nINJECT/" "$d/protocol/profiles/architecture-uncertain.md"; record "NEG profile/overlay drift" 1 "architecture-uncertain profile/overlay drift" runlocal "$d"
d=$(owner_copy L5); perl -0pi -e "s/<!-- PROFILE BLOCKS ARE INSERTED HERE BY THE PROPAGATION WAVE -->/<!-- BEGIN profile: core-ecology -->/" "$d/templates/AGENTS.template.md"; record "NEG template carries installed-looking profile" 1 "installed-looking profile marker" runlocal "$d"
d=$(owner_copy L6); perl -0pi -e "s/\\A/X\n/" "$d/protocol/fragments/standing-upstream-conformance-grant.md"; record "NEG grant fragment not body-only" 1 "fragment not body-only" runlocal "$d"
d=$(owner_copy L7); python3 - "$d/protocol/manifest.json" <<'PY'
import json,sys; m=json.load(open(sys.argv[1]))
# point a held rule at a hold that is NOT declared (leave the real hold intact) -> referential break
[r for r in m["rules"] if r["rule_id"]=="verification-method-bundle"][0]["active_holds"]=["hold-nonexistent-xyz"]
json.dump(m,open(sys.argv[1],"w"),indent=1)
PY
record "NEG manifest hold referential break" 1 "undeclared holds referenced" runlocal "$d"
d=$(owner_copy L8); python3 - "$d/protocol/manifest.json" <<'PY'
import json,sys; m=json.load(open(sys.argv[1]))
# a still-candidate rule (independent of which candidate activates in the owner PR)
[r for r in m["rules"] if r["rule_id"]=="memory-reconciliation-follows-durable-landing"][0]["activated_by"]="#999 / deadbeef"
json.dump(m,open(sys.argv[1],"w"),indent=1)
PY
record "NEG candidate given activation provenance" 1 "manifest fails manifest.schema.json" runlocal "$d"
d=$(owner_copy L9); python3 - "$d/protocol/manifest.json" <<'PY'
import json,sys; m=json.load(open(sys.argv[1]))
m["rules"][0]["scope_class"]="bogus-class"
json.dump(m,open(sys.argv[1],"w"),indent=1)
PY
record "NEG manifest schema violation (bad enum)" 1 "manifest fails manifest.schema.json" runlocal "$d"

# ---- WAVE / ALL NEGATIVES (build/mutate a consumer, run a one-consumer map) ----
record "NEG --wave unresolvable ref" 1 "not found" bash -c 'printf "{ \"wave_consumers\":[\"asset-pipeline-ASK\"], \"excluded\":{}, \"consumers\": { \"asset-pipeline-ASK\": {\"path\":\"'"$WORK"'/consumers/asset-pipeline-ASK\",\"ref\":\"no-such-ref\",\"operating_surface\":\"separately-operated\"} } }" > "'"$WORK"'/m.json"; bash "'"$CHECK"'" --wave "'"$WORK"'/m.json"'
record "NEG --all applicable consumer absent from map" 1 "absent from map" bash -c 'printf "{ \"consumers\": { \"control-surface\": {\"path\":\"'"$WORK"'/consumers/control-surface\",\"ref\":\"origin/main\"} } }" > "'"$WORK"'/m2.json"; bash "'"$CHECK"'" --all "'"$WORK"'/m2.json"'

# consumer mutation negatives — build fresh, mutate, run one-consumer --wave
mkwave(){ one_wave_map "$1" "$2" > "$WORK/w.json"; runmode --wave "$WORK/w.json"; }

build_consumer method-ASK core-ecology n direct-core "$OWNER_PIN"; mutate_consumer method-ASK 's/(<!-- BEGIN shared: AGENTS.shared.md -->)/$1\nDRIFT/'
record "NEG consumer shared-block drift" 1 "shared block missing/DRIFT" mkwave method-ASK direct-core

build_consumer method-ASK core-ecology n direct-core "$OWNER_PIN"; mutate_consumer method-ASK 's/(<!-- BEGIN profile: core-ecology -->)/$1\nOWNER-EXPLANATION-WRAPPER/'
record "NEG consumer profile owner-wrapper/drift" 1 "profile core-ecology drift or owner-wrapper inserted" mkwave method-ASK direct-core

build_consumer method-ASK core-ecology n direct-core "not-a-40hex-pin"
record "NEG malformed owner pin" 1 "not a 40-hex owner commit" mkwave method-ASK direct-core

build_consumer method-ASK core-ecology n direct-core "0000000000000000000000000000000000000000"
record "NEG 40hex pin not a commit in owner repo" 1 "not a commit in the owner repo" mkwave method-ASK direct-core

build_consumer method-ASK core-ecology n direct-core "$OWNER_PIN"; mutate_consumer method-ASK 's/PROFILES: \[core-ecology\]/PROFILES: []/'
record "NEG metadata PROFILES vs installed mismatch" 1 "installed profiles" mkwave method-ASK direct-core

build_consumer method-ASK core-ecology n direct-core "$OWNER_PIN"; mutate_consumer method-ASK 's/(<!-- END profile: core-ecology -->)/$1\n<!-- BEGIN profile: core-ecology -->\n<!-- END profile: core-ecology -->/'
record "NEG duplicate installed profile" 1 "duplicate installed profile" mkwave method-ASK direct-core

build_consumer asset-pipeline-ASK - y separately-operated "$OWNER_PIN"; mutate_consumer asset-pipeline-ASK 's/standing write jurisdiction/standing write CHANGED/'
record "NEG installed grant changed" 1 "grant DRIFT vs fragment" mkwave asset-pipeline-ASK separately-operated

build_consumer asset-pipeline-ASK - y separately-operated "$OWNER_PIN"; mutate_consumer asset-pipeline-ASK 's/<!-- BEGIN grant.*?<!-- END grant -->//s'
record "NEG GRANT_FRAGMENT declared but body absent" 1 "declares grant but none installed" mkwave asset-pipeline-ASK separately-operated

build_consumer method-ASK core-ecology n direct-core "$OWNER_PIN"; mutate_consumer method-ASK 's/<!-- BEGIN local-delta -->//'
record "NEG consumer local-delta markers removed" 1 "local-delta markers not exactly once" mkwave method-ASK direct-core

build_consumer method-ASK core-ecology n direct-core "$OWNER_PIN"
one_wave_map method-ASK separately-operated > "$WORK/w.json"   # map says separately-operated; metadata says direct-core
record "NEG operating-surface map contradicts metadata" 1 "!= map" runmode --wave "$WORK/w.json"

build_consumer method-ASK core-ecology n direct-core "self-resolving-owner-root"
record "NEG self-resolving pin on non-owner consumer" 1 "not the protocol owner" mkwave method-ASK direct-core

# ---- OPTIONAL: real workspace map (path-driven, off by default) ----
if [ -n "${REAL_ECOLOGY_MAP:-}" ] && [ -f "${REAL_ECOLOGY_MAP}" ]; then
  record "OPT --all real ecology (expect UNRESOLVED)" 1 "" runmode --all "$REAL_ECOLOGY_MAP"
else
  echo "  (optional real-ecology --all test skipped; set REAL_ECOLOGY_MAP=<map.json> to enable)"
fi

echo; echo "=== $OUT ==="; cat "$OUT"
echo; echo "PASS=$PASSES  FAIL=$FAILS"
[ "$FAILS" -eq 0 ]
