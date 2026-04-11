# asset-pipeline-ASK Notes

This example captures the earlier instantiation case where the ChatGPT Project is set up before the target repo exists.

## Instantiation-First Shape

- the Project source pack and external control surface exist first
- project purpose, repo name, and repo description may still be under refinement
- the next prompt is aimed at creating and bootstrapping the repo, not yet operating inside it

## How This Differs From mazeASK

- `mazeASK` is a worked example of an existing repo with repo-local docs already in place
- `asset-pipeline-ASK` illustrates the upstream phase where repo-local truth does not exist yet
- the main decision is what should stay external during setup and what should become repo-local once the repo is created
