---
name: dotfiles
description: Manage dotfiles via chezmoi — detect drift, sync changes from disk to repo, apply repo to disk, and add new files to tracking. Upload flow handles branch + PR. Trigger: /dotfiles
trigger: /dotfiles
---

# /dotfiles

Manage the chezmoi dotfiles repo at `~/Documents/dotfiles2026`.

## Setup

- **Source repo**: `~/Documents/dotfiles2026` (git remote: `addisonlynch/dotfiles`)
- **Chezmoi config**: `~/.config/chezmoi/chezmoi.toml`
- **Current branch**: check with `git -C ~/Documents/dotfiles2026 branch --show-current`

## Usage

```
/dotfiles              # show drift (what's changed between disk and repo)
/dotfiles status       # two-way: disk→repo unsynced + origin/master→disk unsynced
/dotfiles sync         # commit disk changes back to the repo (no push)
/dotfiles apply        # apply repo to disk (after pull or manual edit)
/dotfiles add <path>   # start tracking a new file or directory
/dotfiles upload       # full publish flow: diff → branch → update README → PR
```

## Workflows

### Two-way status (`/dotfiles status`)

Shows what's out of sync in both directions, always against `origin/master` regardless of what branch the local clone is on.

#### Step 1 — Fetch remote state

```bash
git -C ~/Documents/dotfiles2026 fetch origin
```

This ensures `origin/master` reflects the actual remote — never skip this, since the local clone may be behind or on a feature branch.

#### Step 2 — Disk → repo (what you have locally that the repo doesn't)

Run `chezmoi diff --reverse` and summarize by file:

```
Disk → repo (unsynced local changes):
  ~/.claude/settings.json     — modified
  ~/.claude/skills/dotfiles   — modified
  ~/.zshrc                    — 3 lines added
```

If nothing: "Disk is fully synced to local repo."

#### Step 3 — origin/master → disk (what master has that you don't)

Compare `origin/master` against the current local HEAD:

```bash
git -C ~/Documents/dotfiles2026 log HEAD..origin/master --oneline
git -C ~/Documents/dotfiles2026 diff HEAD..origin/master --stat
```

Summarize as:

```
origin/master → disk (remote changes not yet applied):
  3 commits ahead of your local HEAD
  dot_zshrc     — 10 lines changed
  dot_gitconfig — new section added
```

If local HEAD is already at `origin/master`: "Local repo is up to date with origin/master."

#### Step 4 — Surface current branch

Always show the local clone's current branch so the user knows if they're on a feature branch:

```
Local repo is on branch: update-claude-skills (3 commits ahead of master, 0 behind)
```

#### Offer next steps

After presenting both sides, offer:
- "Run `/dotfiles sync` to commit disk changes to the local repo"
- "Run `/dotfiles apply` to pull origin/master changes down to disk"
- "Run `/dotfiles upload` to branch + PR your local changes"

### Detect drift (`/dotfiles` with no args)

1. Run `chezmoi status` to list all managed files and their state
2. Run `chezmoi diff` (repo→disk direction) and `chezmoi diff --reverse` (disk→repo direction)
3. Present drift grouped by file with a one-line summary per file — what changed and in which direction:
   ```
   ~/.zshrc            → repo has more (disk is missing 34 lines)
   ~/.claude/CLAUDE.md → disk has more (new content not in repo)
   ```
4. Ask the user what they want to do with each (sync to repo, apply from repo, or skip)

### Sync disk → repo (`/dotfiles sync`)

This is the "I made changes on my machine, commit them locally" flow — no push.

1. Check current branch with `git -C ~/Documents/dotfiles2026 branch --show-current`
   - If on `master`: warn the user and ask for confirmation before proceeding. Suggest creating a feature branch instead.
   - If on any other branch: proceed without prompting.
2. Run `chezmoi diff --reverse` to preview what re-add would do — this shows disk→repo direction WITHOUT writing anything.
3. Parse the diff and present it grouped by file with a short summary of what changed in each:
   ```
   ~/.zshrc            — 34 lines removed (stripped to 2 lines)
   ~/.gitconfig        — [core] and [init] sections missing
   ~/.claude/CLAUDE.md — full rewrite (expected)
   ```
4. Ask the user which files to sync. Default to none — require explicit confirmation per file or "all".
5. For approved files only, run `chezmoi re-add <path>` individually (chezmoi re-add accepts specific paths).
6. Stage only the approved files: `git -C ~/Documents/dotfiles2026 add <paths>`
7. Commit with a short descriptive message.
8. Do NOT push — user pushes explicitly.

### Apply repo → disk (`/dotfiles apply`)

This is the "I updated the repo, apply to my machine" flow.

1. Run `chezmoi diff` first so the user sees what will change on disk
2. Ask for confirmation before applying
3. Run `chezmoi apply`
4. Report what was written

### Add a new file (`/dotfiles add <path>`)

1. Run `chezmoi add <path>`
2. Show what was added to the source dir
3. Stage and commit it
4. If the path is inside `~/.config/`, confirm it goes into `dot_config/` in the source

### Upload flow (`/dotfiles upload`)

This is the "I made a bunch of changes, get them into a PR" flow. It handles all dotfiles — including `~/.claude` — in one shot.

#### Step 1 — Show all drift

Run `chezmoi diff --reverse` to show what's changed on disk vs. the repo. Group by file with one-line summaries:

```
~/.zshrc                  — 3 lines added
~/.claude/settings.json   — modified
~/.claude/skills/dotfiles — modified
~/.claude/CLAUDE.md       — no change
```

Also check for any tracked `~/.claude` files that may have been added or removed (new skills, deleted skills) — see the tracking rules below.

#### Step 2 — Ask how to proceed

Ask the user how they want to publish, e.g.:
> "How do you want to handle this? (e.g. new branch off main + open a PR, commit straight to master, etc.)"

Wait for their answer before doing anything.

#### Step 3 — Remind what this does NOT cover

Before proceeding, surface this reminder once:

> **Not tracked by this repo:**
> - Skills installed via `npx skills add` (third-party; reinstalled via bootstrap)
> - `~/.claude/plugins/` cache
> - `~/.claude/shell-snapshots/`, `~/.claude/statsig/`, `~/.claude/projects/`
> - Secrets / API keys in any file (abort if found)
>
> If you've changed any of the above, they won't be in this PR.

#### Step 4 — Update `dot_claude/README.md`

Read the current `dot_claude/README.md` and compare it to the actual state on disk:

- **Skills table**: list every directory under `~/.claude/skills/` that is hand-authored (see tracking rules). Add rows for new skills, remove rows for deleted ones. Update descriptions if the skill's frontmatter `description` field has changed.
- **settings.json summary**: if `settings.json` changed substantially, update any summary or notable-settings section.
- Do not ask for permission — just include the README update in the same commit.

#### Step 5 — Create branch, commit, and offer PR

1. Create a branch off `master` (or whatever base the user specified): `git -C ~/Documents/dotfiles2026 checkout -b <branch>`
2. Run `chezmoi re-add` for all approved paths
3. Stage everything: `git -C ~/Documents/dotfiles2026 add -A dot_claude/ <other approved paths>`
4. Commit with a short message (e.g. `Update claude skills and settings`)
5. Ask: "Ready to push and open a PR?" — do not push until confirmed.
6. On confirmation: `git -C ~/Documents/dotfiles2026 push -u origin <branch>` then `gh pr create` with a short description of what changed.

## ~/.claude tracking rules

Track these — they are hand-authored config:
- `~/.claude/CLAUDE.md` → `dot_claude/CLAUDE.md`
- `~/.claude/settings.json` → `dot_claude/settings.json`
- Hand-authored skills in `~/.claude/skills/` — discover at runtime by listing every subdirectory that contains a `SKILL.md` with a `trigger:` frontmatter field. Do not rely on a hardcoded list.

Do NOT track these — managed by the skills CLI, reinstalled via bootstrap:
- Skills installed via `npx skills add` (live under `~/.claude/plugins/`, not `~/.claude/skills/`)
- `~/.claude/plugins/` cache
- `~/.claude/shell-snapshots/`
- `~/.claude/statsig/`
- `~/.claude/projects/` (session memory, not config)

## README maintenance

The repo has two READMEs. After any sync or add operation, check whether they need updating:

- **`README.md`** (repo root) — general dotfiles overview. Update the "What's in here" table if a new top-level dotfile is added or removed.
- **`dot_claude/README.md`** — Claude Code config docs. Update the skills table when a hand-authored skill is added or removed. Update third-party install commands if a new third-party skill is adopted.

Do not ask for permission to update READMEs — just include the changes alongside the sync commit.

## Important rules

- **Never `chezmoi apply` without showing the diff first** and getting confirmation. Applying writes to the live home directory.
- **Never push** to the remote without explicit user instruction.
- **Never track secrets** — check any added file for API keys, tokens, or passwords before staging. If found, warn and abort.
- Skills installed via `npx skills add` are NOT dotfiles — leave them alone. Only hand-authored skills belong in the repo.
- `docs/` is gitignored and chezmoi-ignored — do not track or version it.
- The `.chezmoiignore` excludes `Brewfile` and `README.md` from chezmoi apply. Don't add those to chezmoi tracking.

## Useful chezmoi commands

```bash
chezmoi status                    # M=modified, A=added to source, D=deleted
chezmoi diff                      # full diff: what apply would do to disk
chezmoi diff --reverse            # reverse: what re-add would do to source
chezmoi re-add                    # pull disk state back into source (sync disk→repo)
chezmoi add ~/.zshrc              # start tracking a file
chezmoi apply                     # apply source to disk
chezmoi apply ~/.zshrc            # apply single file
git -C ~/Documents/dotfiles2026 status
git -C ~/Documents/dotfiles2026 diff
```
