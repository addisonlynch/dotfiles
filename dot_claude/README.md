# Claude Code config

Global Claude Code configuration, managed alongside dotfiles via chezmoi.

## What's in here

| File | What it does |
|---|---|
| `CLAUDE.md` | Global behavioral guidelines — applied to every Claude Code session |
| `settings.json` | Permissions, hooks, and enabled plugins |
| `skills/` | Hand-written global skills (see below) |

## Skills

Skills in `skills/` are applied to `~/.claude/skills/` by chezmoi and are immediately available in Claude Code.

**Hand-written (tracked here):**

| Skill | What it does |
|---|---|
| `ci-fix` | Diagnose and fix CI failures — read logs, fix locally, verify, push |
| `clean-spec` | Transform specs into clean final-state documents |
| `deslop` | Multi-agent review-readiness pass (rules, types, overengineering) |
| `dotfiles` | Manage dotfiles via chezmoi from inside Claude Code |
| `grill-me` | Stress-test a plan or design through relentless questioning |
| `open-pr` | Full pre-PR quality pipeline — verify, deslop, then open PR |
| `remove-slop` | Find and remove AI-generated filler |
| `save` | Append a structured session summary to the appropriate vault's daily log |
| `sqlalchemy-alembic-expert-best-practices-code-review` | SQLAlchemy ORM and Alembic migration best practices review |

**Third-party (reinstall on new machines):**

| Skill | What it does | Install |
|---|---|---|
| `graphify` | Any input → knowledge graph → clustered communities → HTML + JSON report | `pip install graphify && graphify install` |
| `impeccable` | Production-grade frontend UI generation | `npx skills add -g pbakaus/impeccable` |
| `python-testing-patterns` | pytest fixtures, mocking, and test strategies | `npx skills add -g wshobson/agents --skill python-testing-patterns` |
| `python-code-style` | Python linting, formatting, and naming conventions | `npx skills add -g wshobson/agents --skill python-code-style` |
| `python-design-patterns` | KISS, SRP, and Python design patterns | `npx skills add -g wshobson/agents --skill python-design-patterns` |
| `python-anti-patterns` | Common Python anti-patterns to avoid | `npx skills add -g wshobson/agents --skill python-anti-patterns` |

## Adding a new skill

```sh
# 1. Create the skill at ~/.claude/skills/my-skill/SKILL.md
# 2. Add it to chezmoi tracking
chezmoi add ~/.claude/skills/my-skill
# 3. Sync to the dotfiles repo
/dotfiles upload
```

## Syncing changes

Use `/dotfiles upload` from any Claude Code session to sync `~/.claude` config into this repo, branch, and open a PR.
