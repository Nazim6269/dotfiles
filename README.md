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

Instead of manually recreating settings on every machine, I store them in this repository and create symbolic links (symlinks) to the locations where applications expect them.

### Benefits

* ✅ Portable
* ✅ Reproducible
* ✅ Version Controlled
* ✅ Easy to Back Up
* ✅ Easy to Restore

---

## 📂 Repository Structure

```text
.
├── README.md
├── setup.sh
├── nvim/
├── nushell/
│   ├── config.nu
│   └── env.nu
├── ghostty/
└── wezterm/
```

---

## 🔗 How It Works

Applications normally load configuration files from `~/.config`.

The setup script creates symlinks so applications read configurations directly from this repository.

```text
~/.config/nvim    → ~/.dotfiles/nvim
~/.config/nushell → ~/.dotfiles/nushell
~/.config/ghostty → ~/.dotfiles/ghostty
~/.config/wezterm → ~/.dotfiles/wezterm
```

### What This Means

* All configuration files live inside `~/.dotfiles`
* Applications access them through symlinks
* Changes are reflected immediately
* Everything stays version controlled

---

# 🛠️ New Machine Setup

## 1. Install Git

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

## 2. Clone the Repository

Clone into a hidden folder:

```bash
git clone git@github.com:Nazim6269/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

---

## 3. Run the Setup Script

```bash
bash setup.sh
```

The script will:

* Create `~/.config` if needed
* Remove existing linked configs
* Create fresh symlinks

---

## 4. Verify Installation

Check the created symlinks:

```bash
ls -la ~/.config
```

Expected output:

```text
nvim    -> ~/.dotfiles/nvim
nushell -> ~/.dotfiles/nushell
ghostty -> ~/.dotfiles/ghostty
wezterm -> ~/.dotfiles/wezterm
```

---

# 🔄 Updating Dotfiles

After making changes:

```bash
cd ~/.dotfiles

git add .
git commit -m "update config"

git push
```

---

# 🔄 Sync on Another Machine

```bash
cd ~/.dotfiles

git pull

bash setup.sh
```

---

# 🧹 Removing Dotfiles

If you want to remove the symlinks:

```bash
rm -rf ~/.config/nvim
rm -rf ~/.config/nushell
rm -rf ~/.config/ghostty
rm -rf ~/.config/wezterm
```

---

# 🎉 Done

Your development environment can now be restored on any machine with:

```bash
git clone git@github.com:Nazim6269/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
bash setup.sh
```
