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

## Usage

```
/dotfiles              # show drift (what's changed between disk and repo)
/dotfiles status       # two-way: disk→repo unsynced + origin/master→disk unsynced
/dotfiles sync         # commit disk changes back to the repo (no push)
/dotfiles apply        # apply repo to disk (after pull or manual edit)
/dotfiles add <path>   # start tracking a new file or directory
/dotfiles upload       # full publish flow: diff → branch → update README → PR
/dotfiles update       # update everything: chezmoi pull/apply + npx skills + graphify
```

## Tracking rules

The following paths are tracked:
- `~/.claude/CLAUDE.md` → `dot_claude/CLAUDE.md`
- `~/.claude/settings.json` → `dot_claude/settings.json`
- Hand-authored skills: every subdirectory of `~/.claude/skills/` that contains a `SKILL.md` with a `trigger:` frontmatter field. Discover at runtime — do not rely on a hardcoded list.

Everything else in `~/.claude/` is untracked: `plugins/`, `shell-snapshots/`, `statsig/`, `projects/`, skills installed via `npx skills add`, and skills managed by their own CLI (e.g. `graphify install`). Those are reinstalled via bootstrap.

The `.chezmoiignore` excludes `Brewfile`, `README.md`, and `dot_claude/README.md` from chezmoi apply — do not add those to chezmoi tracking.

Before staging any file, check for API keys, tokens, or passwords. Abort and warn if found.

## Workflows

### `/dotfiles status`

Shows what's out of sync in both directions against `origin/master`.

1. `git -C ~/Documents/dotfiles2026 fetch origin` — always fetch first; the local clone may be on a feature branch or behind remote.
2. Run `chezmoi diff --reverse` and summarize disk→repo drift by file:
   ```
   Disk → repo (unsynced local changes):
     ~/.claude/settings.json   — modified
     ~/.claude/skills/dotfiles — modified
     ~/.zshrc                  — 3 lines added
   ```
   If nothing: "Disk is fully synced to local repo."
3. Run `git log HEAD..origin/master --oneline` and `git diff HEAD..origin/master --stat` and summarize origin/master→disk:
   ```
   origin/master → disk (remote changes not yet applied):
     3 commits ahead of your local HEAD
     dot_zshrc — 10 lines changed
   ```
   If at parity: "Local repo is up to date with origin/master."
4. Show the current branch: `git -C ~/Documents/dotfiles2026 branch --show-current`
5. Offer next steps: `/dotfiles sync`, `/dotfiles apply`, `/dotfiles upload`.

### `/dotfiles` (no args)

1. Run `chezmoi status` and `chezmoi diff` / `chezmoi diff --reverse`.
2. Present drift grouped by file with a one-line summary per file and direction.
3. Ask the user what to do with each file (sync to repo, apply from repo, or skip).

### `/dotfiles sync`

Commits disk changes to the local repo. Does not push.

1. Check current branch. If on `master`, warn and suggest a feature branch before proceeding.
2. Run `chezmoi diff --reverse` (preview only — no writes) and present a grouped summary.
3. Ask which files to sync. Default to none; require explicit confirmation per file or "all".
4. `chezmoi re-add <path>` for each approved file individually.
5. `git -C ~/Documents/dotfiles2026 add <approved paths>` then commit with a short message.

### `/dotfiles apply`

1. Run `chezmoi diff` and show what will change on disk.
2. Ask for confirmation.
3. `chezmoi apply`. Report what was written.

### `/dotfiles update`

Pulls and applies all third-party tooling that lives outside chezmoi tracking, plus pulls the latest dotfiles repo. Run periodically (weekly-ish) or before starting a fresh project.

1. **Dotfiles repo**: `git -C ~/Documents/dotfiles2026 pull --ff-only origin master`. If there's drift, surface it and ask before continuing — don't clobber local changes.
2. **Chezmoi apply**: `chezmoi diff` first; if anything would change on disk, show it and confirm. Then `chezmoi apply`.
3. **Global npx skills**: `npx -y skills update -g -y`. Reports per-skill version bumps.
4. **Graphify** (the CLI tool, not per-project graphs): the PyPI package is `graphifyy` (double y), installed into the active pyenv at `~/.pyenv/versions/$(pyenv version-name)/bin`. Run `pip install -U graphifyy`. Show the version before/after.

Do not touch project-local `npx skills` lock files or per-project `graphify-out/` graphs — those are per-repo concerns, not global tooling.

### `/dotfiles add <path>`

1. `chezmoi add <path>`. Show what was added to the source dir.
2. Stage and commit.
3. Paths inside `~/.config/` go into `dot_config/` in the source.

### `/dotfiles upload`

Full publish flow: all dotfiles including `~/.claude` in one shot.

1. Run `chezmoi diff --reverse` and list all changed files with one-line summaries. Also scan `~/.claude/skills/` for skills not yet in chezmoi (subdirs with `SKILL.md` + `trigger:` that aren't in `chezmoi managed`).
2. Ask the user how to publish (branch strategy, base branch, etc.) and wait for their answer.
3. Surface the scope boundary once:
   > Skills installed via `npx skills add`, `~/.claude/plugins/`, `shell-snapshots/`, `statsig/`, and `projects/` are outside this repo's scope. Changes to those won't be in this PR.
4. Update `dot_claude/README.md`: sync both skills tables — hand-written (from `~/.claude/skills/`) and third-party (from installed plugins). Both tables should reflect the full current inventory. Include this in the same commit.
5. Create the branch, `chezmoi re-add` and `chezmoi add` all approved paths, stage, commit, and ask for confirmation before pushing.
6. On confirmation: push and `gh pr create` with a short description of what changed.

## README maintenance

After any sync, add, or upload operation, update READMEs in the same commit without asking for permission:
- **`README.md`** (repo root): update the "What's in here" table when a top-level dotfile is added or removed.
- **`dot_claude/README.md`**: update both the hand-written and third-party skills tables to reflect the full current inventory.

## Useful chezmoi commands

```bash
chezmoi status                    # M=modified, A=added to source, D=deleted
chezmoi diff                      # full diff: what apply would do to disk
chezmoi diff --reverse            # reverse: what re-add would do to source
chezmoi managed                   # list all tracked paths
chezmoi re-add <path>             # pull specific file from disk into source
chezmoi add <path>                # start tracking a new file
chezmoi apply [<path>]            # apply source to disk (optionally scoped)
git -C ~/Documents/dotfiles2026 status
git -C ~/Documents/dotfiles2026 diff
```
