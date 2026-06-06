📦 Dotfiles

This is my personal development environment setup for quickly restoring my tools on any new machine.

It includes configurations for:

Neovim
Nushell
Ghostty
Git

### What are dotfiles?

Dotfiles are configuration files for developer tools.

Instead of copying configs manually, we store them in this repository and link them to system locations using symlinks.

This makes your setup:

Portable
Reproducible
Version-controlled

### How it works (important)

We use symlinks so the system reads configs directly from this repo:

~/.config/nvim    → ~/dotfiles/nvim
~/.config/nushell → ~/dotfiles/nushell
~/.config/ghostty → ~/dotfiles/ghostty

👉 What this means:
All configs live inside this repository
System reads them from ~/.config
You only edit files in one place (~/dotfiles)
Changes are instantly reflected

### 🚀 New Machine Setup (STEP BY STEP)

1. Install prerequisites
Install Git

Make sure Git is installed first:

macOS (Homebrew optional):
brew install git
Ubuntu / Debian:
sudo apt update && sudo apt install git -y
Arch Linux:
sudo pacman -S git

1. Clone this repository
git clone <git@github.com>:Nazim6269/dotfiles.git
cd dotfiles

2. Run setup script (recommended)

This will automatically link everything:

bash setup.sh

1. Create config folder (if needed)

mkdir -p ~/.config

1. Symlinks (manual fallback)

If you don’t use the script:

ln -sf ~/dotfiles/nvim ~/.config/nvim
ln -sf ~/dotfiles/nushell ~/.config/nushell
ln -sf ~/dotfiles/ghostty ~/.config/ghostty

1. Set Git identity (optional but recommended)
git config --global user.name "Nazim6269"
git config --global user.email "<naizmdev10022001@gmail.com>"

✅ Done

Your system is now fully set up 🎉

🧪 Verify setup
ls -l ~/.config

Expected output:

nvim -> /home/user/dotfiles/nvim
nushell -> /home/user/dotfiles/nushell
ghostty -> /home/user/dotfiles/ghostty

### 🔁 Daily workflow

Update configs
cd ~/dotfiles
git add .
git commit -m "update config"
git push

