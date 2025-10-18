#!/usr/bin/env bash

set -e

REPO_URL="https://github.com/lucasbt/dotfiles.git"
DEST="$HOME/dotfiles"
DOTFILES_DIR="dotfiles"

echo "📥 Clonando repositório em $DEST..."
git clone "$REPO_URL" "$DEST"

cd "$DEST/$DOTFILES_DIR"

echo "📦 Fazendo backup dos arquivos existentes..."
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d%H%M%S)"
mkdir -p "$BACKUP_DIR"

for file in .*; do
  [[ "$file" =~ ^\.(\.|git|stow|DS_Store) ]] && continue
  if [ -e "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
    echo "↪️  Movendo $file para backup"
    mv "$HOME/$file" "$BACKUP_DIR/"
  fi
done

cd "$DEST"

echo "🔧 Aplicando dotfiles com stow..."
stow "$DOTFILES_DIR"

echo "✅ Dotfiles aplicados com sucesso!"
echo "🗃️  Backup salvo em: $BACKUP_DIR"
