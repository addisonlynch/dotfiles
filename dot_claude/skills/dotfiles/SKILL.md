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
2. Run `chezmoi diff` (repo→disk direction) and `chezmoi diff --reverse` (disk→repo direction)
3. Present drift grouped by file with a one-line summary per file — what changed and in which direction:
   ```
   ~/.zshrc          → repo has more (disk is missing 34 lines)
   ~/.claude/CLAUDE.md → disk has more (new content not in repo)
   ```
4. Ask the user what they want to do with each (sync to repo, apply from repo, or skip)

### Sync disk → repo (`/dotfiles sync`)

This is the "I made changes on my machine, commit them" flow.

1. Check current branch with `git -C ~/Documents/dotfiles2026 branch --show-current`
   - If on `master`: warn the user and ask for confirmation before proceeding. Suggest creating a feature branch instead.
   - If on any other branch: proceed without prompting.
2. Run `chezmoi diff --reverse` to preview what re-add would do — this shows disk→repo direction WITHOUT writing anything.
3. Parse the diff and present it grouped by file with a short summary of what changed in each:
   ```
   ~/.zshrc          — 34 lines removed (stripped to 2 lines)
   ~/.gitconfig      — [core] and [init] sections missing
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

### Sync Claude config (`/dotfiles claude`)

Handles `~/.claude` specifically — see section below.

## ~/.claude in chezmoi

Track these — they are hand-authored config:
- `~/.claude/CLAUDE.md` → `dot_claude/CLAUDE.md`
- `~/.claude/settings.json` → `dot_claude/settings.json`
- Custom hand-written skills in `~/.claude/skills/` (currently: clean-spec, deslop, dotfiles, grill-me, open-pr, remove-slop)

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
5. Update READMEs (see below)

## README maintenance

The repo has two READMEs. After any sync or add operation, check whether the READMEs need updating and update them in the same commit:

- **`README.md`** (repo root) — general dotfiles overview. Update the "What's in here" table if a new top-level dotfile is added or removed.
- **`dot_claude/README.md`** — Claude Code config docs. Update the skills table when a hand-written skill is added or removed. Update third-party install commands if a new third-party skill is adopted.

Do not ask for permission to update READMEs — just include the changes alongside the sync commit.

## Important rules

- **Never `chezmoi apply` without showing the diff first** and getting confirmation. Applying writes to the live home directory.
- **Never push** to the remote without explicit user instruction.
- **Never track secrets** — check any added file for API keys, tokens, or passwords before staging. If found, warn and abort.
- Skills installed via `npx skills add` are NOT dotfiles — leave them alone. Only custom/hand-written skills belong in the repo.
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
