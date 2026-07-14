#!/bin/bash
# Setup Oh-My-Posh themes in dotfiles

set -e

THEMES_DIR="$HOME/.dotfiles/oh-my-posh/themes"
mkdir -p "$THEMES_DIR"

echo "📦 Downloading Oh-My-Posh themes..."

# Download all themes from the official repository
curl -s https://api.github.com/repos/JanDeDobbeleer/oh-my-posh/contents/themes |
  grep '"download_url"' |
  grep '\.omp\.json' |
  sed 's/.*"download_url": "\(.*\)",.*/\1/' |
  while read url; do
    filename=$(basename "$url")
    echo "  Downloading $filename..."
    curl -s -o "$THEMES_DIR/$filename" "$url"
  done

echo "✅ Downloaded $(ls -1 $THEMES_DIR/*.omp.json 2>/dev/null | wc -l) themes"
echo "📁 Themes stored in: $THEMES_DIR"
echo ""
echo "🎨 Available themes:"
ls -1 "$THEMES_DIR" | sed 's/\.omp\.json$//' | column
