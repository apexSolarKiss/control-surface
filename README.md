# control-surface

Reusable control-surface workflow assets for ASK projects.

This repo separates four concerns:

- Live repo-operating files for this repo itself
- External control-surface rules that govern orchestration
- Runnable startup prompts used to attach ChatGPT or Codex to a repo
- Reusable templates for downstream ASK projects

## Repo Layout

### Live files in this repo

- `AGENTS.md`: repo-local execution rules for work inside this repo
- `control-surface.md`: live control model for this meta repo, defining the boundary between external orchestration, repo-local execution rules, prompts, and templates

These files are active operating documents for `control-surface` itself.

### Runnable prompts

- `prompts/`: startup prompts that can be used when attaching an agent to a repo

Prompts are runnable inputs. They are not the same thing as live repo policy and they are not templates by default.

### Reusable templates

- `templates/AGENTS.template.md`: starter for repo-local execution rules in downstream ASK repos
- `templates/control-surface.template.md`: starter for the external control-surface document used around a downstream ASK repo

Templates are copyable scaffolds. They are not live for this repo unless explicitly adopted somewhere else.

## Boundary

The key distinction in this repo is:

- `AGENTS.md` is repo-local and governs execution inside a repo
- `control-surface.md` belongs to the external orchestration layer that frames how a decision-maker, ChatGPT, and Codex work together

This repo contains both its own live operating files and reusable downstream templates, so each file needs to stay explicit about whether it is live, template, external, or repo-local.
