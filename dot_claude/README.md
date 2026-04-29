# Claude Code config

Global Claude Code configuration, managed alongside dotfiles via chezmoi.

## What's in here

| File | What it does |
|---|---|
| `CLAUDE.md` | Global behavioral guidelines — applied to every Claude Code session |
| `settings.json` | Permissions, hooks, and enabled plugins |
| `skills/` | Hand-written global skills (see below) |
| `scripts/` | Shared helper scripts available to per-project hooks (see below) |

## Skills

Skills in `skills/` are applied to `~/.claude/skills/` by chezmoi and are immediately available in Claude Code.

**Hand-written (tracked here):**

| Skill | What it does |
|---|---|
| `ci-fix` | Diagnose and fix CI failures — read logs, fix locally, verify, push |
| `clean-spec` | Transform specs into clean final-state documents |
| `deslop` | Multi-agent review-readiness pass (rules, types, overengineering) |
| `dotfiles` | Manage dotfiles via chezmoi from inside Claude Code |
| `graphify` | Any input → knowledge graph → clustered communities → HTML + JSON report |
| `grill-me` | Stress-test a plan or design through relentless questioning |
| `open-pr` | Full pre-PR quality pipeline — verify, deslop, then open PR |
| `remove-slop` | Find and remove AI-generated filler |
| `save` | Append a structured session summary to the appropriate vault's daily log |
| `sqlalchemy-alembic-expert-best-practices-code-review` | SQLAlchemy ORM and Alembic migration best practices review |

**Third-party (not tracked — reinstall on new machines):**

```sh
npx skills add -g pbakaus/impeccable
npx skills add -g wshobson/agents --skill python-testing-patterns python-code-style python-design-patterns python-anti-patterns
```

## Adding a new skill

```sh
# 1. Create the skill at ~/.claude/skills/my-skill/SKILL.md
# 2. Add it to chezmoi tracking
chezmoi add ~/.claude/skills/my-skill
# 3. Sync to the dotfiles repo
/dotfiles upload
```

## Scripts

Shared helpers in `scripts/` are applied to `~/.claude/scripts/` by chezmoi. They're available globally but **opt-in per project** — projects must wire them up via their own `.claude/settings.local.json` hooks.

| Script | What it does |
|---|---|
| `session-log.sh` | `SessionEnd` hook that summarizes the session and appends a structured entry to a project's vault sessions log |

### `session-log.sh` — opt-in per project

Reads three env vars set by the calling hook. If `SESSIONS_DIR` is unset the script exits silently — safe to invoke from any project that hasn't opted in.

| Var | Required | What it does |
|---|---|---|
| `SESSIONS_DIR` | yes | directory where `YYYY-MM-DD.md` daily logs accumulate |
| `WIKI_INDEX` | no | path to `wiki/index.md` so the LLM can `[[ ]]`-link known concepts |
| `PROJECT_NAME` | no | label used in the summarization prompt |

To opt a project in, add this to its `.claude/settings.local.json` (gitignored):

```json
{
  "hooks": {
    "SessionEnd": [
      {
        "type": "command",
        "command": "SESSIONS_DIR='/path/to/vault/sessions' WIKI_INDEX='/path/to/vault/wiki/index.md' PROJECT_NAME='ProjectName' bash ~/.claude/scripts/session-log.sh"
      }
    ]
  }
}
```

Each daily log file accumulates entries with structured frontmatter (time, branch, files, concepts, status, blockers, followups, session_id) plus 3–8 imperative-voice bullets at standup altitude. The LLM outputs literal `SKIP` for non-substantive sessions and the script writes nothing.

The summarization runs in a backgrounded subshell so `SessionEnd` returns immediately.

## Syncing changes

Use `/dotfiles upload` from any Claude Code session to sync `~/.claude` config into this repo, branch, and open a PR.
