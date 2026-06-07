# 🚀 Dotfiles

My personal development environment setup for quickly restoring my workflow on any machine.

This repository contains configurations for:

* 📝 Neovim
* 🐚 Nushell
* 👻 Ghostty
* ⚡ WezTerm
* 🔧 Git

---

## 📖 What Are Dotfiles?

Dotfiles are configuration files used by developer tools and applications.

Instead of manually copying configuration files between machines, I store them in this repository and create symbolic links (symlinks) to the locations where applications expect them.

### Benefits

* ✅ Portable
* ✅ Reproducible
* ✅ Version Controlled
* ✅ Easy to Back Up
* ✅ Easy to Restore

---

## 🔗 How It Works

This repository serves as the single source of truth for all configurations.

The setup script creates symlinks so applications read configs directly from this repository:

```bash
~/.config/nvim    → ~/dotfiles/nvim
~/.config/nushell → ~/dotfiles/nushell
~/.config/ghostty → ~/dotfiles/ghostty
~/.config/wezterm → ~/dotfiles/wezterm
```

### What This Means

* All configuration files live inside `~/dotfiles`
* Applications read them through symlinks
* Edit once, update everywhere
* Changes take effect immediately

---

# 🛠️ New Machine Setup

Follow these steps to restore your environment on a new machine.

## 1️⃣ Install Git

### macOS

```bash
brew install git
```

### Ubuntu / Debian

```bash
sudo apt update
sudo apt install git -y
```

Verify installation:

```bash
git --version
```

---

## 2️⃣ Clone This Repository

```bash
git clone git@github.com:Nazim6269/dotfiles.git
cd dotfiles
```

---

## 3️⃣ Run the Setup Script

This will automatically create all required symlinks.

```bash
bash setup.sh
```

---

## 4️⃣ Manual Setup (Optional)

If you prefer not to use the setup script:

### Create the Config Directory

```bash
mkdir -p ~/.config
```

### Create Symlinks

```bash
ln -sf ~/dotfiles/nvim ~/.config/nvim
ln -sf ~/dotfiles/nushell ~/.config/nushell
ln -sf ~/dotfiles/ghostty ~/.config/ghostty
ln -sf ~/dotfiles/wezterm ~/.config/wezterm
```

---

## 5️⃣ Configure Git Identity (Optional)

```bash
git config --global user.name "Nazim6269"
git config --global user.email "naizmdev10022001@gmail.com"
```

---

# ✅ Verify Installation

Check that the symlinks were created correctly:

```bash
ls -l ~/.config
```

Expected output:

```bash
nvim    -> ~/dotfiles/nvim
nushell -> ~/dotfiles/nushell
ghostty -> ~/dotfiles/ghostty
wezterm -> ~/dotfiles/wezterm
```

---

# 🔄 Daily Workflow

After making changes:

```bash
cd ~/dotfiles

git add .
git commit -m "update config"
git push
```

---

# 🎉 Done

Your development environment is now fully configured and ready to use.

Clone. Link. Work.
