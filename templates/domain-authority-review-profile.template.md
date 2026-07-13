# Domain-authority review profile — <project-name>

Instantiate this **only if** the project has a domain authority in a role distinct from its architect/operator (see [`docs/domain-authority-review-protocol.md`](../docs/domain-authority-review-protocol.md); the instantiation gate is in [`docs/project-instantiation-workflow.md`](../docs/project-instantiation-workflow.md)). Copy it into the project's operator-side surface (`<project-name>-EXTERNAL/`), fill the fields, and delete the guidance notes.

This is a **minimum, explicitly extensible contract.** Add fields the project needs; do not treat the list as closed. A closed field taxonomy, a universal package shape, universal artifact classes, and any fixed reviewer-role formula or input-firmness taxonomy not already grounded in method doctrine are **held** until a demonstrated second reviewer type earns them.

The profile splits by aging rate: **standing** fields change rarely (they live durably in this profile); the **per-review stage contract** is set fresh for each review request.

---

## Standing (slow-aging)

- **Project apex / decision owner** — who owns the project's source of intent and holds final adoption / closure authority.
- **Architect-operator** — who owns the project's architecture and operation (may or may not be the apex).
- **Domain authority** — the reviewer role. Name the role, not the audience shorthand.
- **Named domain** — the exact subject area within which this authority's judgment is authoritative.
- **Authority scope** — one of: advisory · delegated-binding within named bounds · apex-level where the same person also owns the project intent. State it; do not infer it from expertise.
- **Internal / external relationship** — is the domain authority internal to the operator's organization or an external partner/expert?
- **Confidentiality / disclosure posture** — what may be shared with the reviewer, what the reviewer's input may disclose, and any embargo.
- **Authorized evidence access** — what evidence the reviewer may see and by what path.
- **Return recipient** — who receives the review's output.
- **Execution target** — the surface/executor that acts on adopted output.
- **Closure / recourse route** — how a review closes, and who answers if an adopted decision proves wrong.
- **Local package / marker conventions, if any** — project-local naming, suffixes, or package shapes (these stay project-local; they are not method or ecosystem doctrine).

## Per-review stage contract (fast-aging — set per review request)

- **Current lifecycle / method stage** — where the project actually is now.
- **Fixed target or question** — the specific artifact or decision under review.
- **Decisions open in this review** — what this review may actually decide.
- **Commitments held / out of scope** — what is explicitly not open, so review input on it is roadmap or premature implementation architecture, not current direction.
- **Review mode** — lightweight gut-check · bounded decision · guided decision interview · guided artifact review (extensible).
- **Expected return mode** — direct operator relay · structured handoff · provisional (nothing operative travels yet).
- **Exact-wording requirements** — any formulation that must travel verbatim.
- **Evidence supplied / evidence unavailable** — what the reviewer was given, and what was withheld or missing.

---

*The invariants that govern how this profile is used — authority declaration, expertise-is-not-project-authority, no implicit stage advancement, claim-level classification, the handoff-necessity gate, direct-relay sufficiency, exact-wording preservation, advisor/generated-thread non-authorization, and routing — live in [`docs/domain-authority-review-protocol.md`](../docs/domain-authority-review-protocol.md). This template is the fill-in; the protocol is the rule.*
