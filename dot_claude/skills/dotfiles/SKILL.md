---
name: dotfiles
description: Manage dotfiles via chezmoi — detect drift, sync changes from disk to repo, apply repo to disk, and add new files to tracking. Also handles ~/.claude config (CLAUDE.md, settings.json, custom skills). Trigger: /dotfiles
trigger: /dotfiles
---

# /dotfiles

Manage the chezmoi dotfiles repo at `~/Documents/dotfiles2026`.

## Setup

- **Source repo**: `~/Documents/dotfiles2026` (git remote: `addisonlynch/dotfiles`)
- **Chezmoi config**: `~/.config/chezmoi/chezmoi.toml`
- **Current branch**: check with `git -C ~/Documents/dotfiles2026 branch --show-current`
- **Claude config tracked separately** — see section below

## Usage

```
/dotfiles              # show drift (what's changed between disk and repo)
/dotfiles sync         # commit disk changes back to the repo
/dotfiles apply        # apply repo to disk (after pull or manual edit)
/dotfiles add <path>   # start tracking a new file or directory
/dotfiles claude       # sync ~/.claude config into the repo
```

## Workflows

### Detect drift (`/dotfiles` with no args)

1. Run `chezmoi status` to list all managed files and their state
2. Run `chezmoi diff` to show the actual diff
3. Summarize: what changed on disk vs. what's in the repo, and in which direction
4. Ask the user what they want to do (sync to repo, apply from repo, or nothing)

### Sync disk → repo (`/dotfiles sync`)

This is the "I made changes on my machine, commit them" flow.

1. Run `chezmoi re-add` to pull disk changes back into the source repo
2. Run `git -C ~/Documents/dotfiles2026 diff` to review what changed
3. Stage and commit with a short descriptive message
4. Do NOT push — user pushes explicitly

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

### Sync Claude config (`/dotfiles claude`)

Handles `~/.claude` specifically — see section below.

## ~/.claude in chezmoi

Track these — they are hand-authored config:
- `~/.claude/CLAUDE.md` → `dot_claude/CLAUDE.md`
- `~/.claude/settings.json` → `dot_claude/settings.json`
- Custom hand-written skills: `~/.claude/skills/graphify/`, `~/.claude/skills/grill-me/`, `~/.claude/skills/clean-spec/`

Do NOT track these — managed by the skills CLI, reinstalled via bootstrap:
- Third-party skills installed via `npx skills add` (impeccable, etc.)
- `~/.claude/plugins/` cache
- `~/.claude/shell-snapshots/`
- `~/.claude/statsig/`
- `~/.claude/projects/` (session memory, not config)

When running `/dotfiles claude`:
1. Check if `dot_claude/` exists in the source repo yet
2. Add any untracked hand-authored files from the list above
3. Run `chezmoi re-add` for any that are already tracked but modified
4. Diff and commit

## Important rules

- **Never `chezmoi apply` without showing the diff first** and getting confirmation. Applying writes to the live home directory.
- **Never push** to the remote without explicit user instruction.
- **Never track secrets** — check any added file for API keys, tokens, or passwords before staging. If found, warn and abort.
- Skills installed via `npx skills add` are NOT dotfiles — leave them alone. Only custom/hand-written skills belong in the repo.
- The `.chezmoiignore` already excludes `docs/**`, `Brewfile`, and `README.md`. Don't add those.

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
