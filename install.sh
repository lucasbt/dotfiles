#!/usr/bin/env bash

set -e

REPO_URL="https://github.com/lucasbt/dotfiles.git"
DEST="$HOME/.dotfiles"
DOTFILES_DIR="dots"

echo "📥 Clonando repositório em $DEST..."
git clone "$REPO_URL" "$DEST"

cd "$DEST"

echo "📦 Fazendo backup dos arquivos/pastas existentes..."
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d%H%M%S)"
mkdir -p "$BACKUP_DIR"

cd "$DOTFILES_DIR"

# Itera sobre TODOS os arquivos e diretórios (visíveis e ocultos)
for item in * .*; do
  # Pula . e ..
  [[ "$item" == "." || "$item" == ".." ]] && continue

  TARGET="$HOME/$item"

  if [ -e "$TARGET" ] && [ ! -L "$TARGET" ]; then
    echo "↪️  Movendo $TARGET para backup"
    mv "$TARGET" "$BACKUP_DIR/"
  fi
done

cd "$DEST"

echo "🔧 Aplicando dotfiles com stow..."
stow "$DOTFILES_DIR"

echo "✅ Dotfiles aplicados com sucesso!"
echo "🗃️  Backup salvo em: $BACKUP_DIR"
