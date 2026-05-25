/* control-surface_architecture-tree.source.js
   Source data for the control-surface architecture tree diagram.
   Renderable by diagrams-engine.js.

   D01 // control-surface architecture tree // source-v2 // 2026-05-25
   Single-tree extraction of TREE_D01 from the v9 operator-side ecology-ASK
   package. This repo carries TREE_D01 only; it does not carry TREE_D02
   (method-ASK topology) or TREE_D03 (ecology-ASK overall), which remain
   in their respective owners' surfaces.

   Each TREE follows the same shape:
     { kind: 'root'|'section'|'group'|'node', label, note?, tag?, status?, children? }
     status: 'earned' (default) | 'held' | 'legacy'
*/

window.TREE_D01 = {
  kind: 'root',
  label: 'control-surface',
  note: 'execution-protocol meta repo // downstream of method-ASK',
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
        { label: 'AGENTS.md', note: 'live workflow rules for this repo' },
        { label: 'CLAUDE.md', note: 'pointer to AGENTS.md' },
        { label: 'docs/', children: [
          { label: 'architecture.md', note: 'role model + Layer Map' },
          { label: 'method.md', note: 'compact bridge to method-ASK' },
          { label: 'project-instantiation-workflow.md', note: 'instantiation / bootstrap / operational phases' },
          { label: 'workflow-boundary.md', status: 'legacy' },
        ]},
        { label: 'templates/', children: [
          { label: 'AGENTS.template.md', note: 'downstream execution rule starter' },
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
          { kind: 'group', label: 'nudge ladder', children: [
            { label: 'repo-nudge-prompt.md', note: 'default' },
            { label: 'repo-next-source-of-intent-nudge-structured-prompt.md', note: 'non-default · structured' },
            { label: 'repo-next-source-of-intent-nudge-externality-decision-prompt.md', note: 'non-default · externality-decision' },
          ]},
          { kind: 'group', label: 'critique cycle', children: [
            { label: 'repo-critique-initial-prompt.md', note: 'default' },
            { label: 'repo-critique-initial-structured-prompt.md', note: 'non-default' },
            { label: 'repo-critique-synthesis-prompt.md', note: 'default' },
            { label: 'repo-critique-synthesis-structured-prompt.md', note: 'non-default' },
            { label: 'repo-critique-execution-prompt.md', note: 'default' },
            { label: 'repo-critique-execution-structured-prompt.md', note: 'non-default' },
          ]},
          { label: 'control-surface-initial-prompt.md', note: 'Model A ChatGPT-side', status: 'legacy' },
          { label: 'codex-initial-prompt.txt', note: 'Model A Codex-side', status: 'legacy' },
        ]},
        { label: 'examples/', children: [
          { label: 'asset-pipeline-ASK/notes.md', note: 'mature single-node pressure surface' },
          { label: 'urban-observatory/notes.md', note: 'newer single-node · source-of-intent recovery' },
          { label: 'mazeASK/notes.md', note: 'Model A working example', status: 'legacy' },
        ]},
        { label: 'control-surface.md', note: 'Model A external orchestration artifact', status: 'legacy' },
        { label: 'docs/diagrams/', note: 'illustrative diagrams · not source truth', children: [
          { label: 'control-surface_architecture-tree.html', note: 'this diagram' },
        ]},
      ],
    },
    {
      kind: 'section', label: 'operator-side meta context',
      tag: 'control-surface-EXTERNAL/',
      children: [
        { label: 'sources of intent/', children: [
          { label: 'control-surface_grounding-note.md', note: 'canonical mirror · currently v18' },
          { label: 'versioned grounding-note history' },
        ]},
        { label: 'scratch/', children: [
          { label: 'handoffs' },
          { label: 'critique syntheses' },
          { label: 'topology / methodology-graduation evaluations' },
          { label: 'diagram source drafts' },
          { label: 'article planning artifacts' },
        ]},
        { label: 'articles/', children: [
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
        { label: 'Claude Code', note: 'active control surface + executor · single-node' },
        { label: 'advisor surface', note: 'GPT / Claude chat · outside execution thread · no repo-write authority' },
      ],
    },
    {
      kind: 'section', label: 'design-family inheritance surface',
      children: [
        { label: 'design-system-ASK', note: 'externalized ASK visual / aesthetic-intent implementation', children: [
          { label: 'Tier 1 foundation', note: 'identity-free primitives' },
          { label: 'Tier 2 ASK design language', note: 'family-level visual grammar' },
          { label: 'Tier 3 ASK instance identity', note: 'excluded from child surfaces unless inheriting entity is ASK' },
          { label: 'child surfaces inherit Tier 1 + Tier 2 by reference' },
        ]},
      ],
    },
    {
      kind: 'section', label: 'downstream project repos',
      tag: 'own absorption decisions',
      children: [
        { label: 'asset-pipeline-ASK', note: 'mature single-node primary pressure surface' },
        { label: 'urban-observatory', note: 'newer single-node · source-of-intent recovery pressure surface' },
        { label: 'mazeASK', note: 'Model A working example', status: 'legacy' },
      ],
    },
    {
      kind: 'section', label: 'downstream absorption boundary',
      children: [
        { label: 'meta may prepare handoff context' },
        { label: 'downstream reads its repo + grounding note + handoff memo' },
        { label: 'downstream classifies candidate content by layer' },
        { label: 'downstream proposes absorption from its own active project surface' },
        { label: 'control-surface does not directly mutate downstream repos / grounding notes / Airtable' },
      ],
    },
  ],
};
