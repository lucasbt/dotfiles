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

# 📥 Clone or update the dotfiles repository
if [ ! -d "$DEST/.git" ]; then
  echo "📥 Cloning repository into $DEST..."
  git clone "$REPO_URL" "$DEST"
else
  echo "🔄 Repository already exists. Updating..."
  cd "$DEST"
  git fetch origin
  git reset --hard origin/main
fi

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

# 🧩 Create manual symbolic links for specific files outside stow's normal scope
echo "🔗 Creating manual symbolic links..."

STOWDIR="$DEST"

# Ensure target directories exist before linking
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.ssh"

# bw-add-ssh-key link
SRC_BW_KEY="$STOWDIR/local/bw-add-ssh-key"
DST_BW_KEY="$HOME/.local/bin/bw-add-ssh-key"

if [ -e "$SRC_BW_KEY" ]; then
  if [ -e "$DST_BW_KEY" ] && [ ! -L "$DST_BW_KEY" ]; then
    echo "↪️  Backing up existing $DST_BW_KEY"
    mv "$DST_BW_KEY" "$BACKUP_DIR/"
  fi

  ln -sf "$SRC_BW_KEY" "$DST_BW_KEY"
  chmod +x $SRC_BW_KEY
  echo "✅ Linked $DST_BW_KEY → $SRC_BW_KEY"
else
  echo "⚠️ Source $SRC_BW_KEY not found, skipping link."
fi

# ssh config link
SRC_SSH_CONFIG="$STOWDIR/ssh/config"
DST_SSH_CONFIG="$HOME/.ssh/config"

if [ -e "$SRC_SSH_CONFIG" ]; then
  if [ -e "$DST_SSH_CONFIG" ] && [ ! -L "$DST_SSH_CONFIG" ]; then
    echo "↪️  Backing up existing $DST_SSH_CONFIG"
    mv "$DST_SSH_CONFIG" "$BACKUP_DIR/"
  fi

  ln -sf "$SRC_SSH_CONFIG" "$DST_SSH_CONFIG"
  echo "✅ Linked $DST_SSH_CONFIG → $SRC_SSH_CONFIG"
else
  echo "⚠️ Source $SRC_SSH_CONFIG not found, skipping link."
fi

# ✅ Done
echo "✅ Dotfiles applied successfully!"
echo "📁 Backup saved at: $BACKUP_DIR"

echo "➡️ Please run 'source ~/.zshrc' or restart your terminal to apply the changes."
