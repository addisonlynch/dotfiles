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
   chezmoi init --apply addisonlynch/dotfiles
   ```

## Day-to-day usage

```sh
# Edit a dotfile (opens in editor, applies on save)
chezmoi edit ~/.zshrc

# Pull latest changes from the repo
chezmoi update

# Add a new file to be managed
chezmoi add ~/.some-config

# Preview what chezmoi would change
chezmoi diff

# Apply changes
chezmoi apply
```

## Tools included

- **[fzf](https://github.com/junegunn/fzf)** — fuzzy finder. Ctrl+R for searchable history, Ctrl+T for file finder
- **[zoxide](https://github.com/ajeetdsouza/zoxide)** — smarter cd. Type `z myproject` instead of `cd ~/Documents/projects/myproject`
- **[lazygit](https://github.com/jesseduffield/lazygit)** — terminal UI for git
- **[yazi](https://github.com/sxyazi/yazi)** — terminal file manager
- **[glow](https://github.com/charmbracelet/glow)** — markdown viewer in the terminal
