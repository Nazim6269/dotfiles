#!/usr/bin/env bash

set -e # stop on error

echo "🚀 Setting up dotfiles..."

DOTFILES="$HOME/.dotfiles"

# Check if dotfiles repo exists
if [ ! -d "$DOTFILES" ]; then
  echo "❌ Dotfiles folder not found at $DOTFILES"
  exit 1
fi

# Config paths
CONFIG_DIR="$HOME/.config"

# Remove old configs safely
rm -rf "$CONFIG_DIR/nvim"
rm -rf "$CONFIG_DIR/nushell"
rm -rf "$CONFIG_DIR/ghostty"

# Recreate config dir
mkdir -p "$CONFIG_DIR"

# Create symlinks safely
ln -sf "$DOTFILES/nvim" "$CONFIG_DIR/nvim"
ln -sf "$DOTFILES/nushell" "$CONFIG_DIR/nushell"
ln -sf "$DOTFILES/ghostty" "$CONFIG_DIR/ghostty"

echo "✅ Dotfiles linked successfully!"

