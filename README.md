# dotfiles

macOS dotfiles, managed with [chezmoi](https://www.chezmoi.io/).

## Install

1. Install [Homebrew](https://brew.sh/)
2. Install chezmoi and apply:
   ```sh
   brew install chezmoi
   chezmoi init addisonlynch/dotfiles
   chezmoi apply
   ```
3. Install brew packages: `brew bundle`
4. Install third-party Claude skills (see [dot_claude/README.md](dot_claude/README.md))

## Updating

Dotfile changes are managed through the `/dotfiles` Claude Code skill, which wraps chezmoi with per-file diffs and confirmation prompts.

```
/dotfiles              # show drift between disk and repo
/dotfiles sync         # commit disk changes to the repo (per-file approval)
/dotfiles apply        # apply repo to disk (shows diff first)
/dotfiles add <path>   # start tracking a new file
/dotfiles claude       # sync ~/.claude config specifically
```

Raw chezmoi if needed:

```sh
chezmoi diff              # what apply would write to disk
chezmoi diff --reverse    # what re-add would write to repo
chezmoi re-add ~/.zshrc   # pull disk state into repo
chezmoi apply             # apply all to disk
```

---

## What's in here

### Shell (`dot_zshrc`)

| Setting | Value |
|---|---|
| History | 10k lines, dedup, shared across sessions |
| Auto-cd | `cd` into directories by typing the name |
| Autocorrect | Suggests fixes for typos |
| Completion | Case-insensitive, menu-select |
| Editor | VS Code (`code --wait`) |
| Module loading | Sources all `~/.config/zsh/*.zsh` files |

Initializes: pyenv, fzf, zoxide.

### Login shell (`dot_zprofile`)

Sets up Homebrew (`/opt/homebrew`) and nvm for Node version management.

### Git (`dot_gitconfig`)

Default branch `main`, VS Code as editor/diff tool.

### Shell aliases (`dot_config/zsh/aliases.zsh`)

**Navigation:**

| Alias | Command |
|---|---|
| `..` | `cd ..` |
| `...` | `cd ../..` |
| `....` | `cd ../../..` |

**Listing:**

| Alias | Command |
|---|---|
| `ll` | `ls -alGF` |
| `la` | `ls -A` |
| `l` | `ls -CF` |

**Shortcuts:**

| Alias | Command |
|---|---|
| `c` | `clear` |
| `g` | `git` |
| `lg` | `lazygit` |
| `y` | `yazi` |

**Networking:**

| Alias | Command |
|---|---|
| `lsock` | `sudo lsof -i -P` |
| `openports` | `sudo lsof -i \| grep LISTEN` |

### Git aliases (`dot_config/zsh/git.zsh`)

**Status / info:**

| Alias | Command |
|---|---|
| `gs` | `git status` |
| `gss` | `git status -s` |
| `gd` | `git diff` |
| `gl` | `git log --graph` (pretty, relative dates) |
| `gcount` | `git shortlog -sn` |

**Staging:**

| Alias | Command |
|---|---|
| `ga` | `git add` |
| `gap` | `git add -p` (interactive hunk staging) |
| `gall` | `git add -A` |
| `gus` | `git reset HEAD` (unstage) |

**Commits:**

| Alias | Command |
|---|---|
| `gc` | `git commit -v` |
| `gcm` | `git commit -v -m` |
| `gca` | `git commit -v -a` |
| `gcam` | `git commit -v -am` |

**Branches:**

| Alias | Command |
|---|---|
| `gb` | `git branch` |
| `gba` | `git branch -a` |
| `gbd` | `git branch -d` |
| `gco` | `git checkout` |
| `gcb` | `git checkout -b` |
| `gcom` | `git checkout main` |

**Remote:**

| Alias | Command |
|---|---|
| `gf` | `git fetch --all --prune` |
| `gp` | `git push` |
| `gpo` | `git push origin` |
| `gpu` | `git push --set-upstream` |
| `gpr` | `git pull --rebase` |

**Merge / rebase / stash / tags:**

| Alias | Command |
|---|---|
| `gm` | `git merge` |
| `gcp` | `git cherry-pick` |
| `gstl` | `git stash list` |
| `gstd` | `git stash drop` |
| `gt` / `gta` / `gtd` / `gtl` | tag, tag -a, tag -d, tag -l |

### Claude Code (`dot_claude/`)

Global Claude Code config — behavioral guidelines, permissions, hooks, and hand-written skills. See [dot_claude/README.md](dot_claude/README.md).

### Brew packages (`Brewfile`)

| Category | Packages |
|---|---|
| Core | git, gh |
| Shell | shellcheck, fzf, zoxide |
| Languages | pyenv, nvm, node |
| Tools | lazygit, yazi, glow |
| Apps | VS Code, cmux |

### Tools

- **[fzf](https://github.com/junegunn/fzf)** — fuzzy finder. Ctrl+R for searchable history, Ctrl+T for file finder
- **[zoxide](https://github.com/ajeetdsouza/zoxide)** — smarter cd. `z myproject` instead of `cd ~/Documents/projects/myproject`
- **[lazygit](https://github.com/jesseduffield/lazygit)** — terminal UI for git
- **[yazi](https://github.com/sxyazi/yazi)** — terminal file manager
- **[glow](https://github.com/charmbracelet/glow)** — markdown viewer in the terminal
