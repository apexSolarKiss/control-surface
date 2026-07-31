#!/usr/bin/env bash
# protocol/check.sh — deterministic, fail-closed local checker. NO CI.
# REQUIRED tooling: jq, python3, and the python3 `jsonschema` package. A missing dependency is a FAILURE, not a pass.
# Modes: --local | --wave <consumer-map.json> | --all <consumer-map.json>
# Exit 0 ONLY if every assertion passes. Any FAIL / missing input / unresolved lookup / drift / missing dep => exit 1.
#
# Owner-pin model: $ROOT (the repo that carries this protocol/ tree) IS the owner repo. A resolved CONSUMER carries a
# SHARED_BLOCK_PIN that must be a real 40-hex commit in $ROOT whose protocol/AGENTS.shared.md byte-equals the installed
# shared block. The control-surface owner's OWN root uses the sentinel `self-resolving-owner-root` (it is the pin).
set -u -o pipefail
MODE="${1:---local}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SHARED="$ROOT/protocol/AGENTS.shared.md"; MANIFEST="$ROOT/protocol/manifest.json"; SCHEMA="$ROOT/protocol/manifest.schema.json"
ROOTAGENTS="$ROOT/AGENTS.md"; TEMPLATE="$ROOT/templates/AGENTS.template.md"; FRAGMENT="$ROOT/protocol/fragments/standing-upstream-conformance-grant.md"
PROFDIR="$ROOT/protocol/profiles"; OVERLAY="$ROOT/templates/overlays/architecture-uncertain-rules.template.md"
IDXTEMPLATE="$ROOT/templates/_INDEX-project.template.md"
APITEMPLATE="$ROOT/templates/advisor-project-instructions.template.md"; INSTDOC="$ROOT/docs/project-instantiation-workflow.md"
APBOOT="$ROOT/templates/advisor-project-bootstrap.template.md"; APARCH="$ROOT/docs/advisor-project-surface-architecture.md"
ECOPROMPT="$ROOT/prompts/ecology-critique-execution-prompt.md"
INSTPROMPT="$ROOT/prompts/project-instantiation-initial-prompt.md"; CRITDOC="$ROOT/docs/critique-protocol.md"
# immutable activated_by grammar (ERE): '#<PR> / <hex>[ (note)]' | '<hex>[ (note)]' | 'legacy: <text>'
PROV_RE='^(#[0-9]+ / [0-9a-f]{7,40}( \(.*\))?|[0-9a-f]{7,40}( \(.*\))?|legacy: .+)$'
fail=0
FAIL(){ printf 'FAIL : %s\n' "$*"; fail=1; }; OKAY(){ printf 'ok   : %s\n' "$*"; }; UNRES(){ printf 'UNRESOLVED : %s\n' "$*"; fail=1; }
extract(){ awk -v a="$1" -v b="$2" 'index($0,a){f=1;next} index($0,b){f=0} f'; }

require_deps(){
  command -v jq >/dev/null 2>&1 || { FAIL "jq required, not found"; exit 1; }
  command -v python3 >/dev/null 2>&1 || { FAIL "python3 required, not found"; exit 1; }
  python3 -c "import jsonschema" 2>/dev/null || { FAIL "python3 'jsonschema' package required, not importable (pip install jsonschema)"; exit 1; }
}

# ---- owner-repo pin helpers ($ROOT is the owner repo) ----
owner_has_commit(){ git -C "$ROOT" rev-parse --verify --quiet "$1^{commit}" >/dev/null 2>&1; }
owner_shared_at(){ git -C "$ROOT" show "$1:protocol/AGENTS.shared.md" 2>/dev/null; }
OWNER=$(jq -r '.consumers|to_entries[]|select(.value.role!=null and (.value.role|test("owner")))|.key' "$MANIFEST" 2>/dev/null | head -1)

manifest_validate(){
  # (0) formal JSON Schema — REQUIRED, fail-closed
  python3 -c "import json,jsonschema; jsonschema.validate(json.load(open('$MANIFEST')),json.load(open('$SCHEMA')))" 2>/tmp/_js.$$ \
    && OKAY "manifest validates against manifest.schema.json (jsonschema)" \
    || FAIL "manifest fails manifest.schema.json: $(head -3 /tmp/_js.$$ | tr '\n' ' ')"
  rm -f /tmp/_js.$$
  local KNOWN; KNOWN=$(jq -r '.consumers|keys[]' "$MANIFEST")
  # (1) base fields present on every rule
  b=$(jq -r '.rules[]|select((has("rule_id") and has("scope_class") and has("status") and has("failure_mode") and has("active_holds") and has("explicit_exclusions") and has("amended_by"))|not)|.rule_id//"?"' "$MANIFEST"); [ -z "$b" ] && OKAY "base fields present on every rule" || FAIL "missing base fields: $b"
  # (2) vocabularies
  e=$(jq -r '.rules[]|select(.scope_class|IN("shared-core","coordinator","opt-in-grant","profile","candidate")|not)|.rule_id' "$MANIFEST"); [ -z "$e" ] && OKAY "scope_class vocabulary valid" || FAIL "bad scope_class: $e"
  s=$(jq -r '.rules[]|select(.status|IN("candidate","active","held","superseded","retired")|not)|.rule_id' "$MANIFEST"); [ -z "$s" ] && OKAY "status vocabulary valid" || FAIL "bad status: $s"
  cm=$(jq -r '.rules[]|select(has("carrier_mode"))|select(.carrier_mode|IN("resolved-local","referenced","opt-in-fragment","profile")|not)|.rule_id' "$MANIFEST"); [ -z "$cm" ] && OKAY "carrier_mode vocabulary valid" || FAIL "bad carrier_mode: $cm"
  # (3) authority + applicability
  ao=$(jq -r '.rules[]|select(.scope_class|IN("shared-core","candidate"))|select((.authority_owner==null)or(.authority_owner==""))|.rule_id' "$MANIFEST"); [ -z "$ao" ] && OKAY "authority_owner non-null on shared-core/candidate" || FAIL "null authority_owner: $ao"
  at=$(jq -r '.rules[]|select(.scope_class=="shared-core" and .status=="active")|select((.applies_to|length)==0)|.rule_id' "$MANIFEST"); [ -z "$at" ] && OKAY "active shared-core have non-empty applies_to" || FAIL "empty applies_to: $at"
  # (4) every applies_to / exclusion / grant_eligibility name is a declared consumer
  bad=""; for c in $(jq -r '.rules[]|(.applies_to[]?,.explicit_exclusions[]?,.grant_eligibility[]?)' "$MANIFEST" | sort -u); do printf '%s\n' $KNOWN | grep -qx "$c" || bad="$bad $c"; done
  [ -z "$bad" ] && OKAY "all applies_to/exclusions/grant_eligibility are declared consumers" || FAIL "unknown consumer names:$bad"
  # (5) provenance lifecycle (backstops schema): candidate/held null-activation + non-null nomination; active immutable syntax
  ci=$(jq -r '.rules[]|select(.status|IN("candidate","held"))|select(.activated_by!=null)|.rule_id' "$MANIFEST"); [ -z "$ci" ] && OKAY "candidate/held have null activated_by" || FAIL "candidate/held with activation provenance: $ci"
  pn=$(jq -r '.rules[]|select(.status|IN("candidate","held"))|select((.proposed_by==null)or(.proposed_by==""))|.rule_id' "$MANIFEST"); [ -z "$pn" ] && OKAY "candidate/held carry a proposed_by nomination" || FAIL "candidate/held missing proposed_by: $pn"
  local ab rid bads=""; while IFS= read -r line; do ab="${line#*|}"; rid="${line%|*}"; printf '%s' "$ab" | grep -qE "$PROV_RE" || bads="$bads $rid"; done < <(jq -r '.rules[]|select(.status=="active")|"\(.rule_id)|\(.activated_by//"")"' "$MANIFEST")
  [ -z "$bads" ] && OKAY "every active rule.activated_by is immutable provenance syntax" || FAIL "active rules with non-immutable activated_by:$bads"
  # (6) hold referential integrity BOTH directions + held carries a hold
  hi=""; for h in $(jq -r '.rules[].active_holds[]?' "$MANIFEST" | sort -u); do jq -e --arg h "$h" '.holds[]|select(.hold_id==$h)' "$MANIFEST" >/dev/null || hi="$hi $h"; done
  [ -z "$hi" ] && OKAY "every rule.active_holds -> a declared hold" || FAIL "undeclared holds referenced:$hi"
  hb=""; for b2 in $(jq -r '.holds[].blocks[]?' "$MANIFEST" | sort -u); do jq -e --arg b "$b2" '.rules[]|select(.rule_id==$b)' "$MANIFEST" >/dev/null || hb="$hb $b2"; done
  [ -z "$hb" ] && OKAY "every hold.blocks -> a real rule" || FAIL "holds block unknown rules:$hb"
  he=$(jq -r '.rules[]|select(.status=="held")|select((.active_holds|length)==0)|.rule_id' "$MANIFEST"); [ -z "$he" ] && OKAY "held rules carry a hold" || FAIL "held without hold: $he"
  # (7) per-scope conditional owners
  co=$(jq -r '.rules[]|select(.scope_class=="coordinator")|select(.carrier_mode!="referenced" or (.replicated_into_consumers!=false) or (.source_anchor==null))|.rule_id' "$MANIFEST"); [ -z "$co" ] && OKAY "coordinator referenced+not-replicated+carrier" || FAIL "coordinator defect: $co"
  gr=$(jq -r '.rules[]|select(.scope_class=="opt-in-grant")|select((has("fragment_owner") and has("grant_eligibility"))|not)|.rule_id' "$MANIFEST"); [ -z "$gr" ] && OKAY "opt-in-grant carries fragment_owner+eligibility" || FAIL "grant defect: $gr"
  pr=$(jq -r '.rules[]|select(.scope_class=="profile")|select((.profile|type)!="string")|.rule_id' "$MANIFEST"); [ -z "$pr" ] && OKAY "profile rules name a profile" || FAIL "profile defect: $pr"
  # (8) profile ids unique; every active profile rule has an owner file
  dup=$(jq -r '.rules[]|select(.scope_class=="profile")|.profile' "$MANIFEST" | sort | uniq -d); [ -z "$dup" ] && OKAY "profile ids unique per profile rule" || FAIL "duplicate profile ids: $dup"
  pf=""; for p in $(jq -r '.rules[]|select(.scope_class=="profile" and .status!="held")|.profile' "$MANIFEST" | sort -u); do [ -f "$PROFDIR/$p.md" ] || pf="$pf $p"; done
  [ -z "$pf" ] && OKAY "every active profile rule has an owner profile file" || FAIL "profile rule without owner file:$pf"
}

external_holds(){
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    local sa="${line#*|}"; local rid="${line%|*}"
    case "$sa" in *"#"*) : ;; *) FAIL "held rule $rid has no external #section anchor"; continue;; esac
    local file="${sa%%#*}" anchor="${sa##*#}" search
    search=$(printf '%s' "$anchor" | tr '-' ' ')
    [ -f "$ROOT/$file" ] || { FAIL "held rule $rid: external carrier $file missing"; continue; }
    grep -qiE "^#+ .*$search" "$ROOT/$file" && OKAY "held rule $rid external carrier+section present ($file#$anchor)" || FAIL "held rule $rid: section '$anchor' not in $file"
  done < <(jq -r '.rules[]|select(.status=="held" and .source_anchor!=null)|"\(.rule_id)|\(.source_anchor)"' "$MANIFEST")
}

# profile id -> does the manifest declare it as a profile rule?
manifest_declares_profile(){ jq -e --arg p "$1" '.rules[]|select(.scope_class=="profile" and .profile==$p)' "$MANIFEST" >/dev/null 2>&1; }
# consumer -> structural class from manifest.consumers
manifest_class(){ jq -r --arg c "$1" '.consumers[$c].operating_surface_class // empty' "$MANIFEST"; }

assert_local(){
  require_deps
  for f in "$SHARED" "$MANIFEST" "$SCHEMA" "$ROOTAGENTS" "$TEMPLATE" "$FRAGMENT" "$OVERLAY" "$IDXTEMPLATE" "$PROFDIR/core-ecology.md" "$PROFDIR/architecture-uncertain.md" "$PROFDIR/advisor-project-surface.md"; do
    [ -f "$f" ] || FAIL "missing owner file: ${f#$ROOT/}"; done
  [ "$fail" -eq 0 ] || return
  # 1 root shared-block parity
  extract "<!-- BEGIN shared: AGENTS.shared.md -->" "<!-- END shared -->" < "$ROOTAGENTS" > /tmp/_rb.$$ || true
  { [ -s /tmp/_rb.$$ ] && diff -q "$SHARED" /tmp/_rb.$$ >/dev/null; } && OKAY "root shared-block == AGENTS.shared.md" || FAIL "root shared-block missing/DIFFERS"; rm -f /tmp/_rb.$$
  # 1b root carries every applicable profile at byte parity + carrier-metadata w/o placeholders
  for p in $(jq -r '.rules[]|select(.scope_class=="profile" and (.applies_to|index("control-surface")))|.profile' "$MANIFEST"); do
    extract "<!-- BEGIN profile-body: $p -->" "<!-- END profile-body: $p -->" < "$PROFDIR/$p.md" > /tmp/_op.$$
    extract "<!-- BEGIN profile: $p -->" "<!-- END profile: $p -->" < "$ROOTAGENTS" > /tmp/_rp.$$
    { [ -s /tmp/_rp.$$ ] && diff -q /tmp/_op.$$ /tmp/_rp.$$ >/dev/null; } && OKAY "root carries applicable profile $p == owner body" || FAIL "root missing/drift applicable profile $p"
    rm -f /tmp/_op.$$ /tmp/_rp.$$
  done
  extract "<!-- BEGIN carrier-metadata -->" "<!-- END carrier-metadata -->" < "$ROOTAGENTS" > /tmp/_rm.$$
  { [ -s /tmp/_rm.$$ ] && ! grep -qE "<owner-merge-commit>|<direct-core|placeholder" /tmp/_rm.$$; } && OKAY "root carrier-metadata present + no placeholders" || FAIL "root carrier-metadata missing or has placeholders"; rm -f /tmp/_rm.$$
  # 2 coordinator/grant not leaked into shared/template
  grep -qE "Serialize under one parent coordinator|Standing mechanical maintenance lane|GREEN / AMBER / RED / HANDOFF" "$SHARED" && FAIL "coordinator body in shared" || OKAY "no coordinator body in shared"
  for f in "$SHARED" "$TEMPLATE"; do grep -q "grants the \*\*active ASK control surface\*\* standing write jurisdiction" "$f" && FAIL "grant body in ${f#$ROOT/}"; done; OKAY "grant body not inlined in shared/template"
  head -1 "$FRAGMENT" | grep -q "^## Standing upstream conformance grants" && OKAY "fragment is body-only" || FAIL "fragment not body-only"
  # 3 rule-marker coverage both directions
  grep -oE "<!-- rule-id: [a-z0-9-]+ -->" "$SHARED" | sed -E 's/<!-- rule-id: (.*) -->/\1/' | sort > /tmp/_mk.$$
  [ -z "$(uniq -d /tmp/_mk.$$)" ] || FAIL "duplicate markers: $(uniq -d /tmp/_mk.$$)"
  jq -r '.rules[]|select(.carrier_mode=="resolved-local" and .source_anchor!=null)|.rule_id' "$MANIFEST" | sort > /tmp/_rq.$$
  [ -z "$(comm -23 /tmp/_rq.$$ /tmp/_mk.$$)" ] && OKAY "every marker-requiring rule has a marker" || FAIL "rules missing marker: $(comm -23 /tmp/_rq.$$ /tmp/_mk.$$)"
  [ -z "$(comm -13 /tmp/_rq.$$ /tmp/_mk.$$)" ] && OKAY "every marker maps to a rule" || FAIL "orphan markers: $(comm -13 /tmp/_rq.$$ /tmp/_mk.$$)"; rm -f /tmp/_mk.$$ /tmp/_rq.$$
  # 4 headings map
  un=""; while IFS= read -r h; do case "$h" in "## Repo Workflow Discipline"|"## Refresh Cadences"|"## Short Version") continue;; esac; jq -e --arg h "$h" '[.rules[]|select(.source_anchor==$h)]|length>0' "$MANIFEST" >/dev/null 2>&1 || un="$un\n    $h"; done < <(grep -E '^## ' "$SHARED")
  [ -z "$un" ] && OKAY "every shared H2 heading maps to a rule" || FAIL "unmapped headings:$(printf "$un")"
  # 5 full manifest schema + relational integrity + external holds
  manifest_validate
  external_holds
  # 6 no live consumer state in manifest.consumers
  lk=$(jq -r '.consumers|to_entries[]|select(.value.maintenance_authority_mode or .value.carrier_state or .value.hold_state or .value.propagation_status or .value.conformance_pin or .value.grant_state)|.key' "$MANIFEST"); [ -z "$lk" ] && OKAY "manifest consumers structural-only" || FAIL "live state in manifest: $lk"
  # 7 profile-body <-> overlay parity + core-ecology fence
  extract "<!-- BEGIN profile-body: architecture-uncertain -->" "<!-- END profile-body: architecture-uncertain -->" < "$PROFDIR/architecture-uncertain.md" > /tmp/_pb.$$
  extract "<!-- BEGIN profile-body: architecture-uncertain -->" "<!-- END profile-body: architecture-uncertain -->" < "$OVERLAY" > /tmp/_ob.$$
  { [ -s /tmp/_pb.$$ ] && diff -q /tmp/_pb.$$ /tmp/_ob.$$ >/dev/null; } && OKAY "architecture-uncertain profile-body == overlay" || FAIL "architecture-uncertain profile/overlay drift"; rm -f /tmp/_pb.$$ /tmp/_ob.$$
  # every non-held profile rule's owner file carries a closed profile-body fence (generic: no per-profile edit)
  for p in $(jq -r '.rules[]|select(.scope_class=="profile" and .status!="held")|.profile' "$MANIFEST" | sort -u); do
    grep -q "<!-- BEGIN profile-body: $p -->" "$PROFDIR/$p.md" && grep -q "<!-- END profile-body: $p -->" "$PROFDIR/$p.md" && OKAY "$p has a profile-body fence" || FAIL "$p lacks a profile-body fence"; done
  # 8 template marker surfaces + carrier-metadata + payload-free
  for m in "<!-- BEGIN shared: AGENTS.shared.md -->" "<!-- BEGIN profiles -->" "<!-- BEGIN grant" "<!-- BEGIN local-delta -->" "<!-- BEGIN carrier-metadata -->"; do
    grep -q "$m" "$TEMPLATE" && OKAY "template has surface: $m" || FAIL "template missing surface: $m"; done
  for k in CARRIER_TYPE SHARED_BLOCK_SOURCE SHARED_BLOCK_PIN PROFILES GRANT_FRAGMENT OPERATING_SURFACE; do
    grep -q "^$k:" "$TEMPLATE" && OKAY "carrier-metadata field $k present" || FAIL "carrier-metadata missing $k"; done
  grep -q "One writer at a time per branch" "$TEMPLATE" && FAIL "template inlines shared payload" || OKAY "template not inlining payload"
  # 8b template profiles surface must not carry an active (installed-looking) profile marker
  extract "<!-- BEGIN profiles -->" "<!-- END profiles -->" < "$TEMPLATE" | grep -qE "^[[:space:]]*<!-- BEGIN profile: [a-z0-9-]+ -->" && FAIL "template profiles surface carries an installed-looking profile marker" || OKAY "template profiles surface is placeholder-only"
  # 8c advisor source-index template routes to the shared-protocol architecture (future-project inheritance:
  #    a new project can receive the corrected advisor instructions and still mount an index with no route to
  #    the files those instructions require)
  grep -q "^### Shared execution-protocol architecture" "$IDXTEMPLATE" && OKAY "index template carries the shared-protocol architecture section" || FAIL "index template missing '### Shared execution-protocol architecture'"
  local idxmiss="" loc
  for loc in "protocol/README.md" "protocol/AGENTS.shared.md" "protocol/manifest.json" "prompts/cross-repo-propagation-wave.md" "control-surface_protocol-consumer-ledger.md"; do
    grep -qF "$loc" "$IDXTEMPLATE" || idxmiss="$idxmiss $loc"; done
  [ -z "$idxmiss" ] && OKAY "index template maps every shared-protocol locator" || FAIL "index template missing locator(s):$idxmiss"
  # 9 root local delta carries exact BEGIN/END local-delta markers (same contract as consumer carriers)
  local nrb nre; nrb=$(grep -c "<!-- BEGIN local-delta -->" "$ROOTAGENTS"); nre=$(grep -c "<!-- END local-delta -->" "$ROOTAGENTS")
  { [ "$nrb" = "1" ] && [ "$nre" = "1" ]; } && OKAY "root local-delta markers exactly once" || FAIL "root local-delta markers not exactly once ($nrb/$nre)"
  grep -q "## Control-Surface-Local" "$ROOTAGENTS" && OKAY "root local delta present" || FAIL "root local delta missing"
  # 10 execution-topology disposition is documented (coordinator-only; both the local delta and the runbook name it)
  local RUNBOOK="$ROOT/prompts/cross-repo-propagation-wave.md" topomiss="" tok
  for tok in "parallel-subagents" "serial-delegated" "parent-direct-fallback" "parent-direct-exception" "execution_mode" "subagent_capability_check"; do
    { grep -qF "$tok" "$ROOTAGENTS" && grep -qF "$tok" "$RUNBOOK"; } || topomiss="$topomiss $tok"; done
  [ -z "$topomiss" ] && OKAY "execution-topology receipt documented in local delta + runbook" || FAIL "execution-topology token(s) missing from local delta and/or runbook:$topomiss"
  # 11 advisor-retrieval-contract conformance — CLAUSE-SPECIFIC. A generic token that occurs in baseline read-path prose
  #    (e.g. "fallback only") must not satisfy this: verify the exact-review paragraph in the advisor BOOTSTRAP (the
  #    operative contract; MOVED there from the advisor-PI template when the PI was thinned to the pre-retrieval floor
  #    — see docs/advisor-project-surface-architecture.md §Placement contract), the bundle role in the _INDEX scratch
  #    row, and the exact-review route in the instantiation doc, each by exact phrase.
  #    The transport-discipline clauses (#176) are guarded here too: an amendment that removes the pre-PR
  #    condition, the raw-byte rung, the exact-byte no-courier criterion, or the one-alternate cap must FAIL,
  #    not pass silently. Each phrase below is load-bearing; do not relax one to a generic token.
  local advmiss="" ph
  local apiphr=('**Exact-byte review objects.**' 'named `-PROPOSED` review object' 'review bundle' 'reported hash' 'manual upload never bypasses a wall' \
                'The relay is the request' 'raw file bytes' 'exact bytes remain retrievable' 'connector-bounded alternate representation' 'stop and report both failures' \
                'Stage-1 readiness includes the minimum exact review object' 'Direct execution requires an explicit ASK authorization')
  for ph in "${apiphr[@]}"; do grep -qF -- "$ph" "$APBOOT" || advmiss="$advmiss advisor-bootstrap:{$ph}"; done
  grep -qF -- '`-PROPOSED` review objects/bundles' "$IDXTEMPLATE" || advmiss="$advmiss _INDEX:{bundle-role}"
  local instphr=('for exact-byte advisor review' 'mapped shared scratch' 'manual operator upload is fallback only' \
                 'Stage-1 readiness includes the minimum exact review object' 'Direct execution requires an explicit ASK authorization' \
                 'exact path → raw bytes → one bounded alternate representation' 'not exact-byte availability')
  for ph in "${instphr[@]}"; do grep -qF -- "$ph" "$INSTDOC" || advmiss="$advmiss instantiation:{$ph}"; done
  # the ecology-critique execution prompt is a review-sequence carrier too: its deployed operator copy is
  # conformed FROM this canonical, so the restored sequence must be assertable here (found stale by the
  # 2026-07-29 program-closure read; part of the same regression repair).
  local promptphr=('Stage-1 review opens on ASK relay' 'ASK adjudicates on the advisor recommendation')
  for ph in "${promptphr[@]}"; do grep -qF -- "$ph" "$ECOPROMPT" || advmiss="$advmiss ecology-execution-prompt:{$ph}"; done
  # shared-canonical + resolved-root transport clauses — the rule text itself, not only its downstream carriers
  local sharedphr=('**Review-window routing — the relay is the request.**' '**Pre-PR publication condition.**' '**Object reachability is distinct from representation quality.**' \
                   '**Retrieval order.**' '**ASK is the authority relay, not the byte courier.**' '**Bounded fallback.**' 'exact bytes remain retrievable through the authorized mapped route' \
                   'is itself the review request' 'Stage-1 readiness includes the minimum exact review object' 'Direct execution requires an explicit ASK authorization' \
                   '**Missing-object recovery:**' 'authorize no direct execution and no write')
  for ph in "${sharedphr[@]}"; do
    grep -qF -- "$ph" "$SHARED"    || advmiss="$advmiss shared:{$ph}"
    grep -qF -- "$ph" "$ROOTAGENTS" || advmiss="$advmiss root-carrier:{$ph}"
  done
  [ -z "$advmiss" ] && OKAY "advisor-retrieval-contract clauses present (advisor-bootstrap + _INDEX + instantiation + ecology-execution-prompt)" || FAIL "advisor-retrieval-contract clause(s) missing:$advmiss"
  # 11b anti-regression — the retired Stage-1 review exclusion (#172 bootstrap sentence, #176 shared clause,
  #     the passive non-relay direct-execution semantics, and the ASK-as-first-line prompt sentence;
  #     classified a regression against the 2026-07-25 deployed semantics and repaired 2026-07-29) must not
  #     reappear in any checked review-sequence carrier.
  local regmiss="" rp
  local regphr=('not an implicit request for pre-PR advisor review' 'is not a request for your review' \
                'ASK reviews directly; you are not in that loop' 'only on explicit ASK request' \
                'made by not relaying' 'simply not relaying' 'ASK reviews the diff (pre-commit window)')
  for rp in "${regphr[@]}"; do
    grep -qF -- "$rp" "$SHARED"      && regmiss="$regmiss shared:{$rp}"
    grep -qF -- "$rp" "$ROOTAGENTS"  && regmiss="$regmiss root-carrier:{$rp}"
    grep -qF -- "$rp" "$APBOOT"      && regmiss="$regmiss advisor-bootstrap:{$rp}"
    grep -qF -- "$rp" "$INSTDOC"     && regmiss="$regmiss instantiation:{$rp}"
    grep -qF -- "$rp" "$ECOPROMPT"   && regmiss="$regmiss ecology-execution-prompt:{$rp}"
  done
  [ -z "$regmiss" ] && OKAY "retired Stage-1 review exclusion absent (shared + root + advisor-bootstrap + instantiation + ecology-execution-prompt)" || FAIL "retired Stage-1 exclusion reintroduced:$regmiss"
  # 11c throughput discipline — the P2-1 proportionality/termination (Issue B) and executor-preflight (Issue C)
  #     obligations. Guarded at two grains: section HEADLINE anchors plus SUBSTANTIVE phrases from each
  #     obligation a surviving headline could otherwise orphan (the no-waiver gate list, the named-failure-mode
  #     blocking criterion, the frozen-record no-reopen threshold, the rework re-anchor, the partition
  #     non-regeneration bound, the universal parent cold read, the checker-demonstration rule, the readiness
  #     receipt and its fields). Every obligation is guarded at substantive grain; not every bold heading is
  #     itself guarded. A loss of any single guarded phrase fails alone.
  local tdmiss="" tp
  local tdshared=('reversibility × blast radius × cost of error × decision relevance' '**Proportionality never waives a gate.**' \
                  'MATERIAL NON-BLOCKING' 'name the credible failure mode and correct it before proceeding' \
                  'does not reopen, append to, or generate a successor for the frozen object' \
                  '**Correction loops terminate.**' 'the round does not open' \
                  '**Partition every multi-object package by role.**' '**Executor preflight — read the finished object before handing it off.**' \
                  'reload the final bytes from disk and perform one end-to-end parent cold read of the deliverable and its surrounding frame' \
                  'never the delta alone' \
                  '**The parent verifies every internal finding**' 'internal-clean never replaces the external advisor' \
                  'never waives an ASK-owned authorization gate' 're-anchor to the current live owner or baseline' \
                  'never regenerated or forced into semantic parity' 'must demonstrate one real negative or control case' \
                  '**Readiness receipt.**' 'parent semantic self-review: COMPLETE' \
                  'internal adversarial preflight: PERFORMED | NOT TRIGGERED | UNAVAILABLE')
  for tp in "${tdshared[@]}"; do
    grep -qF -- "$tp" "$SHARED"     || tdmiss="$tdmiss shared:{$tp}"
    grep -qF -- "$tp" "$ROOTAGENTS" || tdmiss="$tdmiss root-carrier:{$tp}"
  done
  for tp in '**Proportionate verdicts.**' 'MATERIAL NON-BLOCKING' 'does not require the frozen object to be reopened'; do
    grep -qF -- "$tp" "$APBOOT" || tdmiss="$tdmiss advisor-bootstrap:{$tp}"; done
  grep -qF -- 'REVIEW-13' "$APARCH" || tdmiss="$tdmiss architecture:{REVIEW-13}"
  grep -qF -- 'does not reopen, append to, or generate a successor for a frozen object' "$APARCH" || tdmiss="$tdmiss architecture:{frozen-record-threshold}"
  [ -z "$tdmiss" ] && OKAY "throughput-discipline clauses present (shared + root + advisor-bootstrap + registry)" || FAIL "throughput-discipline clause(s) missing:$tdmiss"
  # 11d TBI-amendment clauses — the P2-2 denial-scope (Private-Memory Write Gate) and retrieval-obligation
  #     (Required Reading) amendments. Same two-grain discipline as 11c: headline anchors plus the operative
  #     sentences a surviving headline could otherwise orphan. A loss of any single guarded phrase fails alone.
  local tamiss=""
  local tashared=('**Denial stops the mutation, not unrelated work.**' 'do not retry it through another tool or surface' \
                  'continue the unrelated task to the extent the task remains independently authorized and technically possible' \
                  'Stop the broader task only when its completion actually depends on the prohibited mutation' \
                  'state that dependency explicitly' \
                  'every pre-flight coverage requirement and stop condition of this gate is unaffected' \
                  '**A named-but-unread governing source is a defect, not a caveat.**' 'Retrieve it before producing the governed output' \
                  'If the active authority explicitly waives the read or the source is technically unavailable' \
                  'state that fact, the reason, and the resulting limit in the same turn' \
                  '**A declared read order is not a cost-benefit input.**' \
                  'Skip it only on explicit waiver or unavoidable unavailability' \
                  'Never silently substitute a live sufficiency judgment or close by proposing the required read as future work')
  for tp in "${tashared[@]}"; do
    grep -qF -- "$tp" "$SHARED"     || tamiss="$tamiss shared:{$tp}"
    grep -qF -- "$tp" "$ROOTAGENTS" || tamiss="$tamiss root-carrier:{$tp}"
  done
  [ -z "$tamiss" ] && OKAY "denial-scope + retrieval-obligation clauses present (shared + root)" || FAIL "denial-scope/retrieval-obligation clause(s) missing:$tamiss"
  # 11e P2-3 aperture + source-identity clauses — the declared-ingress-aperture/relay-sufficiency amendment
  #     (§Cross-Surface Change Routing, shared + root) and the vendor-neutral mounted-source identity limb
  #     folded into registry READ-2, deployed to both declared homes (advisor-bootstrap §Retrieval discipline
  #     + the generic index template's mount posture). Two grains as in 11c/11d: headline anchors plus every
  #     operative sentence. A loss of any single guarded phrase fails alone.
  local apmiss=""
  local apshared=('is sufficient for the scoped placement' 'the relay is the routing grant' \
                  'asked to authorize the same route again' \
                  'including a separately operated one — may use the aperture' \
                  'need not become the byte courier' \
                  'routing remains distinct from feeding, ingestion, disposition, and implementation authority' \
                  'the aperture confers nothing beyond the one exact create' \
                  'material outside the declared payload class')
  for tp in "${apshared[@]}"; do
    grep -qF -- "$tp" "$SHARED"     || apmiss="$apmiss shared:{$tp}"
    grep -qF -- "$tp" "$ROOTAGENTS" || apmiss="$apmiss root-carrier:{$tp}"
  done
  local srcid=('**Mounted-source display labels are inspection metadata, not source identity.**' \
               'does not establish a duplicate local file, multiple standing mounts, or incorrect mounted bytes' \
               'Verify standing-source cardinality and mounted content/version' \
               'use exact bytes or hashes where identity is load-bearing' \
               'possible thread-context staleness, not proof that the current upload failed')
  for tp in "${srcid[@]}"; do
    grep -qF -- "$tp" "$APARCH" || apmiss="$apmiss architecture:{$tp}"
    grep -qF -- "$tp" "$APBOOT" || apmiss="$apmiss advisor-bootstrap:{$tp}"
  done
  for tp in 'inspection metadata, not source identity' 'not the displayed filename'; do
    grep -qF -- "$tp" "$IDXTEMPLATE" || apmiss="$apmiss _INDEX:{$tp}"; done
  [ -z "$apmiss" ] && OKAY "aperture + source-identity clauses present (shared + root + registry + advisor-bootstrap + index template)" || FAIL "aperture/source-identity clause(s) missing:$apmiss"
  # 11f R1 residual precision — two MATERIAL NON-BLOCKING findings banked at the Phase-2 closure smoke round
  #     (2026-07-30): the generated-template ARRO sentence must carry the shared body's "authorized" qualifier
  #     (a resolving route outside the authorized surface must not read as barring an ASK upload election), and
  #     OVL-ECO-2 must record the per-hosted-Project topology (UO homes two hosted Projects; conformance is per
  #     hosted Project, not per repo — the registry census precision must also survive). Plus: the core-ecology
  #     profile's owner metadata stays state-agnostic about PCS carrier state — current carrier/hold/visibility/
  #     propagation state lives only in the operator ledger, never in a slow profile file. Any single loss fails alone.
  local r1miss=""
  local archflat_r1; archflat_r1=$(tr '\n' ' ' < "$APARCH" | tr -s ' ')
  grep -qF -- 'retrievable through the authorized mapped route' "$APBOOT" || r1miss="$r1miss advisor-bootstrap:{authorized-mapped-route}"
  grep -qF -- 'retrievable through the mapped route' "$APBOOT" && r1miss="$r1miss advisor-bootstrap:{unqualified mapped-route}"
  printf '%s' "$archflat_r1" | grep -qF -- 'retrievable through the authorized mapped route' || r1miss="$r1miss architecture:{authorized-mapped-route}"
  printf '%s' "$archflat_r1" | grep -qF -- 'retrievable through the mapped route' && r1miss="$r1miss architecture:{unqualified mapped-route}"
  grep -qF -- 'retrievable through the authorized mapped route' "$INSTDOC" || r1miss="$r1miss instantiation:{authorized-mapped-route}"
  grep -qF -- 'retrievable through the mapped route' "$INSTDOC" && r1miss="$r1miss instantiation:{unqualified mapped-route}"
  awk '/^\| OVL-ECO-2 /' "$APARCH" | grep -qF -- 'TMK-facing domain-authority review' || r1miss="$r1miss architecture:{OVL-ECO-2 two-UO-hosted-Projects}"
  awk '/^\| OVL-ECO-2 /' "$APARCH" | grep -qF -- 'per hosted Project, not per repo' || r1miss="$r1miss architecture:{OVL-ECO-2 per-hosted-Project conformance}"
  awk '/^\| OVL-ECO-2 /' "$APARCH" | grep -qF -- 'separately operated surfaces with their own hosted Projects' || r1miss="$r1miss architecture:{OVL-ECO-2 role-neutral hosted-Projects umbrella}"
  awk '/^\| OVL-ECO-2 /' "$APARCH" | grep -qF -- 'hosted advisor Projects' && r1miss="$r1miss architecture:{OVL-ECO-2 collapsed advisor-role umbrella (UO-TMK is a hosted Project, not an advisor Project)}"
  printf '%s' "$archflat_r1" | grep -qF -- 'Census each hosted Project, not each repo' || r1miss="$r1miss architecture:{census-per-hosted-Project}"
  local r1prof="$PROFDIR/core-ecology.md"
  grep -qF -- 'live only in the operator protocol-consumer ledger' "$r1prof" || r1miss="$r1miss core-ecology:{ledger-owns-PCS-state pointer}"
  grep -qF -- 'no carrier yet' "$r1prof" && r1miss="$r1miss core-ecology:{current PCS carrier-state claim (belongs in the operator ledger)}"
  grep -qF -- 'applicable-no-carrier' "$r1prof" && r1miss="$r1miss core-ecology:{applicable-no-carrier label (belongs in the operator ledger)}"
  # the manifest assertions are scoped to the CURRENT note of the owning rule via jq — whole-file greps
  # would misfire on truthful amended_by provenance that names the retired label historically. Fail closed
  # on any lookup failure: missing jq, unparsable manifest, zero or multiple rule matches, missing/empty note.
  local r1note=""
  if command -v jq >/dev/null 2>&1; then
    r1note=$(jq -er '[.rules[] | select(.rule_id == "inbound-tbi-ecology-intake")]
      | if length != 1 then error("non-unique or missing rule")
        elif (.[0].note | type) != "string" then error("note missing or non-string")
        elif (.[0].note | length) == 0 then error("empty note")
        else .[0].note end' "$MANIFEST" 2>/dev/null) \
      || { r1note=""; r1miss="$r1miss manifest:{inbound-tbi-ecology-intake note lookup FAILED (fail-closed)}"; }
  else
    r1miss="$r1miss manifest:{jq unavailable — note lookup FAILED (fail-closed)}"
  fi
  if [ -n "$r1note" ]; then
    printf '%s' "$r1note" | grep -qF -- 'applicable-no-carrier' && r1miss="$r1miss manifest:{applicable-no-carrier label (belongs in the operator ledger)}"
    printf '%s' "$r1note" | grep -qF -- 'lives only in the operator protocol-consumer ledger' || r1miss="$r1miss manifest:{ledger-owns-PCS-state pointer}"
  fi
  [ -z "$r1miss" ] && OKAY "residual-precision corrections held (authorized route + per-hosted-Project topology + state-agnostic PCS metadata)" || FAIL "advisor-carrier residual clause(s) missing or stale:$r1miss"
  # 12 advisor-surface deployment architecture — the PI template must carry ONLY the pre-retrieval floor, the bootstrap
  #    template must exist and declare the index locator, and the registry must own the placement contract.
  local depmiss="" t
  [ -f "$APBOOT" ] || depmiss="$depmiss missing:advisor-project-bootstrap.template.md"
  [ -f "$APARCH" ] || depmiss="$depmiss missing:advisor-project-surface-architecture.md"
  grep -qF -- 'INDEX_CANONICAL_LOCATOR' "$APBOOT" || depmiss="$depmiss bootstrap:{index-locator}"
  for t in 'PI-FLOOR' 'BOOTSTRAP' 'INDEX' 'SURFACE-OVERLAY'; do
    grep -qF -- "$t" "$APARCH" || depmiss="$depmiss architecture:{$t}"; done
  grep -qF -- 'is not deduplication' "$APARCH" || depmiss="$depmiss architecture:{anti-loss-invariant}"
  for t in 'thin pre-bootstrap floor' 'single standing' 'Do not add operative protocol to this field'; do
    grep -qF -- "$t" "$APITEMPLATE" || depmiss="$depmiss advisor-PI:{$t}"; done
  grep -qF -- 'fetched, not mounted' "$IDXTEMPLATE" || depmiss="$depmiss _INDEX:{live-fetch-posture}"
  [ -z "$depmiss" ] && OKAY "advisor-surface deployment architecture present (floor + bootstrap + live-fetched index + registry)" || FAIL "advisor-surface deployment clause(s) missing:$depmiss"
  # 13 advisor-surface carrier conformance — NEGATIVE assertions. The deployment architecture can be present in the
  #    owner docs while an active carrier still teaches the retired mounted-index shape; that combination is exactly
  #    what a reader follows. Assert the corrected posture AND the absence of the superseded instruction.
  local carrmiss=""
  grep -qF -- 'single standing Markdown Source' "$INSTPROMPT" || carrmiss="$carrmiss instantiation-prompt:{bootstrap-single-standing-source}"
  grep -qF -- "live-fetched at the bootstrap's exact locator" "$INSTPROMPT" || carrmiss="$carrmiss instantiation-prompt:{index-live-fetched}"
  grep -qF -- "mounted as the advisor Project's primary Source" "$INSTPROMPT" && carrmiss="$carrmiss instantiation-prompt:{STALE mounted-primary-Source}"
  grep -qF -- 'fetched, not mounted' "$IDXTEMPLATE" || carrmiss="$carrmiss _INDEX:{live-fetch-posture}"
  grep -qF -- 'mount the index, not copies' "$IDXTEMPLATE" && carrmiss="$carrmiss _INDEX:{STALE mount-the-index}"
  grep -qF -- 'Advisor bootstrap lives at the Project level' "$CRITDOC" || carrmiss="$carrmiss critique:{project-level-heading}"
  grep -qF -- 'thin Project Instructions floor' "$CRITDOC" || carrmiss="$carrmiss critique:{thin-floor-named}"
  grep -qF -- "Advisor bootstrap lives in the GPT Project's Instructions" "$CRITDOC" && carrmiss="$carrmiss critique:{STALE instructions-heading}"
  grep -qF -- 'read-path discipline is installed once at the Project-Instructions level' "$CRITDOC" && carrmiss="$carrmiss critique:{STALE carrier-assignment}"
  grep -qF -- 'advisor bootstrap §Verification' "$INSTDOC" || carrmiss="$carrmiss instantiation:{verification-pointer-moved}"
  grep -qF -- 'advisor-PI §Verification' "$INSTDOC" && carrmiss="$carrmiss instantiation:{STALE advisor-PI-verification-pointer}"
  # 13b the critique protocol governs a SECOND deployment surface (the fresh mirror Project) and the ordinary
  #     Sources posture. Its heading can read correctly while its body still teaches a mounted index or assigns
  #     the full contract to the Instructions field — assert the corrected body, not just the heading.
  for t in 'same mounted surface bootstrap' 'same thin Project Instructions floor' 'mount **only the surface bootstrap**' 'temporary, task-specific fallback'; do
    grep -qF -- "$t" "$CRITDOC" || carrmiss="$carrmiss critique:{$t}"; done
  for t in 'The Project Instructions carry the advisor bootstrap' 'repointed as the Project-Instructions master' 'should normally mount a **source index / path map**' 'mounted Sources are for bootstrap / source-index' 'identical mounted Sources + Project Instructions'; do
    grep -qF -- "$t" "$CRITDOC" && carrmiss="$carrmiss critique:{STALE $t}"; done
  # 13c the shared bootstrap template must stay surface-neutral and must not re-assert a blanket that the
  #     reconstructed DISAGREE-3 rule revises.
  grep -qF -- 'methodology question is closed externally' "$APBOOT" && carrmiss="$carrmiss bootstrap:{STALE surface-specific method-owner claim}"
  grep -qF -- 'compiling next-step prompts' "$APBOOT" && carrmiss="$carrmiss bootstrap:{STALE blanket next-step-prompt ban (revised by DISAGREE-3)}"
  [ -z "$carrmiss" ] && OKAY "advisor-surface carrier conformance (no active carrier teaches the retired mounted-index shape)" || FAIL "advisor-surface carrier conformance:$carrmiss"
  # 14 advisor-surface anti-loss recovery — the lifecycle subrequirements recovered in the registry must actually be
  #    carried by the bootstrap, or the registry claims coverage the generated carrier does not provide.
  local recmiss="" t
  for t in 'routing-time historical evidence' 'Do not restore a receipt annotation' 'role marker is retained' 'route a separate handoff'; do
    grep -qF -- "$t" "$APBOOT" || recmiss="$recmiss bootstrap:{$t}"; done
  for t in 'LIFE-4a' 'LIFE-4b' 'LIFE-4c' 'LIFE-5a' 'LIFE-5b' 'LIFE-5c' 'PROTO-3' 'Surface-overlay completion gate'; do
    grep -qF -- "$t" "$APARCH" || recmiss="$recmiss architecture:{$t}"; done
  # PROTO-3 executor-carrier delivery — the registry row and the generated carrier must BOTH hold it. This was a
  # real owner-registry omission: the clause shipped in a deployed field, was absent from PROTO-1, and was
  # therefore dropped when a bootstrap was generated from the incomplete registry.
  grep -qF -- 'Executor-carrier delivery' "$APARCH" || recmiss="$recmiss architecture:{PROTO-3 requirement text}"
  bootflat_p3=$(tr '\n' ' ' < "$APBOOT" | tr -s ' ')
  printf '%s' "$bootflat_p3" | grep -qF -- 'verify — do not assume — the executor' || recmiss="$recmiss bootstrap:{PROTO-3 carrier-delivery step}"
  printf '%s' "$bootflat_p3" | grep -qF -- 'it does not establish that the executor *loads* it' || recmiss="$recmiss bootstrap:{PROTO-3 contents-vs-loads distinction}"
  grep -qF -- 'Orientation is on request, not by default' "$APBOOT" || recmiss="$recmiss bootstrap:{startup-orientation-gated}"
  grep -qF -- 'no character limit' "$APBOOT" && recmiss="$recmiss bootstrap:{STALE no-character-limit}"
  [ -z "$recmiss" ] && OKAY "advisor-surface anti-loss recovery carried (lifecycle subrequirements + overlay gate + startup posture)" || FAIL "advisor-surface recovery clause(s) missing:$recmiss"

  # 15 routed-instance lifecycle — POSITIVE clauses in both shared-core carriers, plus NEGATIVE assertions that no
  #    carrier still teaches the outgoing model. The rule is only conformant when both halves hold: stating the
  #    state machine while a stale "leaves the queue when it is fed in" or "-SUPERSEDED" survives elsewhere is
  #    the defect. This check proves CARRIER COVERAGE and stale-semantic rejection only. Whether a real FROZEN
  #    `_STATE.md` actually blocks a live ingestion is an exercised acceptance test at each surface cutover
  #    (Units 5-6), never inferred from a phrase being present here.
  local fevmiss="" ph
  local fevphr=('**Four events, not two.**' '**Route on approval; feed/ingest later.**' \
                'queue exit occurs on recipient-side ingestion, not on the feed attempt' 'paired but not atomic' \
                '**The queue is logical, not a folder.**' 'relocation *within* the queue is not a lifecycle event' \
                'disposition is not implementation authority' 'ASK separately decides when to feed it' \
                'expands no write authority' \
                'terminal outstanding-feed-obligation overlay' \
                'the current feed obligation remains unsatisfied' \
                'It says nothing about earlier successful feeds or prior ingestion history' \
                '**The overlay is orthogonal, not a lifecycle step.**' \
                'the rename records it, it does not cause it' \
                'ASK-side PRE-ingestion retirement disposition' \
                '**Disposition is not absorption.**' \
                'Closure and the terminal rename are one bounded operation' \
                'a bare exact path addressed to an active surface is a feed' \
                '**The relay envelope governs force and scope.**' \
                'A leading `_` alone confers no exemption' \
                '**Resolving the feed-obligation overlay.**' \
                'by the intended active recipient surface, under ASK' \
                'verified fresh routed handoff awaiting first ingestion' \
                'remove only -TBI; the underlying role and durable disposition survive unchanged' \
                'role or prior state unresolved' \
                '**An unresolved role or prior state is a stop condition**' \
                'the discriminator is the fresh-awaiting-first-ingestion **state**, not the artifact class' \
                '**Truth preservation and contractual locators.**' \
                '**Already-read recovery.**' \
                'Record the successful read and the unresolved-role/state exception' \
                'treat **terminal `-TBI` alone** as temporarily non-authoritative feed-obligation evidence' \
                'the underlying artifact identity and any truthful durable-state marker remain authoritative' \
                '**Canceled feed obligation.**' \
                'terminal -TBI             INDEPENDENT, FASTER-AGING evidence of ASK' \
                'Not a disposition; excluded from the' \
                'must agree with the' \
                'UNDERLYING DURABLE-STATE MARKER, never with terminal -TBI' \
                'Terminal `-TBI` neither participates in nor overrides that check' \
                'This applies to a **fresh routed handoff awaiting first ingestion**; anything not currently in that state exits the queue by overlay removal or cancellation' \
                'it is **not** ingestion, **not** a disposition, and **not** a `decline`' \
                'only where the underlying artifact already has an independently complete identity or durable state' \
                '**A fresh routed handoff may never become bare and unmarked this way**' \
                'A source-side inspection — reading a governing record, verifying bytes, or consulting an inspection copy — does not satisfy it' \
                'preserve the original untouched and feed an addressed copy' \
                'Terminal `-TBI` is always the final token before `.md`' \
                'topic-PTX-TBI.md        →  topic-PTX.md        role survives resolution' \
                'A `-PTX` **may** carry the overlay' \
                '**Two boundaries, not one.**' \
                'cross-surface handoff boundary   crossed when material moves between separately' \
                'ordinary active-context ingestion occurs' \
                'It does not create a separate cross-surface handoff boundary' \
                '**This lifecycle grammar is prospective.**')
  for ph in "${fevphr[@]}"; do
    grep -qF -- "$ph" "$SHARED"     || fevmiss="$fevmiss shared:{$ph}"
    grep -qF -- "$ph" "$ROOTAGENTS" || fevmiss="$fevmiss root-carrier:{$ph}"
  done
  # the GENERATED advisor carrier must carry the operative sentences, not merely the headings — a bootstrap that
  # keeps "Four events, not two." while losing the obligations under it is the silent-weakening failure mode.
  local bootphr=('Four events, not two.' 'Route on approval; feed/ingest later.' \
                 'queue exit occurs on recipient-side ingestion, never on the feed attempt' \
                 'intent to ingest is not evidence of completed ingestion' \
                 'relocation within the queue is not a lifecycle event' \
                 'ASK separately controls when to feed the routed artifact' \
                 'grants no new write authority' \
                 'terminal outstanding-feed-obligation overlay' \
                 'Disposition is not absorption, and the record is not optional' \
                 'same bounded operation' \
                 'path resolves ≠ content read ≠ exact-byte identity proven' \
                 'The relay envelope governs operative force and scope' \
                 'a leading `_` alone confers no exemption' \
                 'fails closed for ingestion' \
                 'a -PTX may carry the terminal -TBI overlay' \
                 'fresh routed handoff awaiting first ingestion' \
                 'remove only -TBI' \
                 'governed role and prior lifecycle state' \
                 'read into the intended active recipient surface under ASK' \
                 'does not satisfy the feed' \
                 'record the successful read and the unresolved-role/state exception' \
                 'Demote **terminal -TBI only**, not the whole filename' \
                 'only where the underlying artifact already has an independently complete identity or durable state' \
                 'A fresh routed handoff may not become bare through cancellation' \
                 'terminal `-TBI` is independent, faster-aging evidence of ASK' \
                 'excluded from the disposition-agreement check' \
                 'must agree with the **underlying durable-state marker**, never with terminal `-TBI`' \
                 'This path belongs to a **fresh routed handoff awaiting first ingestion**' \
                 'That instruction governs a **fresh routed-handoff recipient copy**' \
                 'no routed artifact may be ingested unless its exact filename is listed as an exception')
  # the bootstrap template is hard-wrapped, so an operative sentence spans line breaks; flatten before matching or
  # a line-based fixed-string test silently fails on prose that is present and correct.
  local bootflat; bootflat=$(tr '\n' ' ' < "$APBOOT" | tr -s ' ')
  for ph in "${bootphr[@]}"; do
    printf '%s' "$bootflat" | grep -qF -- "$ph" || fevmiss="$fevmiss bootstrap:{$ph}"; done
  # the index template declares the surface's live intake path AND the structural rows — a carrier that names
  # _STATE.md without the "declaration confers the exemption, not the underscore" bound reopens the wildcard.
  local idxflat; idxflat=$(tr '\n' ' ' < "$IDXTEMPLATE" | tr -s ' ')
  for ph in 'intent-INbox/_STATE.md' 'structural — **not routed intent**' \
            'a leading `_` alone confers nothing' \
            'the live path above governs until this surface' \
            'Successful content read into active context *is* ingestion' \
            'no routed artifact ingested unless its exact filename is an exception' \
            'exact filenames or explicitly `NONE`' \
            'terminal `-TBI` is independent feed-obligation evidence' \
            'excluded from the disposition-agreement check' \
            'must agree with the **underlying durable-state marker**, never with terminal `-TBI`'; do
    printf '%s' "$idxflat" | grep -qF -- "$ph" || fevmiss="$fevmiss index-template:{$ph}"; done
  # the manifest failure_mode must name the full class set this rule compensates for
  for ph in 'routing collapsed into feeding' 'feeding collapsed into ingestion' \
            'ingestion misread as automatic disposition, absorption, or normative adoption' \
            'ASK deprived of asynchronous routed-vs-fed queue control' \
            'route-on-approval misread as cross-wall write authority' \
            'a by-reference feed treated as ingestion on path resolution alone' \
            'disposition collapsed into absorption' \
            'a terminal disposition applied without a durable disposition record in the same bounded operation' \
            'an artifact treated as structural because its name begins with an underscore' \
            'historical filenames normalized to the prospective grammar' \
            'metadata-only reachability reported as content read' \
            'treated as satisfying the current feed obligation' \
            'resolved without recording the successful read and the unresolved-role/state exception' \
            'the whole filename demoted as non-authoritative when only terminal -TBI is stale' \
            'cancellation misread as ingestion, decline, or disposition' \
            'silently becoming bare and unmarked through cancellation' \
            'a -TBI used as a handoff marker inside one operating surface' \
            'terminal -TBI treated as disposition evidence or forced to agree with a disposition record'; do
    jq -r '.rules[]|select(.rule_id=="inbound-tbi-marker")|.failure_mode' "$MANIFEST" | grep -qF -- "$ph" || fevmiss="$fevmiss manifest:{$ph}"; done
  jq -r '.rules[]|select(.rule_id=="inbound-tbi-ecology-intake")|.failure_mode' "$MANIFEST" \
    | grep -qF -- 'same-surface overlay eligibility erased by treating all -TBI use as cross-surface handoff marking' \
    || fevmiss="$fevmiss manifest-eco:{same-surface overlay eligibility}"
  for ph in 'a -PTX treated as ineligible for the terminal -TBI feed overlay' \
            'overlay resolution destroying the -PTX role marker or its _vN index' \
            'a fed -PTX misread as a routed handoff, an authority, or project truth'; do
    jq -r '.rules[]|select(.rule_id=="ptx-marker")|.failure_mode' "$MANIFEST" | grep -qF -- "$ph" || fevmiss="$fevmiss manifest-ptx:{$ph}"; done
  # the advisor-architecture registry is the SEMANTIC SOURCE the bootstrap is generated from, so a stale row
  # there can reintroduce a withdrawn rule at the next regeneration even while every generated carrier is
  # correct. Assert the ROW'S SUBSTANCE — a `LIFE-5c` token existing proves nothing about what it says.
  for ph in 'the PTX artifact itself **may carry terminal `-TBI`**' \
            'resolving the overlay preserves `-PTX` and `_vN` and creates no handoff, authority, or project truth' \
            'The full **first-ingest-and-classify path for a fresh routed handoff awaiting first ingestion**' \
            '**State machine — scoped to the fresh-handoff state.**' \
            'the only transition is removal of terminal `-TBI`'; do
    grep -qF -- "$ph" "$APARCH" || fevmiss="$fevmiss advisor-registry:{$ph}"; done
  for stale in 'do not stack `-PTX` with `-TBI`' 'never combines with `-TBI`'; do
    grep -qF -- "$stale" "$APARCH" && fevmiss="$fevmiss STALE-registry:{$stale}"; done

  # the core-ecology profile is DISTRIBUTABLE: its body propagates verbatim into method-ASK, design-system-ASK,
  # and ASK. Byte parity between the owner profile and the resolved root proves only that the two AGREE -- it
  # cannot tell agreement from shared defect, so the qualifier needs its own semantic assertion on both copies.
  local ecoprof="$PROFDIR/core-ecology.md"
  for ph in 'The **handoff-marker use** of `-TBI` applies to material crossing between separately-operated or walled surfaces.' \
            'The orthogonal terminal overlay may also be applied to an eligible same-surface artifact or addressed copy under the preceding rule.'; do
    grep -qF -- "$ph" "$ecoprof"    || fevmiss="$fevmiss core-ecology-profile:{$ph}"
    grep -qF -- "$ph" "$ROOTAGENTS" || fevmiss="$fevmiss root-profile-block:{$ph}"; done
  # the corrected sentence CONTAINS the old one as a substring, so the stale pattern is anchored on the preceding
  # clause, which survives only in the unqualified form.
  for stale in 'in it. `-TBI` applies to material crossing between separately-operated or walled surfaces.'; do
    grep -qF -- "$stale" "$ecoprof"    && fevmiss="$fevmiss STALE-eco-profile:{$stale}"
    grep -qF -- "$stale" "$ROOTAGENTS" && fevmiss="$fevmiss STALE-root-profile:{$stale}"; done

  # NEGATIVE: no governed carrier may still teach the outgoing model. `-SUPERSEDED` is checked as a whole word so
  # the lower-case `-supersededA` / `-supersededP` tokens do not trip it.
  local stale
  for stale in 'the item leaves the queue when it is fed in' 'has not yet fed into the operating surface' \
               'When ASK feeds that memo into the active surface' \
               'takes it up' 'taken up' 'unmarked ingested' 'rename the file in place to remove' \
               'absorption is the later classification' \
               'read into context ≠ ingested' \
               'never combines with `-TBI`, `-ingested`, or any terminal disposition suffix' \
               'never stacked with a handoff lifecycle suffix at all' \
               'unconsumed feed-queue marker' \
               'unconsumed feed queue' \
               'rather than stacking `-PTX` with `-TBI`' \
               '(`-PTX`, `-4ASK`, `-4TMK`) precedes'; do
    grep -rqF -- "$stale" "$SHARED" "$ROOTAGENTS" "$APBOOT" "$IDXTEMPLATE" "$PROFDIR" && fevmiss="$fevmiss STALE:{$stale}"; done
  grep -rqE -- '-SUPERSEDED([^A-Za-z]|$)' "$SHARED" "$ROOTAGENTS" "$APBOOT" "$IDXTEMPLATE" "$PROFDIR" && fevmiss="$fevmiss STALE:{-SUPERSEDED}"
  [ -z "$fevmiss" ] && OKAY "routed-instance lifecycle carried (routing/feeding/ingestion/disposition · -TBI→-ingested · phase-split supersession · record+rename coupling · declared structural carriers; no outgoing-model residue)" || FAIL "routed-instance lifecycle clause(s) missing or stale:$fevmiss"
}

validate_consumer(){
  local c="$1" entry="$2" path ref disp
  path=$(printf '%s' "$entry" | jq -r '.path // empty'); ref=$(printf '%s' "$entry" | jq -r '.ref // empty')
  disp=$(printf '%s' "$entry" | jq -r '.carrier_disposition // "resolved-local"')
  [ -n "$path" ] || { UNRES "$c: no path"; return; }; [ -n "$ref" ] || { UNRES "$c: no explicit ref"; return; }
  if [ "$disp" = "unresolved-carrier" ] || [ "$disp" = "held" ]; then UNRES "$c: carrier_disposition=$disp — visibility NOT complete for $c"; return; fi
  { [ -d "$path/.git" ] || [ -f "$path/.git" ]; } || { UNRES "$c: $path not a git repo"; return; }
  git -C "$path" fetch origin --quiet || { FAIL "$c: git fetch failed"; return; }
  git -C "$path" rev-parse --verify --quiet "$ref^{commit}" >/dev/null || { FAIL "$c: ref '$ref' not found"; return; }
  local body; body=$(git -C "$path" show "$ref:AGENTS.md" 2>/dev/null) || { FAIL "$c: no AGENTS.md"; return; }
  # shared parity (vs current owner)
  printf '%s\n' "$body" | extract "<!-- BEGIN shared: AGENTS.shared.md -->" "<!-- END shared -->" > /tmp/_cs.$$
  { [ -s /tmp/_cs.$$ ] && diff -q "$SHARED" /tmp/_cs.$$ >/dev/null; } && OKAY "$c shared block == owner" || FAIL "$c shared block missing/DRIFT"
  # local-delta markers exactly once
  local nbd nel; nbd=$(printf '%s\n' "$body" | grep -c "<!-- BEGIN local-delta -->"); nel=$(printf '%s\n' "$body" | grep -c "<!-- END local-delta -->")
  { [ "$nbd" = "1" ] && [ "$nel" = "1" ]; } && OKAY "$c local-delta markers exactly once" || FAIL "$c local-delta markers not exactly once ($nbd/$nel)"
  # carrier-metadata: parse + no placeholders + agreement
  printf '%s\n' "$body" | extract "<!-- BEGIN carrier-metadata -->" "<!-- END carrier-metadata -->" > /tmp/_cm.$$
  [ -s /tmp/_cm.$$ ] || { FAIL "$c has no carrier-metadata block"; rm -f /tmp/_cm.$$ /tmp/_cs.$$; return; }
  grep -qE "<owner-merge-commit>|<direct-core|placeholder" /tmp/_cm.$$ && FAIL "$c carrier-metadata still has placeholder(s)" || OKAY "$c carrier-metadata has no placeholders"
  local m_pin m_prof m_grant m_surf m_ctype m_source
  m_ctype=$(sed -n 's/^CARRIER_TYPE:[[:space:]]*//p' /tmp/_cm.$$ | awk '{print $1}')
  m_source=$(sed -n 's/^SHARED_BLOCK_SOURCE:[[:space:]]*//p' /tmp/_cm.$$ | awk '{print $1}')
  m_pin=$(sed -n 's/^SHARED_BLOCK_PIN:[[:space:]]*//p' /tmp/_cm.$$ | awk '{print $1}')
  m_prof=$(sed -n 's/^PROFILES:[[:space:]]*//p' /tmp/_cm.$$); m_grant=$(sed -n 's/^GRANT_FRAGMENT:[[:space:]]*//p' /tmp/_cm.$$ | awk '{print $1}')
  m_surf=$(sed -n 's/^OPERATING_SURFACE:[[:space:]]*//p' /tmp/_cm.$$ | awk '{print $1}')
  rm -f /tmp/_cm.$$
  # (4A) fixed carrier-metadata fields
  [ "$m_ctype" = "resolved-local" ] && OKAY "$c CARRIER_TYPE=resolved-local" || FAIL "$c CARRIER_TYPE '$m_ctype' != resolved-local"
  [ "$m_source" = "apexSolarKiss/control-surface/protocol/AGENTS.shared.md" ] && OKAY "$c SHARED_BLOCK_SOURCE canonical" || FAIL "$c SHARED_BLOCK_SOURCE '$m_source' != apexSolarKiss/control-surface/protocol/AGENTS.shared.md"
  # (5A) OPERATING_SURFACE must agree with the STRUCTURAL class in manifest.consumers (not just the map)
  local mclass; mclass=$(manifest_class "$c")
  if [ -n "$mclass" ]; then { [ "$m_surf" = "$mclass" ] && OKAY "$c operating-surface metadata == manifest class ($mclass)" || FAIL "$c operating-surface ($m_surf) != manifest.consumers class ($mclass)"; }
  else FAIL "$c not declared in manifest.consumers"; fi
  # (5B) also agree with the map's operating_surface if the map states one
  local exp_surf; exp_surf=$(printf '%s' "$entry" | jq -r '.operating_surface // empty')
  [ -n "$exp_surf" ] && { [ "$m_surf" = "$exp_surf" ] && OKAY "$c operating-surface metadata == map" || FAIL "$c operating-surface ($m_surf) != map ($exp_surf)"; }
  # (5C) owner-pin reality: real 40-hex owner commit whose owner shared body == installed block; or the owner-only sentinel
  if [ "$m_pin" = "self-resolving-owner-root" ]; then
    { [ -n "$OWNER" ] && [ "$c" = "$OWNER" ]; } && OKAY "$c uses owner-only self-resolving pin" || FAIL "$c uses self-resolving-owner-root but is not the protocol owner ($OWNER)"
  else
    if printf '%s' "$m_pin" | grep -qE '^[0-9a-f]{40}$'; then
      if owner_has_commit "$m_pin"; then
        owner_shared_at "$m_pin" > /tmp/_op.$$ 2>/dev/null
        { [ -s /tmp/_op.$$ ] && diff -q /tmp/_op.$$ /tmp/_cs.$$ >/dev/null; } && OKAY "$c SHARED_BLOCK_PIN is a real owner commit whose shared body == installed" || FAIL "$c owner@$m_pin:AGENTS.shared.md != installed shared block"
        rm -f /tmp/_op.$$
      else FAIL "$c SHARED_BLOCK_PIN $m_pin is not a commit in the owner repo ($ROOT)"; fi
    else FAIL "$c SHARED_BLOCK_PIN '$m_pin' is not a 40-hex owner commit (nor the owner sentinel)"; fi
  fi
  rm -f /tmp/_cs.$$
  # installed profiles == metadata PROFILES == manifest-declared == owner fenced bodies
  local installed; installed=$(printf '%s\n' "$body" | grep -oE "<!-- BEGIN profile: [a-z0-9-]+ -->" | sed -E 's/.*profile: (.*) -->/\1/' | sort | tr '\n' ' ')
  local declared; declared=$(printf '%s' "$m_prof" | tr -d '[]"' | tr ',' ' ')
  local ins_set dec_set; ins_set=$(printf '%s\n' $installed | sort -u | tr '\n' ' '); dec_set=$(printf '%s\n' $declared | sort -u | tr '\n' ' ')
  [ "$ins_set" = "$dec_set" ] && OKAY "$c installed profiles == metadata PROFILES ($ins_set)" || FAIL "$c installed profiles ($ins_set) != metadata ($dec_set)"
  local dupp; dupp=$(printf '%s\n' $installed | sort | uniq -d | tr '\n' ' ')
  [ -z "${dupp// /}" ] && OKAY "$c no duplicate installed profile" || FAIL "$c duplicate installed profile: $dupp"
  # completeness: every active profile whose non-empty applies_to includes $c (and does not exclude $c) MUST be installed
  local required rp; required=$(jq -r --arg c "$c" '.rules[]|select(.scope_class=="profile" and .status=="active" and (.applies_to|length>0) and ((.applies_to|index($c))!=null) and (((.explicit_exclusions // [])|index($c))==null))|.profile' "$MANIFEST" | sort -u)
  for rp in $required; do printf '%s\n' $installed | grep -qx "$rp" && OKAY "$c carries required profile $rp" || FAIL "$c missing required profile $rp"; done
  for p in $installed; do
    manifest_declares_profile "$p" || { FAIL "$c installs profile '$p' not declared as a profile rule in the manifest"; continue; }
    # applicability + exclusion: never install a profile that excludes you; if applies_to is non-empty you must be in it
    if jq -e --arg c "$c" --arg p "$p" '.rules[]|select(.scope_class=="profile" and .profile==$p)|.explicit_exclusions|index($c)' "$MANIFEST" >/dev/null 2>&1; then FAIL "$c installs profile $p but is in its explicit_exclusions"; continue; fi
    local pa_len; pa_len=$(jq -r --arg p "$p" '[.rules[]|select(.scope_class=="profile" and .profile==$p)|.applies_to[]?]|length' "$MANIFEST")
    if [ "${pa_len:-0}" -gt 0 ]; then
      jq -e --arg c "$c" --arg p "$p" '.rules[]|select(.scope_class=="profile" and .profile==$p)|.applies_to|index($c)' "$MANIFEST" >/dev/null 2>&1 && OKAY "$c profile $p applicable (in applies_to)" || { FAIL "$c installs profile $p but is not in its applies_to"; continue; }
    else OKAY "$c profile $p is opt-in (empty applies_to)"; fi
    [ -f "$PROFDIR/$p.md" ] || { FAIL "$c installs unknown profile $p"; continue; }
    extract "<!-- BEGIN profile-body: $p -->" "<!-- END profile-body: $p -->" < "$PROFDIR/$p.md" > /tmp/_op.$$
    printf '%s\n' "$body" | extract "<!-- BEGIN profile: $p -->" "<!-- END profile: $p -->" > /tmp/_ip.$$
    { [ -s /tmp/_op.$$ ] && diff -q /tmp/_op.$$ /tmp/_ip.$$ >/dev/null; } && OKAY "$c profile $p == owner body" || FAIL "$c profile $p drift or owner-wrapper inserted"
    rm -f /tmp/_op.$$ /tmp/_ip.$$
  done
  # grant: metadata vs installed vs eligibility vs byte-identity
  local has_grant; printf '%s\n' "$body" | extract "<!-- BEGIN grant" "<!-- END grant -->" > /tmp/_cg.$$; has_grant=$([ -s /tmp/_cg.$$ ] && echo 1 || echo 0)
  local eligible; eligible=$(jq -e --arg c "$c" '.rules[]|select(.rule_id=="standing-upstream-conformance-grant")|.grant_eligibility|index($c)' "$MANIFEST" >/dev/null 2>&1 && echo yes || echo no)
  if [ "$m_grant" = "none" ]; then
    [ "$has_grant" = "0" ] && OKAY "$c no grant (metadata none, none installed)" || FAIL "$c metadata GRANT_FRAGMENT none but a grant is installed"
  else
    local g_id="${m_grant%@*}" g_pin="${m_grant##*@}"
    [ "$g_id" = "standing-upstream-conformance-grant" ] && OKAY "$c GRANT_FRAGMENT id ok" || FAIL "$c GRANT_FRAGMENT id '$g_id' != standing-upstream-conformance-grant"
    [ "$g_pin" = "$m_pin" ] && OKAY "$c GRANT_FRAGMENT pin == SHARED_BLOCK_PIN" || FAIL "$c GRANT_FRAGMENT pin '$g_pin' != SHARED_BLOCK_PIN '$m_pin'"
    [ "$eligible" = "yes" ] || FAIL "$c declares a grant but is not eligible"
    if [ "$has_grant" = "1" ]; then diff -q /tmp/_cg.$$ "$FRAGMENT" >/dev/null && OKAY "$c grant == owner fragment (byte-exact)" || FAIL "$c grant DRIFT vs fragment"; else FAIL "$c metadata declares grant but none installed"; fi
  fi
  rm -f /tmp/_cg.$$
}

assert_wave(){ require_deps; local MAP="${1:-}"; [ -n "$MAP" ] && [ -f "$MAP" ] || { FAIL "--wave needs a consumer-map.json"; return; }
  assert_local || true
  local named; named=$(jq -r '.wave_consumers[]? // empty' "$MAP"); [ -n "$named" ] || { FAIL "--wave map has no wave_consumers[]"; return; }
  for c in $named; do e=$(jq -c --arg c "$c" '.consumers[$c] // empty' "$MAP"); [ -n "$e" ] && validate_consumer "$c" "$e" || FAIL "$c named in wave but absent from consumers"; done
  for c in $(jq -r '.rules[]|select(.scope_class=="shared-core")|.applies_to[]' "$MANIFEST" | sort -u); do printf '%s\n' $named | grep -qx "$c" && continue
    r=$(jq -r --arg c "$c" '.excluded[$c].reason // empty' "$MAP"); [ -n "$r" ] && OKAY "excluded $c has reason: $r" || FAIL "applicable $c neither in wave nor excluded-with-reason"; done
  printf 'NOTE: --wave closes a NAMED wave only; it does NOT assert whole-ecology visibility.\n'; }

assert_all(){ require_deps; local MAP="${1:-}"; [ -n "$MAP" ] && [ -f "$MAP" ] || { FAIL "--all needs a consumer-map.json"; return; }
  assert_local || true
  for c in $(jq -r '.rules[]|select(.scope_class=="shared-core")|.applies_to[]' "$MANIFEST" | sort -u); do
    e=$(jq -c --arg c "$c" '.consumers[$c] // empty' "$MAP"); [ -n "$e" ] && validate_consumer "$c" "$e" || UNRES "$c absent from map"; done
  printf 'NOTE: --all is whole-ecology; UNRESOLVED while any applicable consumer is held/absent.\n'; }

case "$MODE" in
  --local) printf '== check.sh --local ==\n'; assert_local ;;
  --wave)  printf '== check.sh --wave ==\n';  assert_wave "${2:-}" ;;
  --all)   printf '== check.sh --all ==\n';   assert_all  "${2:-}" ;;
  *) FAIL "unknown mode '$MODE'";;
esac
[ "$fail" -eq 0 ] && { printf 'ALL CHECKS PASSED (%s)\n' "$MODE"; exit 0; } || { printf 'CHECKS FAILED OR UNRESOLVED (%s)\n' "$MODE"; exit 1; }
