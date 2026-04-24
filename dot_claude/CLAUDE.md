# CLAUDE.md

Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan (max ~10 bullet points, no roman numerals):
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

## 5. Response Style

**Be terse. Lead with action, not explanation.**

- Don't summarize what you're about to do. Just do it.
- Keep change summaries concise — no rambling.
- Short commit messages.
- When wrong: fix it, say what went wrong in one sentence, move on. No apologies.

## 6. Destructive Operations

**Never act on these without explicit confirmation:** pushes, DB changes, deleting data, production-affecting commands, force operations.

## 7. Pull Requests

### Description structure

1. **Why** — 1-2 sentences. Problem solved, business value, what prompted the change.
2. **What** — Bulleted list. **Bold lead** — what the change enables (not just what changed).
3. **Test plan** — Checkbox list: lint passes, tests pass, specific smoke tests.

### Writing guidelines

- Present tense, active voice: "Add support for..." not "Added support for..."
- Titles under 70 characters. Details go in the body.
- No implementation commentary in the body — that belongs in commits or comments.
- If the PR requires secrets, env changes, or post-merge steps, call them out explicitly.

### Quality gate

Before opening a PR, run the project's verification suite (lint + test at minimum). Use `/open-pr` to orchestrate the full pipeline.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.

# Skills
- **graphify** (`~/.claude/skills/graphify/SKILL.md`) - any input to knowledge graph. Trigger: `/graphify`
- **open-pr** (`~/.claude/skills/open-pr/SKILL.md`) - full pre-PR quality pipeline (verify + deslop + PR). Trigger: `/open-pr`

When the user types `/graphify` or `/open-pr`, invoke the Skill tool with the corresponding skill name before doing anything else.
