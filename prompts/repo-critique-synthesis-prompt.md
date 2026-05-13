# Repo Critique // Synthesis Prompt

Use this prompt in the advisor surface after two independent fresh-context critiques have been produced (using `repo-critique-initial-prompt.md`) — typically one from the execution-surface thread and one from a separate advisor-surface thread.

The synthesis pass is assigned to the advisor role specifically. The role, not the model: the value comes from exteriority to execution-thread momentum, not from which model occupies the role. The same model can occupy either the critic role or the synthesis role in different threads.

This prompt asks the advisor surface to fold both critiques into one analysis and propose an advisory plan. The plan is advisory only; it does not authorize execution. The plan will be handed back to the execution surface via `repo-critique-execution-prompt.md`, where it goes through the project's normal scope-discipline and approval gates.

---

The following are two independent critiques of the same repo, produced by independent fresh-context threads:

**Critique A:**

```
[paste the first critique here]
```

**Critique B:**

```
[paste the second critique here]
```

1. Fold both critiques. Note convergence (where they overlap), divergence (what each found that the other missed), and the net diagnosis.
2. Propose a plan to address the issues that survive synthesis.

The plan is advisory. It is not authorization to execute. Each item in the plan is a candidate for the operator to sequence, edit, or reject. The execution surface will scope, sequence, and stop at exact scoped diff before any commit.
