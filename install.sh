#!/usr/bin/env bash

set -e

REPO_URL="https://github.com/lucasbt/dotfiles.git"
DEST="$HOME/.dotfiles"
DOTFILES_DIR="dots"

# 🧰 Ensure GNU Stow is installed
echo "🔍 Checking if GNU Stow is installed..."
if ! command -v stow >/dev/null 2>&1; then
  echo "📦 Stow not found. Installing..."

  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if command -v dnf >/dev/null 2>&1; then
      sudo dnf install -y stow
    elif command -v apt >/dev/null 2>&1; then
      sudo apt update && sudo apt install -y stow
    else
      echo "❌ Unsupported Linux distribution. Please install 'stow' manually."
      exit 1
    fi
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    if command -v brew >/dev/null 2>&1; then
      brew install stow
    else
      echo "❌ Homebrew not found. Please install Homebrew and try again."
      exit 1
    fi
  else
    echo "❌ Unsupported OS. Please install 'stow' manually."
    exit 1
  fi
else
  echo "✅ Stow is already installed."
fi

# 📥 Clone the dotfiles repository
echo "📥 Cloning repository into $DEST..."
git clone "$REPO_URL" "$DEST"

cd "$DEST"

# 🗃️ Backup existing conflicting files/directories
echo "🗃️ Backing up existing files/folders in home directory..."
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d%H%M%S)"
mkdir -p "$BACKUP_DIR"

cd "$DOTFILES_DIR"

# Iterate over all visible and hidden files/folders
for item in * .*; do
  [[ "$item" == "." || "$item" == ".." ]] && continue

  TARGET="$HOME/$item"

  if [ -e "$TARGET" ] && [ ! -L "$TARGET" ]; then
    echo "↪️  Moving existing $TARGET to backup"
    mv "$TARGET" "$BACKUP_DIR/"
  fi
done

cd "$DEST"

# 🔗 Apply dotfiles using stow
echo "🔗 Applying dotfiles with stow..."
stow "$DOTFILES_DIR"

# ✅ Done
echo "✅ Dotfiles applied successfully!"
echo "📁 Backup saved at: $BACKUP_DIR"
