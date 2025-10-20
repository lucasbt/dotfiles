#!/bin/bash

# Path to the dotfiles directory (default: ~/.dotfiles)
DOTFILES_DIR=~/"${1:-.dotfiles}"

# Output file
MANIFEST_FILE="manifest.dat"

# Check if the directory exists
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Directory '$DOTFILES_DIR' not found."
    exit 1
fi

# Clear the manifest file if it exists
> "$MANIFEST_FILE"

# Find all files (excluding unwanted ones)
find "$DOTFILES_DIR" -type f \
  ! -path "$DOTFILES_DIR/.git/*" \
  ! -path "$DOTFILES_DIR/install.sh" \
  ! -path "$DOTFILES_DIR/Makefile" \
  ! -path "$DOTFILES_DIR/manifest.dat" \
  ! -path "$DOTFILES_DIR/README.md" \
  ! -path "$DOTFILES_DIR/.gitignore" \
  ! -path "$DOTFILES_DIR/generate-manifest.sh" \
| while read -r FILE; do
    # Remove the ".dotfiles/" prefix
    RELATIVE_PATH="${FILE#$DOTFILES_DIR/}"

    # Remove the first directory component
    TRIMMED_PATH="$(echo "$RELATIVE_PATH" | cut -d'/' -f2-)"

    # Prepend ~/
    FINAL_PATH="~/$TRIMMED_PATH"

    # Write to the manifest
    echo "$FINAL_PATH" >> "$MANIFEST_FILE"
done

echo "Manifest file created successfully at '$MANIFEST_FILE'."
