#!/usr/bin/env bash

set -e

REPO_URL="https://github.com/lucasbt/dotfiles.git"
DEST="$HOME/.dotfiles"
MANIFEST_FILE="manifest.dat"

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

# 🗃️ Backup existing files listed in manifest.dat
echo "🗃️ Backing up existing files listed in $MANIFEST_FILE..."
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d%H%M%S)"
mkdir -p "$BACKUP_DIR"

while IFS= read -r relative_path || [ -n "$relative_path" ]; do
  # Ignora linhas vazias ou comentários
  [[ -z "$relative_path" || "$relative_path" == \#* ]] && continue

  SOURCE_PATH="$DEST/$relative_path"
  TARGET_PATH="$HOME/${relative_path#*/}"  # remove prefixo do tipo 'home/', 'ssh/', etc.
  BACKUP_PATH="$BACKUP_DIR/${relative_path#*/}"

  if [ -L "$TARGET_PATH" ]; then
    echo "🧹 Removing symlink: $TARGET_PATH"
    rm "$TARGET_PATH"

  elif [ -f "$TARGET_PATH" ]; then
    echo "↪️  Backing up $TARGET_PATH → $BACKUP_PATH"
    mkdir -p "$(dirname "$BACKUP_PATH")"
    mv "$TARGET_PATH" "$BACKUP_PATH"
  fi
  
done < "$MANIFEST_FILE"

# 🔗 Aplicando dotfiles com Stow
echo "🔗 Applying dotfiles with stow..."
stow *

# ✅ Finalização
echo "✅ Dotfiles applied successfully!"
echo "📁 Backup saved at: $BACKUP_DIR"
echo "➡️ Please run 'source ~/.zshrc' or restart your terminal to apply the changes."
