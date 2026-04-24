---
name: open-pr
description: Orchestrate the full pre-PR quality pipeline — verify, deslop, then open the PR with a structured description. Use when ready to push and open a PR.
---

# Open PR

Run the full quality pipeline before pushing and opening a PR. Parse `$ARGUMENTS` for flags:

- **(no args)** — full pipeline: verify + deslop + PR
- **--quick** — verify only, skip deslop (for trivial changes)
- **--fix-ci** — after PR is open, poll CI and fix failures (max 3 iterations)

## Phase 1 — Pre-flight

1. Assert current branch is not `main` or `master`. If it is, **stop immediately**.
2. Run `git log --oneline main..HEAD` to show commits that will be in the PR.
3. Run `git diff --stat main...HEAD` to show the scope of changes.
4. If `git status --porcelain` shows uncommitted changes, warn the user and ask whether to include them.
5. If there are no commits ahead of main, tell the user to commit first and **stop**.

## Phase 2 — Quality gates

Run sequentially. Short-circuit on failure.

### Gate 1: Verify

Detect the project's tooling and run verification:

- If a `Makefile` exists with `lint` and `test` targets: run `make lint` then `make test`.
- If lint fails, try `make lint-fix` (or the project's auto-fix command) and re-check.
- If lint still fails or tests fail, **stop** and report the failures.

### Gate 2: Deslop (skip if `--quick`)

Follow the deslop protocol. If `.claude/skills/deslop/SKILL.md` exists in the project, follow that. Otherwise follow the global copy at `~/.claude/skills/deslop/SKILL.md`.

Scope the review to changed files: `git diff --name-only main...HEAD`.

After deslop applies fixes, re-run Gate 1 (verify) to confirm nothing broke. If the re-verify fails, **stop**.

## Phase 3 — Checkpoint

**This is a hard stop. Do NOT proceed without explicit user confirmation.**

Present a summary:

```
Branch:        <branch name>
Commits:       <count> ahead of main
Files changed: <count>
Quality gates: verify ✓, deslop ✓ (or skipped)
```

Then draft:
- A **PR title** (under 70 chars, derived from branch name or commit messages)
- A **PR description** using this structure:

```markdown
## Why

[1-2 sentences: problem solved, business value, what prompted this change]

## What

[Bulleted list. Each bullet: **Bold lead** — what the change enables]

## Test plan

- [x] `make lint` passes
- [x] `make test` passes
- [ ] [Specific smoke tests or manual verification steps]

Generated with [Claude Code](https://claude.com/claude-code)
```

Ask the user to confirm the title, description, and commit message (if there are uncommitted changes to commit). Wait for explicit "go" before proceeding.

## Phase 4 — Ship

1. If there are uncommitted changes the user confirmed: stage and commit with the confirmed message (include `Co-Authored-By` trailer).
2. `git push -u origin <branch>`
3. `gh pr create --title "<title>" --body "<description>"` using the confirmed title and description.
4. Report the PR URL.

## Phase 5 — Fix CI (only with `--fix-ci`)

1. Poll `gh pr checks <PR_NUMBER>` every 90 seconds.
2. If all checks pass, report success and stop.
3. If checks fail, read failure logs: `gh run view <run-id> --log-failed`.
4. Fix the issues locally. Run the project's lint + test to verify the fix.
5. Commit with message: `Fix CI: <what was fixed>` and push.
6. Repeat from step 1. **Max 3 iterations.** If still failing after 3 attempts, stop and report what you've tried.

## Stop rules

- Never push to `main` or `master`.
- Never commit or push without explicit user confirmation at the checkpoint.
- Never auto-merge.
- If a quality gate fails and can't be auto-fixed, stop and report clearly.
- Max 3 CI fix iterations before giving up.
