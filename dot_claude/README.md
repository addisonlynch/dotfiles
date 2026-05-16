# Claude Code config

Global Claude Code configuration, managed alongside dotfiles via chezmoi.

## What's in here

| Path | What it does |
|---|---|
| `CLAUDE.md` | Global behavioral guidelines — applied to every Claude Code session |
| `settings.json` | Permissions, hooks, and enabled plugins |
| `skills/` | Global skills — both hand-written (chezmoi-tracked) and third-party (npx / graphify) |
| `plugins/` | Plugin packages installed via the Claude Code marketplace; not tracked here |

## Skills

`~/.claude/skills/` holds two kinds of skill, side by side:

- **Real directories** — hand-written, tracked in this dotfiles repo, applied to disk by `chezmoi apply`.
- **Symlinks** — third-party skills managed by `npx skills`. The targets live in `~/.agents/skills/`. Not tracked in chezmoi; reinstall on a new machine.

A separate category is **CLI-managed** skills (graphify) that ship as a real directory but are placed by their own installer, not by chezmoi.

### Hand-written (tracked here)

| Skill | What it does |
|---|---|
| `ci-fix` | Diagnose and fix CI failures — read logs, fix locally, verify, push |
| `clean-spec` | Transform specs into clean final-state documents |
| `deslop` | Multi-agent review-readiness pass (rules, types, overengineering, AI slop) |
| `dotfiles` | Manage dotfiles via chezmoi from inside Claude Code |
| `grill-me` | Stress-test a plan or design through relentless questioning |
| `open-pr` | Full pre-PR quality pipeline — verify, deslop, test-review, security, then open PR |
| `save` | Append a structured session summary to the appropriate vault's daily log |
| `test-review` | Author-side review of test quality on the current change |

### Third-party (reinstall on new machines)

All third-party skills are installed globally (`-g`) so they're available in every project. Reinstall with the commands below.

**Single skills**

```sh
# UI / design — orchestrator skill (covers adapt, animate, audit, polish, etc.)
npx skills add -g pbakaus/impeccable

# Vercel React/Next.js performance guide
npx skills add -g vercel-labs/agent-skills --skill vercel-react-best-practices

# Postgres + Python expert review (from wispbit)
npx skills add -g wispbit-ai/skills \
  -s postgresql-expert-best-practices-code-review \
  -s python-expert-best-practices-code-review

# SQLAlchemy + Alembic review (from wispbit)
npx skills add -g wispbit-ai/skills --skill sqlalchemy-alembic-expert-best-practices-code-review
```

**Bundle from `wshobson/agents`** — broad pattern library (Python, JS/TS, React, SQL, infra). Use repeated `-s` flags; comma-separated lists silently fail.

```sh
npx skills add -g wshobson/agents \
  -s api-design-principles -s async-python-patterns -s database-migration \
  -s debugging-strategies -s dependency-upgrade -s e2e-testing-patterns \
  -s error-handling-patterns -s fastapi-templates -s github-actions-templates \
  -s javascript-testing-patterns -s modern-javascript-patterns \
  -s openapi-spec-generation -s parallel-debugging -s postgresql-table-design \
  -s python-background-jobs -s python-configuration -s python-error-handling \
  -s python-observability -s python-performance-optimization \
  -s python-project-structure -s python-resilience -s python-resource-management \
  -s python-type-safety -s react-modernization -s react-state-management \
  -s responsive-design -s sql-optimization-patterns -s tailwind-design-system \
  -s task-coordination-strategies -s typescript-advanced-types \
  -s uv-package-manager -s web-component-design -s workflow-patterns
```

### CLI-managed (own installer)

| Skill | What it does | Install |
|---|---|---|
| `graphify` | Any input → knowledge graph + community clustering + HTML/JSON report | `pip install graphifyy && graphify install` (PyPI package is `graphifyy`, double y) |

## Updating

Run `/dotfiles update` from any Claude Code session. It pulls the dotfiles repo, applies chezmoi, runs `npx -y skills update -g -y`, and upgrades graphify. See `skills/dotfiles/SKILL.md` for the exact steps.

## Adding a new hand-written skill

```sh
# 1. Create the skill at ~/.claude/skills/my-skill/SKILL.md
# 2. Add it to chezmoi tracking
chezmoi add ~/.claude/skills/my-skill
# 3. Sync to the dotfiles repo and open a PR
/dotfiles upload
```

## Scope rules

- **Hand-written, useful everywhere** → here, tracked by chezmoi.
- **Third-party, useful everywhere** → installed globally with `npx skills add -g`. Listed above for reproducibility, not tracked.
- **Project-specific** (adapter docs, DB ops, etc.) → live in that project's `.claude/skills/`, not here.
- **Plugin-provided** (e.g., `frontend-design`, `playwright`) → installed via the Claude Code plugin marketplace into `~/.claude/plugins/`, not tracked.
