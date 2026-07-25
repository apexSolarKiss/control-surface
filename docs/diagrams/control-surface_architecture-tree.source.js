/* control-surface_architecture-tree.source.js
   Source data for the control-surface architecture tree diagram.
   Renderable by diagrams-static-H-engine.js.

   D01 // control-surface architecture tree // source-v6 // 2026-07-25
   v6 (2026-07-25): operating-model current-truth reframe. The live model is the
   adversarial-collaboration operating model — an ASK-apexed advisor–executor topology,
   currently occupied by a GPT advisor + a Claude Code executor, with direct execution as a
   bounded proportional path inside that same model. Retires the "single-node" label from the
   human + agent surfaces declaration and from the AP / UO pressure-surface notes, and restates
   mazeASK as a dormant historical origin case rather than a current working example. Model A
   stays retired as a live option and frozen as historical provenance, and its separately enumerated prompt /
   example / artifact nodes collapse into one low-noise 'retired historical provenance' node; the companion .html
   legacy legend key is restated to match. Content-only; companion .html stamp re-synced.
   v5 (2026-07-21): ecology-state scrub to the landed shared-protocol architecture.
   control-surface is the OWNER of the shared execution-protocol CANONICAL at
   control-surface/protocol/ (landed Wave-1A). Corrects the stale renderer comment
   (diagrams-engine.js -> diagrams-static-H-engine.js) and the D03 name (ecology-ASK overall
   -> system-ASK topology). Distinguishes the four deliberately separate artifacts / planes
   (NOT four carriers — protocol/ is the owner canonical; the resolved AGENTS.md files are the
   carriers): protocol/ (owner canonical) · protocol/AGENTS.shared.md (authoritative shared rule body) ·
   protocol/manifest.json (normative REGISTRY — rule ownership / scope / applicability /
   metadata, NOT live state) · control-surface_protocol-consumer-ledger.md (live carrier /
   grant / visibility / propagation STATE). The root AGENTS.md is the resolved OWNER CARRIER
   (resolves the shared rule body + core-ecology profile + coordinator / local delta) — not
   the owner canonical. Resolution is not universal: method / DS / ASK resolved, PCS
   applicable-but-carrier-blocked, AP / UO separately operated under standing grants. Adds the
   protocol/ owner subtree + the cross-repo propagation-wave prompt; reclassifies
   AGENTS.template.md as a bootstrap shell (not an independently maintained protocol payload);
   adds the operator-side protocol consumer ledger + DS visual consumer ledger as separate
   state planes; scopes the shared intake inbound-only; replaces the absolute
   downstream-no-write claim with the current bounded boundary. Exact live SHAs/PRs stay OUT of
   the tree (they live in the protocol consumer ledger). Content-only; render held render-v18.
   Single-tree extraction of TREE_D01 from the v9 operator-side ecology-ASK
   package. This repo carries TREE_D01 only; it does not carry TREE_D02
   (method-ASK topology) or TREE_D03 (system-ASK topology), which remain
   in their respective owners' surfaces.

   Each TREE follows the same shape:
     { kind: 'root'|'section'|'group'|'node', label, note?, tag?, status?, children? }
     status: 'earned' (default) | 'held' | 'legacy'
*/

window.TREE_D01 = {
  kind: 'root',
  label: 'control-surface',
  note: 'execution-protocol repo // downstream of method-ASK · owner of the shared execution-protocol canonical at control-surface/protocol/',
  children: [
    {
      kind: 'section', label: 'upstream methodology',
      children: [
        { label: 'method-ASK', note: 'methodology layer', children: [
          { label: 'docs/method.md' },
          { kind: 'group', label: 'doctrine docs', children: [
            { label: 'relative-externality.md' },
            { label: 'voice-surface-boundary.md' },
            { label: 'source-of-truth-and-aging-rate.md' },
            { label: 'source-of-intent.md' },
            { label: 'absorption-discipline.md' },
          ]},
          { label: 'docs/articles.md', note: 'canonical article-line index' },
          { label: 'examples/', note: 'method-altitude worked examples' },
        ]},
      ],
    },
    {
      kind: 'section', label: 'repo-local surfaces',
      children: [
        { label: 'README.md' },
        { label: 'AGENTS.md', note: 'resolved OWNER carrier — resolves the shared rule body + core-ecology profile + control-surface coordinator / local delta (not the owner canonical itself)' },
        { label: 'CLAUDE.md', note: 'pointer to AGENTS.md' },
        { kind: 'group', label: 'protocol/', note: 'shared execution-protocol OWNER canonical · resolved consumers carry the applicable shared / profile bodies locally · live carrier / grant / visibility state lives in the protocol consumer ledger', children: [
          { label: 'AGENTS.shared.md', note: 'authoritative shared execution-protocol rule body' },
          { label: 'manifest.json (+ manifest.schema.json)', note: 'normative registry — rule ownership, scope, applicability, exclusions, carrier / profile / hold / lifecycle metadata; NOT live consumer state' },
          { label: 'profiles/', note: 'core-ecology · architecture-uncertain — the applicable rule profile per consumer class' },
          { label: 'fragments/standing-upstream-conformance-grant.md', note: 'the standing-GREEN grant body, vendored inside a consumer carrier\'s grant markers' },
          { label: 'check.sh (+ tests/)', note: 'deterministic validator — --local / --wave / --all' },
          { label: 'README.md', note: 'protocol-layer orientation' },
        ]},
        { label: 'docs/', children: [
          { label: 'architecture.md', note: 'role model + Layer Map' },
          { label: 'method.md', note: 'compact bridge to method-ASK' },
          { label: 'project-instantiation-workflow.md', note: 'instantiation / bootstrap / operational phases' },
          { label: 'workflow-boundary.md', status: 'legacy' },
        ]},
        { label: 'templates/', children: [
          { label: 'AGENTS.template.md', note: 'bootstrap shell — NOT an independently maintained protocol payload · a new repo resolves the shared rule body from control-surface/protocol/ at instantiation' },
          { label: 'CLAUDE.template.md' },
          { label: 'architecture.template.md' },
          { label: 'grounding-note.template.md' },
          { label: 'advisor-initial-prompt.template.md' },
          { label: 'overlays/', children: [
            { label: 'architecture-uncertain-rules.template.md', note: 'opt-in · architecture / ontology uncertainty' },
          ]},
        ]},
        { label: 'prompts/', children: [
          { label: 'claude-code-initial-prompt.md', note: 'executor attach to existing repo' },
          { label: 'project-instantiation-initial-prompt.md', note: 'pre-repo phase' },
          { label: 'repo-nudge-prompt.md', note: 'source-of-intent nudge' },
          { label: 'cross-repo-propagation-wave.md', note: 'operator playbook for a bounded cross-repo protocol / design-system propagation wave under standing or ASK-scoped grants' },
          { kind: 'group', label: 'repo critique cycle', children: [
            { label: 'repo-critique-initial-prompt.md' },
            { label: 'repo-critique-synthesis-prompt.md' },
            { label: 'repo-critique-execution-prompt.md' },
          ]},
          { kind: 'group', label: 'ecology critique', children: [
            { label: 'ecology-critique-initial-prompt.md' },
            { label: 'ecology-critique-synthesis-prompt.md' },
            { label: 'ecology-critique-execution-prompt.md' },
          ]},
        ]},
        { label: 'examples/', children: [
          { label: 'asset-pipeline-ASK/notes.md', note: 'mature primary pressure surface' },
          { label: 'urban-observatory/notes.md', note: 'newer working example · source-of-intent recovery' },
        ]},
        { label: 'retired historical provenance', note: 'Model-A artifacts retained in the repo / git history · not a current prompt, example, or operating path', status: 'legacy' },
        { label: 'docs/diagrams/', note: 'illustrative diagrams · not source truth', children: [
          { label: 'control-surface_architecture-tree.html', note: 'this diagram' },
        ]},
      ],
    },
    {
      kind: 'section', label: 'operator-side context · shared ecology external surface',
      tag: 'ecology-ASK-EXTERNAL/ · control-surface slice',
      children: [
        { label: 'control-surface_grounding-note.md', note: 'root canonical' },
        { kind: 'group', label: 'consumer / propagation ledgers', note: 'operator-side state planes · kept SEPARATE — execution-protocol state vs visual / tooling state', children: [
          { label: 'control-surface_protocol-consumer-ledger.md', note: 'execution-protocol live STATE plane — installed carriers · grant adoption · visibility · propagation (owned here; the normative rule body + registry live in protocol/ — AGENTS.shared.md + manifest.json)' },
          { label: 'design-system-ASK_consumer-ledger.md', note: 'design-system VISUAL propagation state — exact vendored pins + render obligations' },
        ]},
        { label: 'sources of intent/', note: 'shared ecology INBOUND intake · genuinely inbound material only — NOT a core-repo routing bus (core-to-core changes cross repo boundaries directly, no -TBI)', children: [
          { label: 'routed handoffs · -TBI = received, awaiting ingestion' },
          { label: 'received records from separately-operated or walled surfaces' },
        ]},
        { label: 'scratch/', note: 'shared ecology operator scratch', children: [
          { label: 'handoffs' },
          { label: 'critique syntheses' },
          { label: 'versioned grounding-note history' },
          { label: 'topology / methodology-graduation evaluations' },
          { label: 'diagram source drafts' },
          { label: 'article planning artifacts' },
        ]},
        { label: 'articles/', note: 'shared ecology publication corpus', children: [
          { label: 'Substack draft iterations · reflective method writing' },
          { label: 'not repo truth' },
          { label: 'published Substack remains conceptual source of truth for published essays' },
        ]},
      ],
    },
    {
      kind: 'section', label: 'human + agent surfaces',
      children: [
        { label: 'ASK', children: [
          { label: 'source-of-intent principal', note: 'upstream normative authority' },
          { label: 'relay / mediation operator', note: 'adopts advisor output into operative direction' },
        ]},
        { label: 'Claude Code', note: 'execution surface of the ASK-apexed advisor–executor topology · repo-attached · single-writer-per-branch' },
        { label: 'advisor surface', note: 'standard surface · GPT / Claude chat · external challenge + verification · outside execution thread · no repo-write authority' },
      ],
    },
    {
      kind: 'section', label: 'design-family inheritance surface',
      children: [
        { label: 'design-system-ASK', note: 'foundations + static-artifact inheritance scaffolds', children: [
          { label: 'Tier 1 foundation', note: 'identity-free primitives' },
          { label: 'Tier 2 ASK design language', note: 'family-level visual grammar' },
          { label: 'Tier 3 ASK instance identity', note: 'excluded from child surfaces unless inheriting entity is ASK' },
          { label: 'child surfaces inherit Tier 1 + Tier 2 · supply own Tier 3' },
          { kind: 'group', label: 'static-artifact scaffolds', children: [
            { label: 'Class A · diagram-tree', note: 'system / architecture diagram templates' },
            { label: 'Class B · output-artifact', note: 'project-output artifact templates' },
          ]},
        ]},
      ],
    },
    {
      kind: 'section', label: 'downstream project repos',
      tag: 'separately operated · own substantive absorption decisions · standing GREEN protocol / DS maintenance grants',
      children: [
        { label: 'asset-pipeline-ASK', note: 'mature primary pressure surface · separately operated · standing GREEN grant for bounded protocol / DS maintenance (substantive project ownership unchanged)' },
        { label: 'urban-observatory', note: 'newer source-of-intent recovery pressure surface · separately operated · standing GREEN grant for bounded protocol / DS maintenance' },
      ],
    },
    {
      kind: 'section', label: 'downstream absorption boundary',
      children: [
        { label: 'ecology operating surface may prepare handoff context' },
        { label: 'downstream reads its repo + grounding note + handoff memo' },
        { label: 'downstream classifies candidate content by layer' },
        { label: 'downstream proposes absorption from its own active project surface' },
        { label: 'candidate source-of-intent + substantive project judgment remain recipient-owned', note: 'the recipient classifies + absorbs from its own active surface' },
        { label: 'bounded GREEN DS / protocol maintenance may propagate DIRECTLY', note: 'under a consumer-local or ASK-scoped grant — no -TBI for deterministic conformance' },
        { label: 'execution jurisdiction does not transfer artifact ownership', note: 'acting in a repo under a grant is not owning its source-of-intent' },
      ],
    },
  ],
};
