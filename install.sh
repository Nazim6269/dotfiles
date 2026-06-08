# #!/usr/bin/env bash

# set -e

# echo "🚀 Setting up dotfiles..."

# DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# CONFIG_DIR="$HOME/.config"

# echo "📂 Dotfiles location: $DOTFILES"

# mkdir -p "$CONFIG_DIR"

# CONFIGS=(
# "nvim"
# "nushell"
# "ghostty"
# "wezterm"
# )

# for config in "${CONFIGS[@]}"; do
# SOURCE="$DOTFILES/$config"
# TARGET="$CONFIG_DIR/$config"

# if [ ! -d "$SOURCE" ]; then
# echo "⚠️ Skipping $config (not found)"
# continue
# fi

# if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
# echo "🗑️ Removing existing $TARGET"
# rm -rf "$TARGET"
# fi

# echo "🔗 Linking $config"
# ln -s "$SOURCE" "$TARGET"
# done

# echo ""
# echo "✅ Dotfiles linked successfully!"
# echo "🎉 Setup complete."
