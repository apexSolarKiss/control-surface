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
  for f in "$SHARED" "$MANIFEST" "$SCHEMA" "$ROOTAGENTS" "$TEMPLATE" "$FRAGMENT" "$OVERLAY" "$PROFDIR/core-ecology.md" "$PROFDIR/architecture-uncertain.md"; do
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
  grep -q "<!-- BEGIN profile-body: core-ecology -->" "$PROFDIR/core-ecology.md" && grep -q "<!-- END profile-body: core-ecology -->" "$PROFDIR/core-ecology.md" && OKAY "core-ecology has a profile-body fence" || FAIL "core-ecology lacks a profile-body fence"
  # 8 template marker surfaces + carrier-metadata + payload-free
  for m in "<!-- BEGIN shared: AGENTS.shared.md -->" "<!-- BEGIN profiles -->" "<!-- BEGIN grant" "<!-- BEGIN local-delta -->" "<!-- BEGIN carrier-metadata -->"; do
    grep -q "$m" "$TEMPLATE" && OKAY "template has surface: $m" || FAIL "template missing surface: $m"; done
  for k in CARRIER_TYPE SHARED_BLOCK_SOURCE SHARED_BLOCK_PIN PROFILES GRANT_FRAGMENT OPERATING_SURFACE; do
    grep -q "^$k:" "$TEMPLATE" && OKAY "carrier-metadata field $k present" || FAIL "carrier-metadata missing $k"; done
  grep -q "One writer at a time per branch" "$TEMPLATE" && FAIL "template inlines shared payload" || OKAY "template not inlining payload"
  # 8b template profiles surface must not carry an active (installed-looking) profile marker
  extract "<!-- BEGIN profiles -->" "<!-- END profiles -->" < "$TEMPLATE" | grep -qE "^[[:space:]]*<!-- BEGIN profile: [a-z0-9-]+ -->" && FAIL "template profiles surface carries an installed-looking profile marker" || OKAY "template profiles surface is placeholder-only"
  # 9 root local delta carries exact BEGIN/END local-delta markers (same contract as consumer carriers)
  local nrb nre; nrb=$(grep -c "<!-- BEGIN local-delta -->" "$ROOTAGENTS"); nre=$(grep -c "<!-- END local-delta -->" "$ROOTAGENTS")
  { [ "$nrb" = "1" ] && [ "$nre" = "1" ]; } && OKAY "root local-delta markers exactly once" || FAIL "root local-delta markers not exactly once ($nrb/$nre)"
  grep -q "## Control-Surface-Local" "$ROOTAGENTS" && OKAY "root local delta present" || FAIL "root local delta missing"
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
  local declared; declared=$(printf '%s' "$m_prof" | tr -d '[]",' )
  local ins_set dec_set; ins_set=$(printf '%s\n' $installed | sort -u | tr '\n' ' '); dec_set=$(printf '%s\n' $declared | sort -u | tr '\n' ' ')
  [ "$ins_set" = "$dec_set" ] && OKAY "$c installed profiles == metadata PROFILES ($ins_set)" || FAIL "$c installed profiles ($ins_set) != metadata ($dec_set)"
  local dupp; dupp=$(printf '%s\n' $installed | sort | uniq -d | tr '\n' ' ')
  [ -z "${dupp// /}" ] && OKAY "$c no duplicate installed profile" || FAIL "$c duplicate installed profile: $dupp"
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
