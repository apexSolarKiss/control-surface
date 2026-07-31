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
( cd "$REPO" && cp -R protocol AGENTS.md templates docs prompts "$OWNER/" 2>/dev/null )
( cd "$OWNER" && git init -q && git config user.email t@t && git config user.name t && git checkout -q -b main \
  && git add -A && git commit -qm "owner snapshot" )
OWNER_PIN=$(git -C "$OWNER" rev-parse HEAD)
OWNER_BARE="$WORK/owner.git"; git init -q --bare "$OWNER_BARE"; ( cd "$OWNER" && git remote add origin "$OWNER_BARE" && git push -q origin main )
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
entry(){ # name surface — control-surface routes to the REAL owner root (dogfoods the consumer contract)
  local p; if [ "$1" = "control-surface" ]; then p="$OWNER"; else p="$WORK/consumers/$1"; fi
  printf '"%s": {"path":"%s","ref":"origin/main","operating_surface":"%s"}' "$1" "$p" "$2"
}
surf_of(){ case "$1" in asset-pipeline-ASK|urban-observatory) echo separately-operated;; *) echo direct-core;; esac; }
pin_of(){ case "$1" in control-surface) echo self-resolving-owner-root;; *) echo "$OWNER_PIN";; esac; }
profs_of(){ case "$1" in asset-pipeline-ASK|urban-observatory) echo "advisor-project-surface";; *) echo "core-ecology";; esac; }
grant_of(){ case "$1" in asset-pipeline-ASK|urban-observatory) echo y;; *) echo n;; esac; }

# ---- build the ecology: control-surface = the REAL owner root (validated below); synthetic consumers for the rest ----
for n in method-ASK design-system-ASK personal-context-system ASK asset-pipeline-ASK urban-observatory; do
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
one_wave_map(){ # named surface — complete wave: named in wave, ALL other applicable consumers excluded-with-reason
  local named="$1" surf="$2" excl=""
  for n in $CORE asset-pipeline-ASK urban-observatory; do [ "$n" = "$named" ] && continue; excl="$excl\"$n\":{\"reason\":\"out of scope for this single-consumer fixture\"},"; done
  excl="${excl%,}"
  printf '{ "wave_consumers":["%s"], "excluded":{ %s }, "consumers": { %s } }\n' "$named" "$excl" "$(entry "$named" "$surf")"; }

# ---- POSITIVE CONTROLS (every mode) ----
record "POS --local (owner)"                         0 "ALL CHECKS PASSED" runlocal "$OWNER"
record "POS --wave (AP+UO resolved, core excluded)"  0 "ALL CHECKS PASSED" runmode --wave "$WORK/map-wave.json"
record "POS --all (whole ecology resolved)"          0 "ALL CHECKS PASSED" runmode --all "$WORK/map-all.json"

# ---- LOCAL NEGATIVES (mutate an owner copy, run --local) ----
d=$(owner_copy L1); rm -f "$d/protocol/AGENTS.shared.md";                                                         record "NEG shared body removed" 1 "missing owner file" runlocal "$d"
d=$(owner_copy L2); perl -0pi -e "s/A verification statement is bounded by the evidence actually gathered/CORRUPT/" "$d/protocol/AGENTS.shared.md"; record "NEG shared rule body changed" 1 "root shared-block missing/DIFFERS" runlocal "$d"
d=$(owner_copy L3); for f in protocol/AGENTS.shared.md AGENTS.md; do sed -i.bak "/<!-- rule-id: scope-discipline -->/d" "$d/$f"; rm -f "$d/$f.bak"; done; record "NEG rule-id marker removed" 1 "rules missing marker" runlocal "$d"
d=$(owner_copy L3b); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/(<!-- rule-id: scope-discipline -->)/$1\n<!-- rule-id: not-declared-anywhere -->/' "$d/$f"; done; record "NEG new rule marker with no manifest row" 1 "orphan markers" runlocal "$d"
d=$(owner_copy L3c); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/(## Scope Discipline\n)/## Undeclared New Section\n\nbody\n\n---\n\n$1/' "$d/$f"; done; record "NEG new mapped H2 with no manifest rule" 1 "unmapped headings" runlocal "$d"
d=$(owner_copy L3d); perl -0pi -e 's/^### Shared execution-protocol architecture$/### Something Else/m' "$d/templates/_INDEX-project.template.md"; record "NEG index template loses the protocol section" 1 "index template missing '### Shared execution-protocol architecture'" runlocal "$d"
d=$(owner_copy L3e); perl -0pi -e 's{apexSolarKiss/control-surface/prompts/cross-repo-propagation-wave\.md}{}' "$d/templates/_INDEX-project.template.md"; record "NEG index template loses a protocol locator" 1 "index template missing locator(s)" runlocal "$d"
d=$(owner_copy L3f); perl -0pi -e 's/serial-delegated//g' "$d/prompts/cross-repo-propagation-wave.md"; record "NEG runbook loses an execution-topology token" 1 "execution-topology token(s) missing" runlocal "$d"
d=$(owner_copy L3g); perl -0pi -e 's/subagent_capability_check//g' "$d/prompts/cross-repo-propagation-wave.md"; record "NEG runbook loses the subagent-capability-check token" 1 "execution-topology token(s) missing" runlocal "$d"
# L3h/L3i target the BOOTSTRAP: these clauses MOVED there when #172 thinned the PI to the pre-retrieval floor.
# Mutating the PI template proved nothing once check 11 stopped reading it — the negative fixtures passed vacuously.
d=$(owner_copy L3h); perl -0pi -e 's/reported hash//g' "$d/templates/advisor-project-bootstrap.template.md"; record "NEG advisor-bootstrap loses the reported-hash clause" 1 "advisor-retrieval-contract clause(s) missing" runlocal "$d"
d=$(owner_copy L3i); perl -0pi -e 's/manual upload never bypasses a wall//g' "$d/templates/advisor-project-bootstrap.template.md"; record "NEG advisor-bootstrap loses the wall sentence" 1 "advisor-retrieval-contract clause(s) missing" runlocal "$d"
d=$(owner_copy L3j); perl -0pi -e 's/parent-direct-exception//g' "$d/prompts/cross-repo-propagation-wave.md"; record "NEG runbook loses parent-direct-exception mode" 1 "execution-topology token(s) missing" runlocal "$d"
# L3k..L3p guard the #176 transport-discipline clauses plus the restored Stage-1 relay clause (L3k, L3o —
# revised 2026-07-29 with the review-window regression repair). Each removes ONE obligation independently, so a
# silent regression in any single clause fails on its own rather than hiding behind a sibling that is still present.
d=$(owner_copy L3k); perl -0pi -e 's/The relay is the request//g' "$d/templates/advisor-project-bootstrap.template.md"; record "NEG advisor-bootstrap loses the relay-opens-review clause" 1 "advisor-retrieval-contract clause(s) missing" runlocal "$d"
d=$(owner_copy L3l); perl -0pi -e 's/raw file bytes//g' "$d/templates/advisor-project-bootstrap.template.md"; record "NEG advisor-bootstrap loses the raw-file-bytes rung" 1 "advisor-retrieval-contract clause(s) missing" runlocal "$d"
d=$(owner_copy L3m); perl -0pi -e 's/exact bytes remain retrievable//g' "$d/templates/advisor-project-bootstrap.template.md"; record "NEG advisor-bootstrap loses the exact-byte no-courier criterion" 1 "advisor-retrieval-contract clause(s) missing" runlocal "$d"
d=$(owner_copy L3n); perl -0pi -e 's/connector-bounded alternate representation//g' "$d/templates/advisor-project-bootstrap.template.md"; record "NEG advisor-bootstrap loses the one-alternate fallback cap" 1 "advisor-retrieval-contract clause(s) missing" runlocal "$d"
d=$(owner_copy L3o); perl -0pi -e 's/Stage-1 readiness includes the minimum exact review object//g' "$d/docs/project-instantiation-workflow.md"; record "NEG instantiation loses the readiness-includes-object clause" 1 "advisor-retrieval-contract clause(s) missing" runlocal "$d"
d=$(owner_copy L3p); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/\*\*Bounded fallback\.\*\*//g' "$d/$f"; done; record "NEG shared canonical + root carrier lose the bounded-fallback clause" 1 "advisor-retrieval-contract clause(s) missing" runlocal "$d"

# L3q..L3v guard the four-event handoff lifecycle (check 15). The positive half and the negative half are proven
# separately: removing an obligation must fail, AND reintroducing a feed-exit formulation must fail. A carrier that
# states the four events while stale "fed in = queue exit" prose survives elsewhere is the exact defect this corrects.
d=$(owner_copy L3q); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/\*\*Four events, not two\.\*\*//g' "$d/$f"; done; record "NEG shared canonical + root carrier lose the four-event model" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
d=$(owner_copy L3r); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/queue exit occurs on recipient-side ingestion, not on the feed attempt//g' "$d/$f"; done; record "NEG carriers lose the queue-exit-on-ingestion clause" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
d=$(owner_copy L3s); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/\*\*The queue is logical, not a folder\.\*\*//g' "$d/$f"; done; record "NEG carriers lose the logical-queue clause" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
d=$(owner_copy L3t); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/\*\*Route on approval; feed\/ingest later\.\*\*//g' "$d/$f"; done; record "NEG carriers lose the route-on-approval clause" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
d=$(owner_copy L3u); perl -0pi -e 's/\*\*Four events, not two\.\*\*//g' "$d/templates/advisor-project-bootstrap.template.md"; record "NEG advisor-bootstrap loses the four-event model" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
d=$(owner_copy L3v); perl -0pi -e 's/queue exit occurs on recipient-side ingestion, not on the feed attempt/the item leaves the queue when it is fed in/g' "$d/protocol/AGENTS.shared.md"; record "NEG feed-exit formulation reintroduced into the shared canonical" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
d=$(owner_copy L3w); perl -0pi -e 's/LIFE-4b/LIFE-4z/g' "$d/docs/advisor-project-surface-architecture.md"; record "NEG registry loses the LIFE-4b four-event row" 1 "advisor-surface recovery clause(s) missing" runlocal "$d"

# L3x..L3ac guard the GENERATED advisor carrier and the manifest failure-mode classes. The owner rule staying complete
# while a generated bootstrap silently weakens is the failure this program exists to prevent, so each bootstrap
# obligation is removed independently rather than proven by the presence of a heading.
d=$(owner_copy L3x); perl -0pi -e 's/Route on approval; feed\/ingest later\.//g' "$d/templates/advisor-project-bootstrap.template.md"; record "NEG advisor-bootstrap loses route-on-approval timing" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
d=$(owner_copy L3y); perl -0pi -e 's/never on the feed attempt//g' "$d/templates/advisor-project-bootstrap.template.md"; record "NEG advisor-bootstrap loses the recipient-side-evidence clause" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
d=$(owner_copy L3z); perl -0pi -e 's/relocation within the queue is not a lifecycle event//g' "$d/templates/advisor-project-bootstrap.template.md"; record "NEG advisor-bootstrap loses the logical-queue relocation clause" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
d=$(owner_copy L3aa); perl -0pi -e 's/grants no new write\s+authority/grants broad authority/g' "$d/templates/advisor-project-bootstrap.template.md"; record "NEG advisor-bootstrap loses the no-new-write-authority boundary" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
d=$(owner_copy L3ab); perl -0pi -e 's/ASK separately controls when to feed the routed artifact//g' "$d/templates/advisor-project-bootstrap.template.md"; record "NEG advisor-bootstrap loses ASK's separate feed-timing control" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
d=$(owner_copy L3ac); perl -0pi -e 's/LIFE-4c/LIFE-4y/g' "$d/docs/advisor-project-surface-architecture.md"; record "NEG registry loses the LIFE-4c route-on-approval row" 1 "advisor-surface recovery clause(s) missing" runlocal "$d"
d=$(owner_copy L3ad); perl -0pi -e 's/routing collapsed into feeding; //g' "$d/protocol/manifest.json"; record "NEG manifest failure_mode loses the routing-collapsed-into-feeding class" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"

# L3ae..L3ag guard PROTO-3 executor-carrier delivery. This requirement was a real owner-registry OMISSION: it
# shipped in a deployed Instructions field, was absent from PROTO-1, and was therefore silently dropped when a
# bootstrap was generated from the incomplete registry. Both halves are guarded — the registry row AND the
# generated carrier — because either alone reproduces the original loss.
d=$(owner_copy L3ae); perl -0pi -e 's/PROTO-3/PROTO-9/g' "$d/docs/advisor-project-surface-architecture.md"; record "NEG registry loses the PROTO-3 row" 1 "advisor-surface recovery clause(s) missing" runlocal "$d"
d=$(owner_copy L3af); perl -0pi -e 's/Executor-carrier delivery//g' "$d/docs/advisor-project-surface-architecture.md"; record "NEG registry loses the PROTO-3 requirement text" 1 "advisor-surface recovery clause(s) missing" runlocal "$d"
# Anchor the mutation on an ASCII-only substring: perl's `.` matches one BYTE, so it cannot span the em dashes
# in "verify — do not assume —". A dot-wildcard pattern silently fails to substitute and the fixture then proves
# nothing. Mutating "the executor's carrier delivery" defeats check.sh's flattened bootstrap assertion.
d=$(owner_copy L3ag); perl -0pi -e "s/the executor's carrier delivery/the adapter/g" "$d/templates/advisor-project-bootstrap.template.md"; record "NEG advisor-bootstrap loses the PROTO-3 carrier-delivery step" 1 "advisor-surface recovery clause(s) missing" runlocal "$d"

# L3ah..L3ap guard the ROUTED-INSTANCE LIFECYCLE that replaced the outgoing model (check 15). Two halves, proven
# separately: each new obligation must fail when removed, AND each outgoing formulation must fail when reintroduced.
# SCOPE OF PROOF: these fixtures prove CARRIER COVERAGE and stale-semantic rejection. Whether a real FROZEN
# `_STATE.md` actually blocks a live ingestion is an exercised acceptance test at each surface cutover, never
# inferred from a phrase-removal fixture passing here.
d=$(owner_copy L3ah); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/the rename records it, it does not cause it//g' "$d/$f"; done; record "NEG carriers lose 'the rename records ingestion, it does not cause it'" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
d=$(owner_copy L3ai); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/Closure and the terminal rename are one bounded operation//g' "$d/$f"; done; record "NEG carriers lose the record+rename coupling" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
d=$(owner_copy L3aj); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/a bare exact path addressed to an active surface is a feed//g' "$d/$f"; done; record "NEG carriers lose by-reference feeding" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
# The wildcard-escape-hatch guard. Removing the bound leaves "structural artifacts are exempt" with nothing
# restricting WHICH artifacts qualify — the exact hole an unconditional `_`-prefix rule would have opened.
d=$(owner_copy L3ak); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/A leading `_` alone confers no exemption\.//g' "$d/$f"; done; record "NEG carriers lose the underscore-confers-nothing bound" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
d=$(owner_copy L3al); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/\*\*This lifecycle grammar is prospective\.\*\*//g' "$d/$f"; done; record "NEG carriers lose the no-historical-normalization boundary" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
# Reintroducing the OUTGOING model must fail even while every new clause is still present. Anchor on ASCII only:
# perl's `.` matches one BYTE and cannot span the em dashes in this prose.
d=$(owner_copy L3am); perl -0pi -e 's/the recipient surface reads the exact artifact into active context/the recipient surface takes it up/g' "$d/protocol/AGENTS.shared.md"; record "NEG outgoing 'takes it up' reintroduced into the shared canonical" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
d=$(owner_copy L3an); perl -0pi -e 's/-supersededA/-SUPERSEDED/g' "$d/protocol/AGENTS.shared.md"; record "NEG outgoing uppercase -SUPERSEDED reintroduced into the shared canonical" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
d=$(owner_copy L3ao); perl -0pi -e 's/Disposition is not absorption, and the record is not optional//g' "$d/templates/advisor-project-bootstrap.template.md"; record "NEG advisor-bootstrap loses disposition-is-not-absorption" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
# The index template is the carrier that declares WHICH artifacts a surface treats as structural. Losing the
# declaration bound there reopens the wildcard on the deployment side even if the shared body still states it.
d=$(owner_copy L3ap); perl -0pi -e 's/a leading `_` alone confers nothing//g' "$d/templates/_INDEX-project.template.md"; record "NEG index template loses the structural-declaration bound" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
d=$(owner_copy L3aq); perl -0pi -e 's/disposition collapsed into absorption; //g' "$d/protocol/manifest.json"; record "NEG manifest failure_mode loses the disposition-collapsed-into-absorption class" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"

# L3ar..L3at guarded a PTX/TBI no-stacking prohibition that ASK has since WITHDRAWN: `-TBI` is an orthogonal
# terminal feed overlay, so a PTX may carry it. The prohibition is now itself a stale-semantic REJECT, and these
# three fixtures guard the replacement posture. The original defect they were written for still matters as
# history: the first draft of this unit shipped a marker-grammar sentence saying `-PTX` "precedes the lifecycle
# suffix" while the same body forbade the stacking two paragraphs later, and the suite passed because the
# assertion encoded the contradiction. The lesson survives the rule it was learned on.
d=$(owner_copy L3ar); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/A `-PTX` \*\*may\*\* carry the overlay/A `-PTX` never carries the overlay/g' "$d/$f"; done; record "NEG carriers lose PTX overlay eligibility" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
# The WITHDRAWN prohibition must now FAIL as stale semantics if any carrier reintroduces it.
d=$(owner_copy L3as); perl -0pi -e 's/(A `-PTX` \*\*may\*\* carry the overlay)/`-PTX` never combines with `-TBI`, `-ingested`, or any terminal disposition suffix. $1/' "$d/protocol/AGENTS.shared.md"; record "NEG withdrawn PTX no-stacking prohibition reintroduced" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
d=$(owner_copy L3at); perl -0pi -e 's/a -PTX treated as ineligible for the terminal -TBI feed overlay; //g' "$d/protocol/manifest.json"; record "NEG ptx-marker failure_mode loses the overlay-ineligibility class" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
# The overlay's own corrections: state-not-class discrimination, the role+prior-state gate, and the boundary split.
d=$(owner_copy L3aw); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/the discriminator is the fresh-awaiting-first-ingestion \*\*state\*\*, not the artifact class//g' "$d/$f"; done; record "NEG carriers lose the state-not-class discriminator" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
d=$(owner_copy L3ax); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/\*\*An unresolved role or prior state is a stop condition\*\*/Removal-only is the safe default/g' "$d/$f"; done; record "NEG unresolved role/state stops failing closed" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
d=$(owner_copy L3ay); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/\*\*Two boundaries, not one\.\*\*//g' "$d/$f"; done; record "NEG carriers lose the handoff/ingestion boundary split" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
d=$(owner_copy L3az); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/remove only -TBI; the underlying role and durable disposition survive unchanged//g' "$d/$f"; done; record "NEG carriers lose the removal-only branch" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"

# L3bm..L3bq guard the 2026-07-29 review-window REGRESSION REPAIR (checks 11 + 11b). The #172/#176 Stage-1
# exclusion was unregistered operative semantics that inverted live paired-path practice; the Stage-1 verdict
# on the repair added two further load-bearing distinctions (readiness includes publication; direct execution
# is never inferred from non-relay) and the deployed-prompt carrier. Each fixture removes one obligation or
# reintroduces one retired formulation independently and must FAIL for its own diagnostic.
d=$(owner_copy L3bm); perl -0pi -e 's/(\*\*Review-window routing — the relay is the request\.\*\*)/$1 A pasted executor summary is not an implicit request for pre-PR advisor review./' "$d/protocol/AGENTS.shared.md"; record "NEG retired Stage-1 exclusion reintroduced into the shared canonical" 1 "retired Stage-1 exclusion reintroduced" runlocal "$d"
d=$(owner_copy L3bn); perl -0pi -e 's/(## Review windows)/$1\n\nASK reviews directly; you are not in that loop./' "$d/templates/advisor-project-bootstrap.template.md"; record "NEG retired advisor exclusion reintroduced into the bootstrap template" 1 "retired Stage-1 exclusion reintroduced" runlocal "$d"
d=$(owner_copy L3bo); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/Stage-1 readiness includes the minimum exact review object//g' "$d/$f"; done; record "NEG carriers lose the readiness-includes-publication clause" 1 "advisor-retrieval-contract clause(s) missing" runlocal "$d"
d=$(owner_copy L3bp); perl -0pi -e 's/(\*\*Review-window routing — the relay is the request\.\*\*)/$1 Direct execution may also be elected made by not relaying./' "$d/protocol/AGENTS.shared.md"; record "NEG passive non-relay direct-execution semantics reintroduced" 1 "retired Stage-1 exclusion reintroduced" runlocal "$d"
d=$(owner_copy L3bq); perl -0pi -e 's/(Stage-1 review opens on ASK relay)/ASK reviews the diff (pre-commit window). $1/' "$d/prompts/ecology-critique-execution-prompt.md"; record "NEG retired first-line sentence reintroduced into the ecology execution prompt" 1 "retired Stage-1 exclusion reintroduced" runlocal "$d"
d=$(owner_copy L3br); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/Other narrowed envelopes — including `FYI` and `HOLD` — also suppress an advisor Stage-1 verdict, but they authorize no direct execution and no write\. //g' "$d/$f"; done; record "NEG carriers lose the FYI/HOLD authorize-nothing distinction" 1 "advisor-retrieval-contract clause(s) missing" runlocal "$d"

# L3bs..L3co guard the P2-1 THROUGHPUT DISCIPLINE (check 11c): Issue B proportionality/termination and
# Issue C executor preflight. Guarded at two grains — headline anchors AND substantive phrases per
# obligation — with one fixture per guarded loss, so any single silent loss fails alone. In particular a
# heading may survive while its obligation is deleted (L3ci, L3ck, L3cl prove those losses fail alone), and
# the frozen-record threshold is guarded on all three carriers that deploy it (L3cm shared/root, L3cn
# advisor-bootstrap, L3co registry).
d=$(owner_copy L3bs); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/reversibility × blast radius × cost of error × decision relevance//g' "$d/$f"; done; record "NEG carriers lose the proportionality formula" 1 "throughput-discipline clause(s) missing" runlocal "$d"
d=$(owner_copy L3bt); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/never waives an ASK-owned authorization gate//g' "$d/$f"; done; record "NEG carriers lose the no-waiver gate list" 1 "throughput-discipline clause(s) missing" runlocal "$d"
d=$(owner_copy L3bu); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/MATERIAL NON-BLOCKING//g' "$d/$f"; done; record "NEG carriers lose the materiality classes" 1 "throughput-discipline clause(s) missing" runlocal "$d"
d=$(owner_copy L3bv); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/\*\*Correction loops terminate\.\*\*//g' "$d/$f"; done; record "NEG carriers lose the correction-loops heading" 1 "throughput-discipline clause(s) missing" runlocal "$d"
d=$(owner_copy L3bw); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/the round does not open//g' "$d/$f"; done; record "NEG carriers lose the round-opening gate" 1 "throughput-discipline clause(s) missing" runlocal "$d"
d=$(owner_copy L3bx); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/never regenerated or forced into semantic parity//g' "$d/$f"; done; record "NEG carriers lose the partition non-regeneration bound" 1 "throughput-discipline clause(s) missing" runlocal "$d"
d=$(owner_copy L3by); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/\*\*Executor preflight — read the finished object before handing it off\.\*\*//g' "$d/$f"; done; record "NEG carriers lose the executor-preflight heading" 1 "throughput-discipline clause(s) missing" runlocal "$d"
d=$(owner_copy L3bz); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/\*\*The parent verifies every internal finding\*\*//g' "$d/$f"; done; record "NEG carriers lose parent verification of internal findings" 1 "throughput-discipline clause(s) missing" runlocal "$d"
d=$(owner_copy L3ca); perl -0pi -e 's/\*\*Proportionate verdicts\.\*\*//g' "$d/templates/advisor-project-bootstrap.template.md"; record "NEG advisor-bootstrap loses proportionate verdicts" 1 "throughput-discipline clause(s) missing" runlocal "$d"
d=$(owner_copy L3cb); perl -0pi -e 's/REVIEW-13/REVIEW-19/g' "$d/docs/advisor-project-surface-architecture.md"; record "NEG registry loses the REVIEW-13 proportionate-verdicts row" 1 "throughput-discipline clause(s) missing" runlocal "$d"
d=$(owner_copy L3cc); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/internal-clean never replaces the external advisor//g' "$d/$f"; done; record "NEG carriers lose the internal-clean-is-not-approval bound" 1 "throughput-discipline clause(s) missing" runlocal "$d"
d=$(owner_copy L3cd); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/must demonstrate one real negative or control case//g' "$d/$f"; done; record "NEG carriers lose the checker-demonstration rule" 1 "throughput-discipline clause(s) missing" runlocal "$d"
d=$(owner_copy L3ce); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/\*\*Readiness receipt\.\*\*//g' "$d/$f"; done; record "NEG carriers lose the readiness-receipt heading" 1 "throughput-discipline clause(s) missing" runlocal "$d"
d=$(owner_copy L3cf); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/re-anchor to the current live owner or baseline//g' "$d/$f"; done; record "NEG carriers lose the rework re-anchor threshold" 1 "throughput-discipline clause(s) missing" runlocal "$d"
d=$(owner_copy L3cg); perl -0pi -e 's/MATERIAL NON-BLOCKING//g' "$d/templates/advisor-project-bootstrap.template.md"; record "NEG advisor-bootstrap loses the materiality classes" 1 "throughput-discipline clause(s) missing" runlocal "$d"
d=$(owner_copy L3ch); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/name the credible failure mode and correct it before proceeding//g' "$d/$f"; done; record "NEG carriers lose the named-failure-mode blocking criterion" 1 "throughput-discipline clause(s) missing" runlocal "$d"
d=$(owner_copy L3ci); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/reload the final bytes from disk and perform one end-to-end parent cold read of the deliverable and its surrounding frame//g' "$d/$f"; done; record "NEG carriers lose the parent cold-read obligation while the preflight heading remains" 1 "throughput-discipline clause(s) missing" runlocal "$d"
d=$(owner_copy L3cj); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/never the delta alone//g' "$d/$f"; done; record "NEG carriers lose the never-the-delta-alone bound" 1 "throughput-discipline clause(s) missing" runlocal "$d"
d=$(owner_copy L3ck); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/\Qparent semantic self-review: COMPLETE\E//g' "$d/$f"; done; record "NEG carriers lose the parent-self-review receipt field while the receipt heading remains" 1 "throughput-discipline clause(s) missing" runlocal "$d"
d=$(owner_copy L3cl); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/\Qinternal adversarial preflight: PERFORMED | NOT TRIGGERED | UNAVAILABLE\E//g' "$d/$f"; done; record "NEG carriers lose the preflight-disposition receipt field while the receipt heading remains" 1 "throughput-discipline clause(s) missing" runlocal "$d"
d=$(owner_copy L3cm); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/does not reopen, append to, or generate a successor for the frozen object//g' "$d/$f"; done; record "NEG carriers lose the frozen-record no-reopen threshold" 1 "throughput-discipline clause(s) missing" runlocal "$d"
d=$(owner_copy L3cn); perl -0pi -e 's/does not require the frozen object to be reopened//g' "$d/templates/advisor-project-bootstrap.template.md"; record "NEG advisor-bootstrap loses the frozen-record threshold" 1 "throughput-discipline clause(s) missing" runlocal "$d"
d=$(owner_copy L3co); perl -0pi -e 's/does not reopen, append to, or generate a successor for a frozen object//g' "$d/docs/advisor-project-surface-architecture.md"; record "NEG registry loses the frozen-record threshold" 1 "throughput-discipline clause(s) missing" runlocal "$d"
# L3cp..L3db guard the P2-2 TBI AMENDMENTS (check 11d): denial-scope (Private-Memory Write Gate) and
# retrieval-obligation (Required Reading). Two grains — headline anchors AND every operative sentence — one
# fixture per guarded loss; all non-heading fixtures prove obligation losses fail while headings survive.
d=$(owner_copy L3cp); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/\*\*Denial stops the mutation, not unrelated work\.\*\*//g' "$d/$f"; done; record "NEG carriers lose the denial-scope heading" 1 "denial-scope/retrieval-obligation clause(s) missing" runlocal "$d"
d=$(owner_copy L3cq); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/do not retry it through another tool or surface//g' "$d/$f"; done; record "NEG carriers lose the no-retry-through-another-surface bound while the denial heading remains" 1 "denial-scope/retrieval-obligation clause(s) missing" runlocal "$d"
d=$(owner_copy L3cr); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/Stop the broader task only when its completion actually depends on the prohibited mutation//g' "$d/$f"; done; record "NEG carriers lose the dependency-only stop condition while the denial heading remains" 1 "denial-scope/retrieval-obligation clause(s) missing" runlocal "$d"
d=$(owner_copy L3cs); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/\*\*A named-but-unread governing source is a defect, not a caveat\.\*\*//g' "$d/$f"; done; record "NEG carriers lose the named-but-unread heading" 1 "denial-scope/retrieval-obligation clause(s) missing" runlocal "$d"
d=$(owner_copy L3ct); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/Retrieve it before producing the governed output//g' "$d/$f"; done; record "NEG carriers lose the retrieve-before-output obligation while its heading remains" 1 "denial-scope/retrieval-obligation clause(s) missing" runlocal "$d"
d=$(owner_copy L3cu); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/\*\*A declared read order is not a cost-benefit input\.\*\*//g' "$d/$f"; done; record "NEG carriers lose the read-order heading" 1 "denial-scope/retrieval-obligation clause(s) missing" runlocal "$d"
d=$(owner_copy L3cv); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/Never silently substitute a live sufficiency judgment or close by proposing the required read as future work//g' "$d/$f"; done; record "NEG carriers lose the no-silent-substitution bound while the read-order heading remains" 1 "denial-scope/retrieval-obligation clause(s) missing" runlocal "$d"
d=$(owner_copy L3cw); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/state that fact, the reason, and the resulting limit in the same turn//g' "$d/$f"; done; record "NEG carriers lose the unavailability-honesty bound while its heading remains" 1 "denial-scope/retrieval-obligation clause(s) missing" runlocal "$d"
d=$(owner_copy L3cx); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/continue the unrelated task to the extent the task remains independently authorized and technically possible//g' "$d/$f"; done; record "NEG carriers lose the bounded continuation permission while the denial heading remains" 1 "denial-scope/retrieval-obligation clause(s) missing" runlocal "$d"
d=$(owner_copy L3cy); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/state that dependency explicitly//g' "$d/$f"; done; record "NEG carriers lose the explicit-dependency bound while the denial heading remains" 1 "denial-scope/retrieval-obligation clause(s) missing" runlocal "$d"
d=$(owner_copy L3cz); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/every pre-flight coverage requirement and stop condition of this gate is unaffected//g' "$d/$f"; done; record "NEG carriers lose the coverage-stop preservation bound while the denial heading remains" 1 "denial-scope/retrieval-obligation clause(s) missing" runlocal "$d"
d=$(owner_copy L3da); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/If the active authority explicitly waives the read or the source is technically unavailable//g' "$d/$f"; done; record "NEG carriers lose the waiver antecedent while its guarded consequent remains" 1 "denial-scope/retrieval-obligation clause(s) missing" runlocal "$d"
d=$(owner_copy L3db); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/Skip it only on explicit waiver or unavoidable unavailability//g' "$d/$f"; done; record "NEG carriers lose the sole exception bound while the read-order heading remains" 1 "denial-scope/retrieval-obligation clause(s) missing" runlocal "$d"
# L3dc..L3dv guard the P2-3 APERTURE + SOURCE-IDENTITY clauses (check 11e): the declared-ingress-aperture /
# relay-sufficiency amendment (shared + root) and the vendor-neutral mounted-source identity limb folded into
# registry READ-2, deployed to the advisor-bootstrap and generic index templates. One fixture per guarded
# loss per carrier class.
d=$(owner_copy L3dc); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/is sufficient for the scoped placement//g' "$d/$f"; done; record "NEG carriers lose the aperture-sufficiency headline fragment" 1 "aperture/source-identity clause(s) missing" runlocal "$d"
d=$(owner_copy L3dd); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/the relay is the routing grant//g' "$d/$f"; done; record "NEG carriers lose the relay-is-the-routing-grant bound" 1 "aperture/source-identity clause(s) missing" runlocal "$d"
d=$(owner_copy L3de); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/asked to authorize the same route again//g' "$d/$f"; done; record "NEG carriers lose the no-re-authorization bound" 1 "aperture/source-identity clause(s) missing" runlocal "$d"
d=$(owner_copy L3df); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/including a separately operated one — may use the aperture//g' "$d/$f"; done; record "NEG carriers lose the any-ASK-operated-origin bound" 1 "aperture/source-identity clause(s) missing" runlocal "$d"
d=$(owner_copy L3dg); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/need not become the byte courier//g' "$d/$f"; done; record "NEG carriers lose the no-byte-courier bound in the aperture clause" 1 "aperture/source-identity clause(s) missing" runlocal "$d"
d=$(owner_copy L3dh); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/routing remains distinct from feeding, ingestion, disposition, and implementation authority//g' "$d/$f"; done; record "NEG carriers lose the routing-separation bound" 1 "aperture/source-identity clause(s) missing" runlocal "$d"
d=$(owner_copy L3di); perl -0pi -e 's/\*\*Mounted-source display labels are inspection metadata, not source identity\.\*\*//g' "$d/docs/advisor-project-surface-architecture.md"; record "NEG registry loses the source-identity headline" 1 "aperture/source-identity clause(s) missing" runlocal "$d"
d=$(owner_copy L3dj); perl -0pi -e 's/does not establish a duplicate local file, multiple standing mounts, or incorrect mounted bytes//g' "$d/docs/advisor-project-surface-architecture.md"; record "NEG registry loses the non-authoritative-decoration bound" 1 "aperture/source-identity clause(s) missing" runlocal "$d"
d=$(owner_copy L3dk); perl -0pi -e 's{Verify standing-source cardinality and mounted content/version}{}g' "$d/docs/advisor-project-surface-architecture.md"; record "NEG registry loses the cardinality-and-content verification obligation" 1 "aperture/source-identity clause(s) missing" runlocal "$d"
d=$(owner_copy L3dl); perl -0pi -e 's/possible thread-context staleness, not proof that the current upload failed//g' "$d/docs/advisor-project-surface-architecture.md"; record "NEG registry loses the bounded thread-staleness wording" 1 "aperture/source-identity clause(s) missing" runlocal "$d"
d=$(owner_copy L3dm); perl -0pi -e 's/\*\*Mounted-source display labels are inspection metadata, not source identity\.\*\*//g' "$d/templates/advisor-project-bootstrap.template.md"; record "NEG advisor-bootstrap loses the source-identity headline" 1 "aperture/source-identity clause(s) missing" runlocal "$d"
d=$(owner_copy L3dn); perl -0pi -e 's/does not establish a duplicate local file, multiple standing mounts, or incorrect mounted bytes//g' "$d/templates/advisor-project-bootstrap.template.md"; record "NEG advisor-bootstrap loses the non-authoritative-decoration bound" 1 "aperture/source-identity clause(s) missing" runlocal "$d"
d=$(owner_copy L3do); perl -0pi -e 's{Verify standing-source cardinality and mounted content/version}{}g' "$d/templates/advisor-project-bootstrap.template.md"; record "NEG advisor-bootstrap loses the cardinality-and-content verification obligation" 1 "aperture/source-identity clause(s) missing" runlocal "$d"
d=$(owner_copy L3dp); perl -0pi -e 's/possible thread-context staleness, not proof that the current upload failed//g' "$d/templates/advisor-project-bootstrap.template.md"; record "NEG advisor-bootstrap loses the bounded thread-staleness wording" 1 "aperture/source-identity clause(s) missing" runlocal "$d"
d=$(owner_copy L3dq); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/the aperture confers nothing beyond the one exact create//g' "$d/$f"; done; record "NEG carriers lose the nothing-beyond-one-create bound" 1 "aperture/source-identity clause(s) missing" runlocal "$d"
d=$(owner_copy L3dr); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/material outside the declared payload class//g' "$d/$f"; done; record "NEG carriers lose the payload-class bound" 1 "aperture/source-identity clause(s) missing" runlocal "$d"
d=$(owner_copy L3ds); perl -0pi -e 's/use exact bytes or hashes where identity is load-bearing//g' "$d/docs/advisor-project-surface-architecture.md"; record "NEG registry loses the load-bearing-identity obligation" 1 "aperture/source-identity clause(s) missing" runlocal "$d"
d=$(owner_copy L3dt); perl -0pi -e 's/use exact bytes or hashes where identity is load-bearing//g' "$d/templates/advisor-project-bootstrap.template.md"; record "NEG advisor-bootstrap loses the load-bearing-identity obligation" 1 "aperture/source-identity clause(s) missing" runlocal "$d"
d=$(owner_copy L3du); perl -0pi -e 's/inspection metadata, not source identity//g' "$d/templates/_INDEX-project.template.md"; record "NEG index template loses the source-identity form" 1 "aperture/source-identity clause(s) missing" runlocal "$d"
d=$(owner_copy L3dv); perl -0pi -e 's/not the displayed filename//g' "$d/templates/_INDEX-project.template.md"; record "NEG index template loses the verify-not-the-label form" 1 "aperture/source-identity clause(s) missing" runlocal "$d"
# L3dw..L3ea guard the R1 residual-precision corrections (check 11f): the template ARRO sentence's "authorized"
# qualifier, the OVL-ECO-2 per-hosted-Project topology (UO homes two hosted Projects), the registry's
# census-per-hosted-Project precision, and the state-agnostic PCS metadata in the core-ecology profile
# (current carrier/hold state lives only in the operator ledger). One fixture per guarded loss.
d=$(owner_copy L3dw); perl -0pi -e 's/retrievable through the authorized mapped route/retrievable through the mapped route/g' "$d/templates/advisor-project-bootstrap.template.md"; record "NEG advisor-bootstrap drops the authorized qualifier from the mapped route" 1 "advisor-bootstrap:{authorized-mapped-route}" runlocal "$d"
d=$(owner_copy L3dx); perl -0pi -e 's/^(\| OVL-ECO-2 .*?)TMK-facing domain-authority review/${1}second review surface/m' "$d/docs/advisor-project-surface-architecture.md"; record "NEG OVL-ECO-2 loses the two-UO-hosted-Projects topology" 1 "architecture:{OVL-ECO-2 two-UO-hosted-Projects}" runlocal "$d"
# the registry is hard-wrapped: this sentence spans a line break in the raw bytes (the check flattens before
# matching), so the mutation must target \s+ or it silently no-ops and reports a false PASS-shaped rc=0.
d=$(owner_copy L3dy); perl -0pi -e 's/Census each\s+hosted Project, not each repo/Census each repo/g' "$d/docs/advisor-project-surface-architecture.md"; record "NEG registry loses the census-per-hosted-Project precision" 1 "architecture:{census-per-hosted-Project}" runlocal "$d"
d=$(owner_copy L3dz); perl -0pi -e 's/applicable to this profile\./applicable to this profile, no carrier yet./ or die' "$d/protocol/profiles/core-ecology.md"; record "NEG core-ecology metadata regains a current PCS carrier-state claim" 1 "core-ecology:{current PCS carrier-state claim" runlocal "$d"
d=$(owner_copy L3ea); perl -0pi -e 's/live only in the operator protocol-consumer ledger/live in this profile/g' "$d/protocol/profiles/core-ecology.md"; record "NEG core-ecology metadata loses the ledger-owns-PCS-state pointer" 1 "core-ecology:{ledger-owns-PCS-state pointer}" runlocal "$d"
d=$(owner_copy L3eb); perl -0pi -e 's/retrievable through the authorized mapped route/retrievable through the mapped route/g' "$d/docs/advisor-project-surface-architecture.md"; record "NEG registry acceptance prose drops the authorized qualifier" 1 "architecture:{authorized-mapped-route}" runlocal "$d"
d=$(owner_copy L3ec); perl -0pi -e 's/retrievable through the authorized mapped route/retrievable through the mapped route/g' "$d/docs/project-instantiation-workflow.md"; record "NEG instantiation workflow drops the authorized qualifier" 1 "instantiation:{authorized-mapped-route}" runlocal "$d"
d=$(owner_copy L3ed); perl -0pi -e 's/personal-context-system applicability is declared here/personal-context-system = applicable-no-carrier/ or die' "$d/protocol/manifest.json"; record "NEG manifest note regains the applicable-no-carrier state label" 1 "manifest:{applicable-no-carrier label" runlocal "$d"
d=$(owner_copy L3ee); perl -0pi -e 's/lives only in the operator protocol-consumer ledger/lives in this manifest/ or die' "$d/protocol/manifest.json"; record "NEG manifest note loses the ledger-owns-PCS-state pointer" 1 "manifest:{ledger-owns-PCS-state pointer}" runlocal "$d"
# the subtle umbrella-category error: the row keeps its two-Project inventory (TMK-facing text intact)
# but re-collapses the role-neutral "hosted Projects" umbrella into "hosted advisor Projects" — which
# misclassifies UO-TMK (a hosted domain-authority Project, not an advisor Project).
d=$(owner_copy L3ef); perl -0pi -e 's/^(\| OVL-ECO-2 .*?)hosted Projects\*\*/${1}hosted advisor Projects**/m or die' "$d/docs/advisor-project-surface-architecture.md"; record "NEG OVL-ECO-2 re-collapses the umbrella to advisor-role while keeping the TMK-facing inventory" 1 "architecture:{OVL-ECO-2 collapsed advisor-role umbrella" runlocal "$d"
# isolate the NEGATIVE guard: keep the role-neutral umbrella intact and reintroduce the advisor-role
# collapse in the row's topology clause instead — only the forbidden-phrase assertion can catch this.
d=$(owner_copy L3eg); perl -0pi -e 's/^(\| OVL-ECO-2 .*?)homes two hosted Projects/${1}homes two hosted advisor Projects/m or die' "$d/docs/advisor-project-surface-architecture.md"; record "NEG OVL-ECO-2 topology clause re-collapses to advisor-role while the umbrella stays role-neutral" 1 "architecture:{OVL-ECO-2 collapsed advisor-role umbrella" runlocal "$d"
d=$(owner_copy L3ba); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/\*\*Truth preservation and contractual locators\.\*\*//g' "$d/$f"; done; record "NEG carriers lose the truth-preservation carve-out" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
d=$(owner_copy L3bb); perl -0pi -e 's/terminal outstanding-feed-obligation overlay/unconsumed feed-queue marker/g' "$d/protocol/AGENTS.shared.md"; record "NEG outgoing unconsumed-feed-queue framing reintroduced" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
# the bootstrap template is hard-wrapped, so this sentence spans a line break in the RAW file even though the
# check flattens before matching. The mutation must target the real bytes (\s+), or it silently no-ops and the
# fixture reports a false PASS-shaped rc=0 against an unmutated tree.
d=$(owner_copy L3bc); perl -0pi -e 's/a -PTX may carry the\s+terminal -TBI overlay/a -PTX never carries the terminal -TBI overlay/g' "$d/templates/advisor-project-bootstrap.template.md"; record "NEG advisor-bootstrap loses PTX overlay eligibility" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
# L3bd..L3bh guard the three overlay-resolution mechanics the landed method owner carries: WHOSE read satisfies
# the obligation, the bounded already-read recovery, and the non-feed cancellation exit. Each is separately
# droppable from a carrier that states the branch table correctly, which is exactly why each needs its own guard.
d=$(owner_copy L3bd); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/A source-side inspection — reading a governing record, verifying bytes, or consulting an inspection copy — does not satisfy it/A source-side inspection also satisfies it/g' "$d/$f"; done; record "NEG source-side inspection falsely satisfies the feed obligation" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
d=$(owner_copy L3be); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/Record the successful read and the unresolved-role\/state exception//g' "$d/$f"; done; record "NEG already-read ambiguity resolved without an exception record" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
d=$(owner_copy L3bf); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/treat \*\*terminal `-TBI` alone\*\* as temporarily non-authoritative feed-obligation evidence/treat the filename as temporarily non-authoritative queue evidence/g' "$d/$f"; done; record "NEG whole filename demoted instead of terminal -TBI alone" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
d=$(owner_copy L3bg); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/it is \*\*not\*\* ingestion, \*\*not\*\* a disposition, and \*\*not\*\* a `decline`/it is a decline/g' "$d/$f"; done; record "NEG cancellation misread as ingestion or decline" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
d=$(owner_copy L3bh); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/\*\*A fresh routed handoff may never become bare and unmarked this way\*\*//g' "$d/$f"; done; record "NEG fresh handoff may silently become bare through cancellation" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
# L3bi..L3bk guard the three Stage-2 clusters. L3bi is the important one: the advisor-architecture REGISTRY is
# the semantic source the bootstrap is generated from, so a withdrawn rule surviving there can be reintroduced
# at the next regeneration even while every generated carrier is correct. A token-presence check cannot catch
# that — the earlier suite verified `LIFE-5c` existed, not what the row said, and the prohibition survived.
d=$(owner_copy L3bi); perl -0pi -e 's/the PTX artifact itself \*\*may carry terminal `-TBI`\*\*.*?project truth\./do not stack `-PTX` with `-TBI`./s' "$d/docs/advisor-project-surface-architecture.md"; record "NEG advisor registry reintroduces the PTX no-stacking prohibition" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
# The two-axis evidence model: terminal -TBI is NOT disposition evidence and is excluded from the agreement check.
d=$(owner_copy L3bj); for f in protocol/AGENTS.shared.md AGENTS.md; do perl -0pi -e 's/UNDERLYING DURABLE-STATE MARKER, never with terminal -TBI/filename marker, including terminal -TBI/g' "$d/$f"; done; record "NEG two-axis filename evidence re-collapsed into one" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
# The state machine must stay scoped to the fresh-awaiting-first-ingestion state, not all -TBI artifacts.
d=$(owner_copy L3bk); perl -0pi -e 's/\*\*State machine — scoped to the fresh-handoff state\.\*\* For a \*\*fresh routed handoff awaiting first ingestion\*\*:/**State machine.**/g' "$d/docs/advisor-project-surface-architecture.md"; record "NEG registry state machine broadened to every -TBI artifact" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
# L3bl guards the DISTRIBUTABLE core-ecology profile. The mutation is applied to BOTH the owner profile and the
# resolved root block so owner/root byte parity still holds -- parity proves the two agree, not that they are
# right, so this fixture proves the new SEMANTIC assertion is what rejects the defect, not the parity check.
d=$(owner_copy L3bl); for f in protocol/profiles/core-ecology.md AGENTS.md; do perl -0pi -e 's/The \*\*handoff-marker use\*\* of `-TBI` applies to material crossing between separately-operated or walled surfaces\. The orthogonal terminal overlay may also be applied to an eligible same-surface artifact or addressed copy under the preceding rule\./`-TBI` applies to material crossing between separately-operated or walled surfaces./g' "$d/$f"; done; record "NEG core-ecology profile reverts to cross-surface-only -TBI (owner+root, parity preserved)" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
# The ingestion-evidence boundary: content read IS ingestion. A carrier that inserts a step between them
# reintroduces the "fed but somehow not ingested after reading it" gap the four-event model closed.
d=$(owner_copy L3au); perl -0pi -e 's/Successful content read into active context \*is\* ingestion/Fetched \x{2260} read into context \x{2260} ingested/g' "$d/templates/_INDEX-project.template.md"; record "NEG index template breaks content-read = ingestion" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
d=$(owner_copy L3av); perl -0pi -e 's/no routed artifact ingested unless its exact filename is an exception//g' "$d/templates/_INDEX-project.template.md"; record "NEG index template loses operative FROZEN semantics" 1 "routed-instance lifecycle clause(s) missing or stale" runlocal "$d"
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

# ---- Stage-2 exact-head additions (B1/B2/B4/B5) ----
# B2: root local-delta markers removed (--local)
d=$(owner_copy B2root); perl -0pi -e 's/<!-- BEGIN local-delta -->//' "$d/AGENTS.md"; record "NEG root local-delta markers removed" 1 "root local-delta markers not exactly once" runlocal "$d"
# B1: git fetch failure with a stale local ref (origin deleted, origin/main still cached)
build_consumer method-ASK core-ecology n direct-core "$OWNER_PIN"; rm -rf "$WORK/consumers/method-ASK.git"
record "NEG git fetch failure (stale local ref)" 1 "git fetch failed" mkwave method-ASK direct-core
# B4: carrier-metadata fixed fields + grant id/pin + byte identity
build_consumer method-ASK core-ecology n direct-core "$OWNER_PIN"; mutate_consumer method-ASK 's/CARRIER_TYPE: resolved-local/CARRIER_TYPE: bogus-type/'
record "NEG wrong CARRIER_TYPE" 1 "CARRIER_TYPE" mkwave method-ASK direct-core
build_consumer method-ASK core-ecology n direct-core "$OWNER_PIN"; mutate_consumer method-ASK 's{SHARED_BLOCK_SOURCE: apexSolarKiss/control-surface/protocol/AGENTS.shared.md}{SHARED_BLOCK_SOURCE: evil/other/AGENTS.shared.md}'
record "NEG wrong SHARED_BLOCK_SOURCE" 1 "SHARED_BLOCK_SOURCE" mkwave method-ASK direct-core
build_consumer asset-pipeline-ASK - y separately-operated "$OWNER_PIN"; mutate_consumer asset-pipeline-ASK 's/GRANT_FRAGMENT: standing-upstream-conformance-grant@/GRANT_FRAGMENT: wrong-grant-id@/'
record "NEG wrong grant fragment id" 1 "GRANT_FRAGMENT id" mkwave asset-pipeline-ASK separately-operated
build_consumer asset-pipeline-ASK - y separately-operated "$OWNER_PIN"; mutate_consumer asset-pipeline-ASK 's/(GRANT_FRAGMENT: standing-upstream-conformance-grant@).*/${1}0000000000000000000000000000000000000000/'
record "NEG grant pin != SHARED_BLOCK_PIN" 1 "GRANT_FRAGMENT pin" mkwave asset-pipeline-ASK separately-operated
build_consumer asset-pipeline-ASK - y separately-operated "$OWNER_PIN"; mutate_consumer asset-pipeline-ASK 's/(<!-- BEGIN grant: standing-upstream-conformance-grant -->\n)/${1}\n/'
record "NEG grant blank-line drift (byte identity enforced)" 1 "grant DRIFT vs fragment" mkwave asset-pipeline-ASK separately-operated
# B5: profile applicability + exclusion + required-completeness + multi-profile parsing
build_consumer asset-pipeline-ASK core-ecology y separately-operated "$OWNER_PIN"
record "NEG AP adopts excluded core-ecology" 1 "explicit_exclusions" mkwave asset-pipeline-ASK separately-operated
build_consumer method-ASK - n direct-core "$OWNER_PIN"
record "NEG direct-core omits required core-ecology" 1 "missing required profile core-ecology" mkwave method-ASK direct-core
build_consumer method-ASK architecture-uncertain n direct-core "$OWNER_PIN"
record "NEG opt-in-only omits required core-ecology" 1 "missing required profile core-ecology" mkwave method-ASK direct-core
build_consumer method-ASK core-ecology n direct-core "$OWNER_PIN"
record "POS direct-core installs required core-ecology" 0 "ALL CHECKS PASSED" mkwave method-ASK direct-core
build_consumer method-ASK "core-ecology architecture-uncertain" n direct-core "$OWNER_PIN"
record "POS multi-profile: core-ecology + architecture-uncertain" 0 "ALL CHECKS PASSED" mkwave method-ASK direct-core
# B5b: a SEPARATELY-OPERATED consumer bound by a profile. advisor-project-surface is the first profile whose
# applies_to crosses the direct-core boundary, so required-completeness had never been exercised for AP/UO.
build_consumer asset-pipeline-ASK - y separately-operated "$OWNER_PIN"
record "NEG separately-operated omits required advisor-project-surface" 1 "missing required profile advisor-project-surface" mkwave asset-pipeline-ASK separately-operated
build_consumer asset-pipeline-ASK advisor-project-surface y separately-operated "$OWNER_PIN"
record "POS separately-operated carries advisor-project-surface" 0 "ALL CHECKS PASSED" mkwave asset-pipeline-ASK separately-operated

# ---- OPTIONAL: real workspace map (path-driven, off by default) ----
if [ -n "${REAL_ECOLOGY_MAP:-}" ] && [ -f "${REAL_ECOLOGY_MAP}" ]; then
  record "OPT --all real ecology (expect UNRESOLVED)" 1 "" runmode --all "$REAL_ECOLOGY_MAP"
else
  echo "  (optional real-ecology --all test skipped; set REAL_ECOLOGY_MAP=<map.json> to enable)"
fi

echo; echo "=== $OUT ==="; cat "$OUT"
echo; echo "PASS=$PASSES  FAIL=$FAILS"
[ "$FAILS" -eq 0 ]
