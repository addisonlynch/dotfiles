---
name: open-pr
description: Orchestrate the full pre-PR quality pipeline — verify, deslop, then open the PR with a structured description. Use when ready to push and open a PR.
---

# Open PR

Run the full quality pipeline before pushing and opening a PR. Parse `$ARGUMENTS` for flags:

- **(no args)** — full pipeline: verify + deslop + PR
- **--quick** — verify only, skip deslop (for trivial changes)
- **--auto** — skip Phase 3 checkpoint (no human confirmation); for autonomous agents. Push and open PR immediately after quality gates pass. Compatible with `--quick`.
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

### Gate 3: Test review (skip if `--quick`, or if no test files changed)

Check if the diff includes test files:

```
git diff --name-only main...HEAD | grep -E '(test_|_test\.|\.test\.|/tests/|/__tests__/)'
```

If any match, follow `~/.claude/skills/test-review/SKILL.md` (or the project copy if present). After fixes apply, re-run Gate 1.

### Gate 4: Security review (triggered)

Run `/security-review` if **any** of the following hold for the diff (`git diff main...HEAD`):

- **Path triggers:** any file under `auth/`, `*middleware*`, `*sql*`, `infra/`, `terraform/`, `.env*`, `requirements*.txt`, `package.json`, `pyproject.toml`, `Dockerfile*`
- **Content triggers:** the diff introduces any of `eval(`, `exec(`, `subprocess`, raw SQL string concatenation/f-strings into `execute(`, `dangerouslySetInnerHTML`, new crypto primitives, regex applied to user input, new outbound HTTP to a non-allowlisted host, changes to authentication/authorization logic

If neither hold, skip this gate. Findings from `/security-review` that are advisory (not blocking) can be summarized in the PR description; blocking findings stop the pipeline.

## Phase 3 — Checkpoint

**This is a hard stop. Do NOT proceed without explicit user confirmation.**

Present a summary:

```
Branch:        <branch name>
Commits:       <count> ahead of main
Files changed: <count>
Quality gates: verify ✓, deslop ✓, test-review ✓ (or skipped), security ✓ (or N/A)
```

Then draft:
- A **PR title** (under 70 chars, derived from branch name or commit messages). If the change is tied to one or more BERKS tickets, prepend `[BERKS-N]` (or `[BERKS-N,BERKS-M]` for multiple) so Plane's GitHub integration links the PR. Example: `[BERKS-21] ci: add Claude agent ticket worker`. Count the bracket prefix against the 70-char budget.
- A **PR description** using this structure:

```markdown
## Why

[1-2 sentences: problem solved, business value, what prompted this change]

## What

[Bulleted list. Each bullet: **Bold lead** — what the change enables. If a bullet is driven by a specific ticket, lead with the linked ticket ID: `[BERKS-11](https://app.plane.so/berkshire/browse/BERKS-11/) — description`. Pure-code bullets with no ticket can omit the link.]

## Tickets resolved

[Only include this section if one or more BERKS tickets are addressed. List each as a hyperlink on its own line: `- [BERKS-11 — Title](https://app.plane.so/berkshire/browse/BERKS-11/)`. Omit the section entirely if there are no tickets.]

## Automated checks

- [x] `make lint` passes
- [x] `make test` passes

## Manual testing

[**Required.** Concrete step-by-step instructions for the reviewer to verify this change in their own environment. Tailor to the area touched — see guidance below. If a change genuinely cannot be manually tested (pure refactor with no behavior change, doc-only edit), say so explicitly: "No manual testing — <one-sentence reason>".]

Generated with [Claude Code](https://claude.com/claude-code)
```

### Ticket linking

When commits, branch names, or context reference a BERKS ticket:

1. Look up each ticket via `mcp__plane__retrieve_work_item_by_identifier` to get its title.
2. In the **What** section, prefix the relevant bullet with `[BERKS-N](https://app.plane.so/berkshire/browse/BERKS-N/) —` (no bold on the ticket ID; bold can follow if the lead phrase needs it).
3. Collect all referenced tickets into a **Tickets resolved** section as `- [BERKS-N — Title](https://app.plane.so/berkshire/browse/BERKS-N/)`.
4. If no tickets are referenced, omit the Tickets resolved section entirely.

### Manual testing — area-specific guidance

Pick the section(s) matching the changed paths. Write **specific** steps (real URLs, real product slugs, real curl commands), not generic placeholders.

**Frontend** (`frontend/src/**`):
- Start the dev server (`make dev` or note if already running).
- Navigate to the specific route(s) affected, e.g. `http://localhost:5173/products/iphone-16-pro`.
- List the exact UI interactions to perform (click X, hover Y, resize to mobile width).
- State what the reviewer should *see* — visual changes, new elements, removed elements, hover/active states.
- Call out edge cases worth eyeballing (empty states, long strings, dark mode if applicable).

**Backend API** (`backend/src/api/**`, `backend/src/services/**`, `backend/src/schemas/**`):
- Start the API (`make dev`).
- Provide concrete `curl` or `httpie` commands hitting the affected endpoints with realistic payloads.
- State the expected response shape / status code.
- If the change affects existing endpoints, include a "before vs. after" example.

**Pipeline / adapters** (`backend/src/pipeline/**`):
- Provide the exact CLI invocation, scoped to a single product to keep it cheap, e.g. `cd backend && PYTHONPATH=src .venv/bin/python -m pipeline.flows.cli collect bestbuy --product iphone-16-pro`.
- State what to look for in the output (row counts, specific log events, DB rows in `listings` / `raw_listings`).
- If proxy or rate-limit behavior changed, note it explicitly — do not ask the reviewer to run a full source.

**Database / migrations** (`backend/migrations/**`, `backend/src/db/**`, `backend/src/models/**`):
- Migration command: `make migrate`.
- One-line `psql` query (or note the QA app page) the reviewer can run to confirm the schema/data shape.
- If destructive: flag it and reference the pre-prod policy in CLAUDE.md.

**Tests-only / refactor / docs**:
- "No manual testing — <reason>" is acceptable. Don't invent steps.

If running with `--auto`, skip user confirmation and proceed directly to Phase 4 using the drafted title and description. Otherwise, ask the user to confirm the title, description, and commit message (if there are uncommitted changes to commit). Wait for explicit "go" before proceeding.

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
