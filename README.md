# 🛠️ dotfiles

Personal configuration files used to quickly set up my development environment on new machines.

This repository uses the [`stow`](https://www.google.com/search?q=%5Bhttps://www.gnu.org/software/stow/%5D\(https://www.gnu.org/software/stow/\)) utility to apply the files via symlinks in the `$HOME` directory.

## 📦 Contents

This repository contains some of the following configuration files:

  - `.aliases` – Custom aliases
  - `.functions` – Helper functions for the shell
  - `.gitconfig`, `.gitignore`, `.gitattributes` – Git configurations
  - `.git-completion.bash` – Git command autocompletion in Bash
  - `.inputrc` – Command line behavior settings
  - `.nanorc` – Customizations for the Nano editor
  - `.wgetrc` – `wget` configurations
  - `.zshrc`, `.zshenv` – Zsh configurations

## 🚀 Quick Installation

### 1. Prerequisites

  - `git`
  - [`stow`](https://www.gnu.org/software/stow/)
    Install with:

```bash
# Fedora
sudo dnf install stow
# Debian/Ubuntu
sudo apt install stow
# macOS (via Homebrew)
brew install stow
```

### 2. Automatic Installation

Run the command below in the terminal:

```bash
curl -sL https://raw.githubusercontent.com/lucasbt/dotfiles/main/install.sh | sh
```

This command will:

  - Clone this repository into the `~/.dotfiles` directory
  - Use `stow` to apply the files to your `$HOME`

## ⚙️ Makefile

This repository includes a `Makefile` with the following targets:

  - `make install` — Applies the dotfiles to the home directory using `stow`
  - `make clean` — Removes the symlinks applied by `stow`

## 🧼 Removal

To undo the symlinks:

```bash
make clean
```
