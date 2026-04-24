# dotfiles

My macOS dotfiles, managed with [chezmoi](https://www.chezmoi.io/).

## What's in here

| File | What it does |
|---|---|
| `dot_zshrc` | Shell config — history, completion, pyenv, fzf, zoxide, module loading |
| `dot_zprofile` | Login shell — Homebrew and nvm initialization |
| `dot_gitconfig` | Git identity and editor |
| `dot_config/zsh/aliases.zsh` | Shell aliases — navigation, ls, shortcuts for lazygit/yazi |
| `dot_config/zsh/git.zsh` | ~30 git aliases (gs, gd, ga, gc, gco, gp, etc.) |
| `dot_claude/CLAUDE.md` | Global Claude Code behavioral guidelines |
| `dot_claude/settings.json` | Claude Code permissions, hooks, and enabled plugins |
| `dot_claude/skills/` | Global Claude Code skills (dotfiles, graphify, grill-me, Python patterns, etc.) |
| `Brewfile` | Declarative list of brew packages and casks |

## Why

Dotfiles in a repo means:
- **Portable** — one command sets up a new machine
- **Version-controlled** — roll back bad changes
- **Reproducible** — same tools and config everywhere

## New machine setup

1. Install [Homebrew](https://brew.sh/)
2. Install dependencies: `brew bundle`
3. Install chezmoi and apply dotfiles:
   ```sh
   brew install chezmoi
   chezmoi init addisonlynch/dotfiles
   chezmoi apply
   ```
4. Install third-party Claude skills (not tracked in this repo — managed by the skills CLI):
   ```sh
   npx skills add -g pbakaus/impeccable
   npx skills add -g wshobson/agents --skill python-testing-patterns python-code-style python-design-patterns python-anti-patterns
   ```

## Day-to-day usage

Dotfile changes are managed through the `/dotfiles` Claude Code skill, which handles the chezmoi workflow interactively. Invoke it from any Claude Code session:

```
/dotfiles          # show drift between disk and repo
/dotfiles sync     # commit disk changes to the repo (per-file approval)
/dotfiles apply    # apply repo to disk (shows diff first)
/dotfiles add ~/.some-config   # start tracking a new file
/dotfiles claude   # sync ~/.claude config specifically
```

Raw chezmoi commands if needed:

```sh
chezmoi diff              # preview what apply would write to disk
chezmoi diff --reverse    # preview what re-add would write to repo
chezmoi re-add ~/.zshrc   # pull a specific file's disk state into the repo
chezmoi apply             # apply all tracked files to disk
```

## Claude Code skills

Skills in `dot_claude/skills/` are applied to `~/.claude/skills/` by chezmoi and are immediately available in Claude Code. Third-party skills installed via `npx skills add` are **not** tracked here — reinstall them on a new machine using the bootstrap command above.

To add a new hand-written skill to the repo:
```sh
# After creating the skill at ~/.claude/skills/my-skill/SKILL.md
chezmoi add ~/.claude/skills/my-skill
# then /dotfiles sync to commit it
```

## Tools included

- **[fzf](https://github.com/junegunn/fzf)** — fuzzy finder. Ctrl+R for searchable history, Ctrl+T for file finder
- **[zoxide](https://github.com/ajeetdsouza/zoxide)** — smarter cd. Type `z myproject` instead of `cd ~/Documents/projects/myproject`
- **[lazygit](https://github.com/jesseduffield/lazygit)** — terminal UI for git
- **[yazi](https://github.com/sxyazi/yazi)** — terminal file manager
- **[glow](https://github.com/charmbracelet/glow)** — markdown viewer in the terminal
