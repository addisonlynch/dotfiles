# Dotfiles 2026 — Modernization Plan (revised)

## Context

Existing dotfiles (2018-2020) built for Debian/Ubuntu + bash + tmux + Python 2/3 + virtualenvwrapper + yadm + emacs. Now on macOS 15 + zsh + cmux + pyenv + nvm + VS Code. Clean-slate rebuild using **chezmoi**.

---

## Management: chezmoi

chezmoi manages dotfiles by storing source-of-truth files in `~/.local/share/chezmoi/` and applying them to `$HOME`. Supports diffing, templates, and run scripts. Setup on a new machine is one command: `chezmoi init --apply addisonlynch/dotfiles`.

We'll initialize chezmoi in this repo, then push to `addisonlynch/dotfiles` (overwrite content, preserve git history).

---

## Structure

chezmoi uses a naming convention for its source directory:

```
dotfiles2026/                          # becomes ~/.local/share/chezmoi/
├── dot_zshrc                          # → ~/.zshrc
├── dot_zprofile                       # → ~/.zprofile
├── dot_gitconfig                      # → ~/.gitconfig
├── private_dot_config/
│   └── zsh/
│       ├── aliases.zsh                # → ~/.config/zsh/aliases.zsh
│       └── git.zsh                    # → ~/.config/zsh/git.zsh
├── run_once_install-packages.sh       # runs `brew bundle` on first apply
├── .chezmoiignore                     # files chezmoi should ignore
├── docs/
│   └── plans/
│       └── initial-plan.md
└── Brewfile                           # referenced by run script
```

---

## File contents

### `dot_zshrc` → `~/.zshrc`
- History: 10k lines, dedup, shared across sessions
- Shell options: auto-cd, typo correction, no beep
- Tab completion: case-insensitive matching + arrow menu
- pyenv init
- `EDITOR=code --wait`
- PATH: `~/.local/bin`
- Sources all `~/.config/zsh/*.zsh` files
- fzf keybindings + completion (Ctrl+R fuzzy history, Ctrl+T file finder)
- zoxide init (`z` for smart cd)
- No prompt customization (system default)

### `dot_zprofile` → `~/.zprofile`
- Homebrew shell env
- nvm initialization

### `private_dot_config/zsh/aliases.zsh`
- **Navigation**: `..`, `...`, `....`
- **ls**: `ll`, `la`, `l` (macOS flags)
- **Shortcuts**: `c`=clear, `g`=git, `lg`=lazygit, `y`=yazi
- **Grep**: `--color=auto`
- **Networking**: `lsock`, `openports`
- No safety aliases (cp -iv, mv -iv dropped)
- No python/virtualenvwrapper/debian aliases

### `private_dot_config/zsh/git.zsh`
Full set (~30 aliases) ported from old dotfiles:
- Status: `gs`, `gss`, `gd`
- Log: `gl` (graph + pretty format)
- Staging: `ga`, `gap`, `gall`, `gus`
- Commits: `gc`, `gcm`, `gca`, `gcam`
- Branches: `gb`, `gba`, `gbd`, `gco`, `gcb`, `gcom` (hardcoded to `main`)
- Remote: `gf`, `gp`, `gpo`, `gpu`, `gpr`
- Merge: `gm`, `gcp`, `gsu`
- Stash: `gstl`, `gstd`
- Tags: `gt`, `gta`, `gtd`, `gtl`
- Removed: `gh` (conflicts with CLI), `gpom` (push origin master)

### `dot_gitconfig` → `~/.gitconfig`
- `[user]` name=addisonlynch, email=ahlshop@gmail.com
- `[core]` editor=code --wait
- `[init]` defaultBranch=main
- No workflow opinions (no pull.rebase, no push.autoSetupRemote)

### `run_once_install-packages.sh`
chezmoi run script — executes once on first `chezmoi apply`:
1. Checks for Homebrew, installs if missing
2. Runs `brew bundle --file={{ .chezmoi.sourceDir }}/Brewfile`

### `Brewfile`
- **Core**: git, gh
- **Languages**: pyenv, nvm, node
- **Tools**: lazygit, yazi, glow, shellcheck, fzf, zoxide
- **Apps**: visual-studio-code, cmux (casks)

### `.chezmoiignore`
- `docs/**`
- `Brewfile` (used by run script, not a dotfile)
- `README.md`

### `README.md`
Simple docs covering:
- **What's in here**: one-line description of each file and what it does
- **Why**: why we have dotfiles at all (portable config, reproducible setup, version-controlled)
- **Install on a new machine**: `chezmoi init --apply addisonlynch/dotfiles`
- **Edit a dotfile**: `chezmoi edit ~/.zshrc` (opens in editor, applies on save)
- **Pull updates**: `chezmoi update`
- **Add a new file**: `chezmoi add ~/.some-config`
- **Preview changes**: `chezmoi diff`

---

## What's killed

| Old thing | Why |
|---|---|
| `.bashrc` / `.bash_aliases` | zsh now |
| yadm / stow | chezmoi now |
| tmux / tmuxp / `.tmux.conf` | cmux now |
| virtualenvwrapper | pyenv now |
| Python 2 aliases, hardcoded python3.x | pyenv handles it |
| emacs as EDITOR | VS Code now |
| `.dotbin/` scripts | `gh repo clone` replaces git_clone.py, tmuxp gone |
| All tmuxp YAMLs | dead projects |
| Debian/Ubuntu stuff | macOS now |
| IEX sandbox token | leaked, removed |
| grc/colourify | unnecessary |
| Starship | user declined |
| Shell functions (extract, mkd, etc.) | user declined |
| Safety aliases (cp -iv, mv -iv) | user declined |

---

## Existing file merge

Current `~/.zshrc` has `pyenv init` and PATH. Current `~/.zprofile` has brew + nvm. Both are already accounted for in the new files. chezmoi will diff before applying so you can see what changes.

---

## Verification

1. `chezmoi diff` — preview what chezmoi will change before applying
2. `chezmoi apply -v` — apply with verbose output
3. Open a new terminal tab — confirm zsh loads without errors
4. Run `gs` in a git repo — confirm aliases work
5. Run `lazygit`, `yazi` — confirm tools work

---

## Execution order

1. Install chezmoi (`brew install chezmoi`)
2. `chezmoi init` in this directory
3. Create all source files with chezmoi naming conventions
4. `chezmoi diff` to verify
5. `chezmoi apply` to deploy
6. Clone addisonlynch/dotfiles, replace content, push
