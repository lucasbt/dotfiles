#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/lucasbt/dotfiles.git"
DEST="$HOME/.dotfiles"
MANIFEST_FILE="manifest.dat"

echo "🔍 Checking if GNU Stow is installed..."
if ! command -v stow >/dev/null 2>&1; then
  echo "📦 Installing GNU Stow..."

  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if command -v apt >/dev/null 2>&1; then
      sudo apt update && sudo apt install -y stow
    elif command -v dnf >/dev/null 2>&1; then
      sudo dnf install -y stow
    else
      echo "❌ Unsupported Linux distro"
      exit 1
    fi
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install stow
  else
    echo "❌ Unsupported OS"
    exit 1
  fi
fi

# 📥 Clone or update repo
if [ ! -d "$DEST/.git" ]; then
  echo "📥 Cloning dotfiles..."
  git clone "$REPO_URL" "$DEST"
else
  echo "🔄 Updating dotfiles..."
  git -C "$DEST" fetch origin
  git -C "$DEST" reset --hard origin/main
fi

cd "$DEST"

# 🗃️ Safe backup (COPY, never MOVE)
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "🗃️ Creating safe backup (non-destructive)..."

while IFS= read -r relative_path || [ -n "$relative_path" ]; do
  [[ -z "$relative_path" || "$relative_path" == \#* ]] && continue

  TARGET_PATH="$HOME/${relative_path#*/}"
  BACKUP_PATH="$BACKUP_DIR/${relative_path#*/}"

  if [ -L "$TARGET_PATH" ]; then
    echo "🧹 Removing old symlink: $TARGET_PATH"
    rm "$TARGET_PATH"

  elif [ -e "$TARGET_PATH" ]; then
    echo "📦 Backing up (copy): $TARGET_PATH → $BACKUP_PATH"
    mkdir -p "$(dirname "$BACKUP_PATH")"
    cp -a "$TARGET_PATH" "$BACKUP_PATH"
  fi
done < "$MANIFEST_FILE"

# 🔗 Apply dotfiles with Stow
echo "🔗 Applying dotfiles with stow..."

STOW_DIRS=()
while IFS= read -r dir; do
  STOW_DIRS+=("$dir")
done < <(find . -maxdepth 1 -type d ! -name '.git' ! -name '.' -printf '%P\n')

if [ "${#STOW_DIRS[@]}" -gt 0 ]; then
  stow "${STOW_DIRS[@]}"
else
  echo "⚠️ No directories to stow."
fi

echo "✅ Dotfiles applied successfully!"
echo "📁 Backup stored at: $BACKUP_DIR"
echo "➡️ Restart your shell or source your config files."
