/* control-surface_intent-inbox-lifecycle.source.js
   Source data for the routed-instance lifecycle diagram.
   Renderable by diagrams-static-H-engine.js.

   D08 // intent-INbox routed-instance lifecycle // source-v2 // 2026-08-23

   Subject: the executable state machine that AGENTS.shared.md §Inbound Handoff TBI
   Marker owns, drawn as a standalone figure. TREE_D01 carries an intent-inbox GROUP
   because the architecture tree must show the plane exists; it is not this figure and
   does not replace it.

   The figure exists to keep four things apart:
     terminal -TBI is an ORTHOGONAL overlay, not a lifecycle stage
     the resolution branch keys on STATE (fresh-awaiting-first-ingestion), not artifact CLASS
     -supersededA (never ingested) and -supersededP (ingested, then displaced) are different histories
     absorption is ONE disposition, not the name for all of them
     one obligation is carried by exactly ONE marked artifact INSTANCE — location is not membership

   The grammar is prospective. Historical filenames retain the conventions in force when
   they were created; legacy tokens do not acquire these meanings.

   Source truth is TWO levels, and the figure draws both:

     protocol/AGENTS.shared.md §Inbound Handoff TBI Marker
       the terminal overlay · the four events · state-keyed resolution · the routed-instance
       state machine · closure coupling · the two evidence axes · the logical queue

     docs/advisor-project-surface-architecture.md and the deployed advisor-surface
     state-carrier contract
       the concrete _STATE.md vocabulary — OPEN / FROZEN / PARTIAL-HOLD, the exact-filename
       exception grammar, activation, and fail-closed behavior

   The shared rule requires a structural state carrier and its obligations; it does not by
   itself define that carrier's state values. Attribution, not scope: the _STATE.md content
   belongs in this figure. */

window.TREE_D08 = {
  kind: 'root',
  label: 'TERMINAL -TBI',
  note: 'ASK currently owes a successful FEED of this exact artifact · an orthogonal overlay above whatever the artifact already is — never a lifecycle stage of its own',
  children: [
    {
      kind: 'section', label: 'the four events', tag: 'each has its own actor and its own evidence',
      children: [
        { label: '1 · routing', note: 'the ORIGIN makes material durably available at the recipient intake — candidate availability, nothing more' },
        { label: '2 · feeding', note: 'ASK hands it to the recipient’s active surface — the operator-side act. By value, or by an exact path' },
        { label: '3 · ingestion', note: 'the RECIPIENT surface reads the exact artifact into active context — the state that RESULTS when a feed succeeds' },
        { label: '4 · disposition', note: 'the recipient classifies and records the durable outcome. Absorption is one of them, not the name for all of them' },
        { label: 'collapsing any adjacent pair', note: 'is the failure this rule corrects. A feed can fail, be deferred, or be superseded before the recipient acts' },
      ],
    },
    {
      kind: 'section', label: 'resolution — branches on STATE, not class', tag: 'establish governed role AND prior lifecycle state first',
      children: [
        { label: 'verified fresh routed handoff awaiting first ingestion', note: '-TBI becomes -ingested. Rename only; it records nothing about what was later absorbed, held, declined, routed, or superseded' },
        { label: 'anything else with established role and prior state', note: 'remove ONLY terminal -TBI. The underlying role and durable disposition survive unchanged' },
        { label: 'role or prior state unresolved', note: 'STOP before feeding. Removal-only is NOT a safe default here — the unresolved artifact might BE a fresh routed handoff, and one may never become bare and unmarked' },
        { label: 'why class is not the discriminator', note: 'topic-absorbed-TBI.md is a routed instance BY CLASS and still takes the removal branch, because its first ingestion is already behind it' },
      ],
    },
    {
      kind: 'section', label: 'the state machine', tag: 'fresh routed handoff only',
      children: [
        { label: '-TBI  ->  -ingested', note: 'ingested — content read into active context; the rename RECORDS it, it does not cause it' },
        { label: '-TBI  ->  -supersededA', note: 'ASK-side PRE-ingestion retirement: retired before ingestion, never consumed. Carries no pending work; remains as lineage beside an active successor' },
        { label: '-ingested  ->  terminal disposition', note: '-absorbed · -held · -declined · -withdrawn · -routed · -no-route · -closed · -supersededP' },
        { label: '-supersededP', note: 'was INGESTED, then displaced by a successor — a materially different history from -supersededA, which is why the phase is encoded rather than flattened' },
      ],
    },
    {
      kind: 'section', label: 'closure is one bounded operation', tag: 'record + rename together',
      children: [
        { label: 'every -ingested -> terminal transition', note: 'requires a durable disposition record made in the SAME operation — a dated scratch memo, or an appended terminal section in a maintained program record' },
        { label: 'a rename is not a disposition record', note: 'and a record without the rename leaves the filename lying' },
        { label: 'do not create an artifact solely to satisfy form' },
        { label: '-supersededA is the one exit needing no absorption closure', note: 'no recipient absorption occurred — but it still requires an explicit lineage or current-status record naming the successor' },
      ],
    },
    {
      kind: 'section', label: 'two axes of current evidence', tag: 'they are not interchangeable',
      children: [
        { label: 'underlying filename', note: 'artifact identity / role + the PRIMARY durable-state marker' },
        { label: 'terminal -TBI', note: 'INDEPENDENT, faster-aging feed-obligation evidence. Not a disposition; EXCLUDED from the disposition-agreement check' },
        { label: 'disposition / lineage record', note: 'SECONDARY current evidence — must agree with the underlying DURABLE-STATE MARKER, never with terminal -TBI' },
        { label: 'received body', note: 'HISTORICAL — byte-immutable, plus any sender routing-time status line' },
        { label: 'worked case', note: 'topic-absorbed-TBI.md asserts two simultaneously true things on two axes: durable disposition ABSORBED, feed obligation OUTSTANDING' },
      ],
    },
    {
      kind: 'section', label: '_STATE.md', tag: 'structural inbox-state carrier · takes NO lifecycle suffix',
      children: [
        { label: 'OPEN', note: 'permits ordinary governed ingestion' },
        { label: 'FROZEN', note: 'blocks every routed artifact absent an exact-filename exception' },
        { label: 'PARTIAL-HOLD', note: 'blocks only the named scope, on the same exact-filename terms' },
        { label: 'exceptions are exact filenames or explicitly NONE', note: 'a scope description, a category, or a bare hold with no exception list is MALFORMED' },
        { label: 'fails closed once declared active', note: 'an unreachable or malformed carrier blocks ingestion rather than defaulting to OPEN. Before cutover its absence is not nonconformance' },
      ],
    },
    {
      kind: 'section', label: 'what the queue is, and is not', tag: 'logical, not a folder',
      children: [
        { label: 'the queue may occupy several physical locations', note: 'an ASK-side staging area, an origin’s scratch, a transit surface, and the recipient intake' },
        { label: 'relocation WITHIN the queue is not a lifecycle event', note: 'arriving in the intake folder is a move within the queue, not an entry into it and not an exit from it' },
        { label: 'a re-feed is a genuine new ingestion event', note: 'it does not reopen, reclassify, erase, or advance the underlying durable disposition' },
        { label: 'the grammar is PROSPECTIVE', note: 'historical filenames retain the conventions in force when they were created; legacy tokens do not acquire these meanings' },
      ],
    },
    {
      kind: 'section', label: 'artifact-instance identity', tag: 'one obligation · one marked payload',
      children: [
        { label: '-TBI marks the exact INSTANCE ASK intends to feed', note: 'in a two-copy handoff the retained origin or provenance copy stays UNSUFFIXED; only the recipient-bound copy carries the overlay' },
        { label: 'byte-identical files at two paths are TWO instances', note: 'location alone never creates queue membership, and one outstanding obligation is represented by exactly one live marked instance' },
        { label: 'MOVE is not COPY', note: 'a byte-preserving move or rename of the designated payload preserves the same marked instance and is not a lifecycle event; copying creates another instance and neither transfers nor duplicates designation' },
        { label: 'transferring designation leaves exactly ONE marked instance', note: 'a retained origin/provenance copy stays or becomes unsuffixed; a former temporary transport instance is removed or resolved by its underlying role and prior state. A fresh routed handoff is NEVER left bare merely to transfer designation' },
        { label: 'origin scratch may carry -TBI — but only for the payload itself', note: 'a PTX, report, or other independently complete artifact ASK intends to feed, or a distinct temporary recipient-bound transport instance' },
        { label: 'recipient lifecycle does NOT mirror onto provenance', note: '-ingested, -supersededA, -supersededP and terminal dispositions belong to the recipient routed instance; the retained origin copy is never renamed to match them' },
      ],
    },
  ],
};
