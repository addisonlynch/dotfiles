---
name: ci-fix
description: Diagnose and fix CI failures on the current branch's PR. Reads failure logs, fixes locally, verifies, and pushes. Use when CI checks fail on a PR.
---

# CI Fix

Diagnose and fix CI failures for the current branch's open PR. Works with GitHub Actions via `gh`.

## Steps

1. **Find the PR and failing checks:**
   ```
   gh pr checks
   ```
   If no PR exists for this branch, say so and stop.

2. **Get the failing run logs:**
   ```
   gh run view <run-id> --log-failed
   ```
   Parse the output to identify the root cause. Common failures:
   - Lint errors (ruff, eslint)
   - Test failures (pytest, jest)
   - Type errors (mypy, tsc)
   - Migration issues (alembic)
   - Build failures (vite, tsc --noEmit)

3. **Fix locally.** Apply the minimal fix for each failure. Do not make unrelated changes.

4. **Verify locally before pushing.** Run the same checks that failed:
   - Lint failure → `make lint` (or `make lint-fix` then `make lint`)
   - Test failure → `make test`
   - Build failure → `cd frontend && npm run build`
   - Type error → `cd frontend && npx tsc --noEmit`
   - All of the above → `make ci`

   Do NOT push until the local check passes.

5. **Commit and push:**
   - Commit message: `Fix CI: <what was fixed>`
   - Push to the same branch.

6. **Poll for results:**
   - Wait ~90 seconds, then `gh pr checks` again.
   - If still failing, repeat from step 2.
   - **Max 3 iterations.** If the same check fails 3 times, stop and report what you've tried.

## Rules

- Never modify tests just to make them pass — fix the implementation.
- Never lower lint rules, disable checks, or add `noqa`/`eslint-disable` without explicit user approval.
- Never modify CI workflow files unless the workflow itself is broken.
- One commit per fix iteration. Don't squash fix commits — they show the diagnostic trail.
