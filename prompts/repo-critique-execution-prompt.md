# Repo Critique // Execution Prompt

Use this prompt in the execution surface after the advisor surface has produced a synthesized critique and advisory plan (using `repo-critique-synthesis-prompt.md`).

This prompt hands the advisor plan to the execution surface. The execution surface verifies repo state fresh, reads the relevant repo truth directly, turns the advisory plan into a scoped implementation plan, and stops at exact scoped diff before any commit. The execution surface does not auto-authorize work; each scoped diff goes through the operator's normal approval gates.

The advisor plan is direction, not procedure. The execution surface owns sequencing, scoping, and the per-PR cadence.

---

The following is an advisory plan produced by the advisor surface, synthesized from two independent fresh-context critiques:

```
[paste the advisory plan here]
```

1. Verify repo state fresh: branch freshness, working tree clean, relevant docs read directly from current main. Do not rely on the plan's repo-state claims without verification.
2. Turn the advisory plan into a scoped implementation plan: name files in scope, scope in/out, non-actions, and expected terminal state. The sequencing is yours to propose; the advisory plan is direction, not a fixed procedure.
3. Stop at exact scoped diff before any commit. The operator approves each scoped diff before commit, per the project's normal cadence.

The advisor plan is advisory direction. Execution authority remains with the operator's approval gates. Do not collapse the advisory plan into automatic work.
