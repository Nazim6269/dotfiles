$env.PATH = ($env.PATH | prepend "/opt/homebrew/bin")
$env.config.show_banner = false
$env.NVM_DIR = $"($env.HOME)/.nvm"

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# ------------------------
# Git Aliases
# ------------------------

alias gs = git status
alias ga = git add
alias gaa = git add .
alias gp = git push
alias gpl = git pull
alias gf = git fetch
alias gl = git log --oneline --graph --decorate --all
alias gd = git diff

alias gb = git branch
alias gba = git branch -a

alias gm = git switch main
alias gdev = git switch develop

alias gst = git stash
alias gstp = git stash pop

alias grh = git reset --hard
alias grs = git reset --soft

alias gclean = git clean -fd
alias gcl = git clone

# ------------------------
# Git Functions
# ------------------------

def gc [...args] {
    git commit ...$args
}

def gcm [message: string] {
    git commit -m $message
}

def gco [branch: string] {
    git checkout $branch
}

def gsw [branch: string] {
    git switch $branch
}

def gcb [branch: string] {
    git checkout -b $branch
}

def gpu [] {
    let branch = (git branch --show-current | str trim)
    git push -u origin $branch
}

def gbr [] {
    git branch --show-current
}

def grc [] {
    git rebase --continue
}

def gra [] {
    git rebase --abort
}

def gma [branch: string] {
    git merge $branch
}
