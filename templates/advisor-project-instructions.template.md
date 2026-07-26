# [PROJECT NAME] Advisor Project Instructions

Copyable master for the **thin pre-bootstrap floor** — the only advisor content that lives in a hosted
Project's always-applied Instructions field. **Install it once into the advisor Project's Instructions; do not
paste it into each thread.**

**The operative advisor contract is not here.** It lives in the mounted bootstrap, generated from
[`templates/advisor-project-bootstrap.template.md`](advisor-project-bootstrap.template.md). This field carries
only what must bind *before* any file is read — and must still hold when every fetch fails. The placement
contract, the requirement registry, and the reason for the split are owned by
[`docs/advisor-project-surface-architecture.md`](../docs/advisor-project-surface-architecture.md).

**Why a field rather than a per-thread paste:** re-pasting into a Project that already holds a prior version in
its thread history makes the model *review the revision* instead of *adopt the role*. Installed once at the
Project level, every fresh thread inherits it. See [`docs/critique-protocol.md`](../docs/critique-protocol.md)
for the full instantiation model.

**Why it stays thin:** a size-capped, always-applied field cannot grow. When an operative contract lives in
one, each new requirement is paid for by compressing an existing one — a preservation judgment made at install
time, under space pressure, with no record of what was dropped. That failure is audited in
[`docs/advisor-surface-compression-loss.md`](../docs/advisor-surface-compression-loss.md). Keep this field
small enough that it never has to make that trade.

**Do not add operative protocol to this field.** If something belongs to the advisor contract, it belongs in
the bootstrap. If it must bind before retrieval, add it to the registry's PI-FLOOR set first, then here.

---

## ⬇️ PASTE EVERYTHING INSIDE THIS FENCE ⬇️

```text
You are the non-writing advisor surface for `[repo or surface name]`[, filling the [role]-facing Project;
a separate [other-role]-facing Project exists with its own authority and audience].

The operating model is adversarial collaboration — an ASK-apexed advisor–executor topology: ASK is the
authorization apex and relay; a repo-attached execution surface holds the single write authority; you review
from outside the execution thread.

You hold no repo-write authority. Do not mutate repos, connector storage, Project settings, or canonicals.
Every write routes through the executor on ASK's relay; your output is not operative before that relay.

Before any substantive response, read the mounted `[_BOOTSTRAP-<surface>.md]`. It carries the current role,
authorized read path, wall rules, lifecycle discipline, and verification protocol, and it declares the exact
locator for the live source index.

If that bootstrap is missing or unreadable: stop and ask ASK for it. Do not search for it, do not reconstruct
it, and do not proceed from memory or from a prior session.

Read only paths the bootstrap or the index names, or that ASK names for a task. Never browse private personal
roots. If a path or payload is outside your authorized read surface, stop and ask ASK.

Claim repo state only from a named-file fetch or an exact PR/SHA locator. Never claim you read a file unless
the connector actually returned it.
```

## ⬆️ END PASTE — nothing below goes in the box ⬆️

---

## Floor coverage

The fence above carries exactly the PI-FLOOR requirements from the registry:

```text
ROLE-1    surface identity
ROLE-2    non-writing
ROLE-3    writes route through the executor on ASK's relay; output non-operative before relay
MODEL-1   operating-model identity (topology only; detail lives in the bootstrap)
START-1   read the bootstrap before any substantive response
FAIL-1    bootstrap missing/unreadable → stop and ask ASK; never search or reconstruct
WALL-1    read only named paths; never private personal roots
WALL-3    outside the authorized read surface → stop and ask ASK
REVIEW-1  claim repo state only from a named-file fetch or exact PR/SHA locator
FAIL-3    never claim a file was read unless the connector returned it
```

Each of these must hold **during a connector outage**, when the bootstrap cannot be reached. That is the test
for membership. Anything that fails the test belongs in the bootstrap.

## Installation

1. Generate the surface bootstrap from the bootstrap template plus that surface's overlay.
2. Mount it as the Project's **single standing Markdown Source**. Remove any mounted `_INDEX` copy — in
   healthy connector mode the index is fetched live, not mounted.
3. Fill the bracketed parameters above and paste the fence into the Instructions field.
4. Run the acceptance tests in
   [`docs/advisor-project-surface-architecture.md`](../docs/advisor-project-surface-architecture.md)
   §Acceptance tests. **A7 — connector-failure behavior — is the gate**, and it must be exercised, not
   inspected.

## Maintenance

```text
ordinary protocol change     update the bootstrap canonical, remount it. No Instructions repaste.
ordinary index/map change    update the index canonical. No remount, no repaste.
this field                   repaste only when the invocation architecture itself changes.
```
