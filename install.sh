#!/usr/bin/env bash

set -e

REPO_URL="https://github.com/lucasbt/dotfiles.git"
DEST="$HOME/.dotfiles"

echo "📥 Clonando repositório em $DEST..."
git clone "$REPO_URL" "$DEST"

cd "$DEST"

echo "🔧 Executando instalação com make..."
make install
