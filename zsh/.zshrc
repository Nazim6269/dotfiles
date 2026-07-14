# ~/.zshrc — portable, multi-machine dotfiles version
# Works across Linux/macOS, different usernames, with/without Nushell, Homebrew, Bun, Atuin.
# Safe to symlink from ~/.dotfiles/zsh/.zshrc

# =========================================================
# HAND OFF TO NUSHELL (if installed)
# Comment this block out if you want to stay in zsh by default.
# =========================================================
# if command -v nu >/dev/null 2>&1; then
#     exec nu
# fi

# =========================================================
# CORE SHELL OPTIONS
# =========================================================
setopt autocd              # `cd` into a directory just by typing its name
setopt interactivecomments # allow "#" comments in interactive shell
setopt magicequalsubst     # enable filename expansion after "="
setopt nonomatch           # don't error out on unmatched globs
setopt notify              # report background job status immediately
setopt numericglobsort     # sort filenames numerically, not lexically
setopt promptsubst         # allow parameter/command substitution in prompt

# =========================================================
# TOOLING: Bun, Homebrew, Atuin
# =========================================================

# --- Local user binaries ---
# Tools installed via install scripts (not a package manager) commonly
# land here — e.g. oh-my-posh's official install script puts the binary
# at ~/.local/bin/oh-my-posh. This directory isn't on PATH by default
# in every shell/terminal setup, so add it explicitly. (This was the
# actual cause of oh-my-posh not loading in zsh: the binary was never
# on PATH at all, in any timing window — no retry could have fixed it.)
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
# --- Bun ---
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"   # bun completions (single source of truth, no hardcoded path)

# --- Homebrew ---
# Try common brew locations (Apple Silicon, Intel mac, Linuxbrew) and load
# its shell environment (sets PATH, MANPATH, etc.) if found.
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
elif [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# --- Atuin ---
[ -f "$HOME/.atuin/bin/env" ] && . "$HOME/.atuin/bin/env"
command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh)"

# Zoxide
eval "$(zoxide init zsh)"

# =========================================================
# SYNTAX HIGHLIGHTING
# =========================================================
zsh_syntax_highlighting_paths=(
    "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    "/home/linuxbrew/.linuxbrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
)
for highlight_path in "${zsh_syntax_highlighting_paths[@]}"; do
    if [ -f "$highlight_path" ]; then
        source "$highlight_path"
        break
    fi
done
unset highlight_path zsh_syntax_highlighting_paths

# =========================================================
# STYLISH PROMPT CONFIGURATION
# Two-line "boxed" prompt with rounded-feel corners using box-drawing chars
# Color scheme: cyan/magenta accents instead of plain blue/red for a more
# distinctive look. Adjust prompt_symbol or colors to taste.
# =========================================================
configure_prompt() {
    prompt_symbol=㉿
    # Uncomment to show a skull emoji when running as root
    #[ "$EUID" -eq 0 ] && prompt_symbol=💀

    case "$PROMPT_ALTERNATIVE" in
        twoline)
            PROMPT=$'%F{%(#.magenta.cyan)}┌──${debian_chroot:+($debian_chroot)─}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{%(#.red.magenta)}%n'$prompt_symbol$'%m%b%F{%(#.magenta.cyan)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.magenta.cyan)}]\n└─%B%(#.%F{red}#.%F{cyan}❯)%b%F{reset} '
            # Right-side prompt: exit code + background job indicator
            RPROMPT=$'%(?.. %F{red}%B⨯ %?%b%F{reset})%(1j. %F{yellow}%B⚙ %j%b%F{reset}.)'
            ;;
        oneline)
            PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{%(#.red.magenta)}%n@%m%b%F{reset}:%B%F{%(#.cyan.cyan)}%~%b%F{reset}%(#.#.❯) '
            RPROMPT=
            ;;
        backtrack)
            PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{red}%n@%m%b%F{reset}:%B%F{blue}%~%b%F{reset}%(#.#.$) '
            RPROMPT=
            ;;
    esac
    unset prompt_symbol
}

# --- Prompt mode toggles (Ctrl+P switches between oneline/twoline) ---
# These markers are kept intact for compatibility with Kali-derived configs
# START KALI CONFIG VARIABLES
PROMPT_ALTERNATIVE=twoline
NEWLINE_BEFORE_PROMPT=yes
# STOP KALI CONFIG VARIABLES

if [ "$color_prompt" = yes ]; then
    VIRTUAL_ENV_DISABLE_PROMPT=1   # we render venv indicator ourselves above
    configure_prompt

    # =========================================================
    # SYNTAX HIGHLIGHTING (cross-platform path detection)
    # Checks common install locations for Debian/Kali, Arch, and Homebrew
    # (macOS / Linuxbrew) instead of a single hardcoded path.
    # =========================================================
    zsh_syntax_highlighting_paths=(
        "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
        "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
        "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
        "/home/linuxbrew/.linuxbrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    )
    for highlight_path in "${zsh_syntax_highlighting_paths[@]}"; do
        if [ -f "$highlight_path" ]; then
            source "$highlight_path"
            break
        fi
    done
    unset highlight_path zsh_syntax_highlighting_paths

    if (( $+functions[_zsh_highlight] )); then
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
        ZSH_HIGHLIGHT_STYLES[default]=none
        ZSH_HIGHLIGHT_STYLES[unknown-token]=underline
        ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
        ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[global-alias]=fg=green,bold
        ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[path]=bold
        ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[command-substitution]=none
        ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[process-substitution]=none
        ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=green
        ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=green
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[assign]=none
        ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
        ZSH_HIGHLIGHT_STYLES[named-fd]=none
        ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
        ZSH_HIGHLIGHT_STYLES[arg0]=fg=cyan
        ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
        ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
    fi
else
    PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~%(#.#.$) '
fi
unset color_prompt force_color_prompt

# =========================================================
# PROMPT STYLE TOGGLE — Ctrl+P switches oneline <-> twoline
# =========================================================
toggle_oneline_prompt(){
    if [ "$PROMPT_ALTERNATIVE" = oneline ]; then
        PROMPT_ALTERNATIVE=twoline
    else
        PROMPT_ALTERNATIVE=oneline
    fi
    configure_prompt
    zle reset-prompt
}
zle -N toggle_oneline_prompt
bindkey ^P toggle_oneline_prompt

# =========================================================
# TERMINAL TITLE (xterm-compatible terminals, incl. WezTerm/Alacritty)
# =========================================================
case "$TERM" in
xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty|wezterm)
    TERM_TITLE=$'\e]0;${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%n@%m: %~\a'
    ;;
*)
    ;;
esac

precmd() {
    print -Pnr -- "$TERM_TITLE"

    # blank line before each prompt (skip on the very first prompt)
    if [ "$NEWLINE_BEFORE_PROMPT" = yes ]; then
        if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
            _NEW_LINE_BEFORE_PROMPT=1
        else
            print ""
        fi
    fi
}

# =========================================================
# LS / GREP / DIFF COLOR SUPPORT
# =========================================================
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for world-writable dirs

    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'
   
    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
    export MANROFFOPT="-c"

    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
fi

# Quality-of-life ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# =========================================================
# AUTOSUGGESTIONS (cross-platform path detection, same approach as
# syntax highlighting above)
# =========================================================
zsh_autosuggestions_paths=(
    "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
    "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    "/home/linuxbrew/.linuxbrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
)
for suggest_path in "${zsh_autosuggestions_paths[@]}"; do
    if [ -f "$suggest_path" ]; then
        source "$suggest_path"
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'
        break
    fi
done
unset suggest_path zsh_autosuggestions_paths

# =========================================================
# COMMAND-NOT-FOUND HANDLER
# =========================================================
if [ -f /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi

# =========================================================
# PROMPT THEME: oh-my-posh (with retry)
# =========================================================

# Directory where your custom oh-my-posh themes live.
export OMP_THEMES_DIR="$HOME/.dotfiles/oh-my-posh/themes"

# Load oh-my-posh at startup, but only if both `oh-my-posh` and `brew`
# are actually available — previously this ran unconditionally and would
# throw "command not found" errors on any machine missing Homebrew.
#
# NOTE: this also now points at OMP_THEMES_DIR instead of brew's own
# theme directory, so the startup theme matches what `omp-theme` and
# `omp-list` below operate on (previously they used two different
# theme directories, so switching themes with `omp-theme atomic` would
# not match what loaded at shell startup).
# (No retry loop needed here — the real cause of the missing prompt was
# oh-my-posh's install directory (~/.local/bin) not being on PATH at
# all, which is now fixed once at the top of this file. If PATH is
# correct, a single check is sufficient.)
if command -v oh-my-posh >/dev/null 2>&1; then
    default_theme="$OMP_THEMES_DIR/atomic.omp.json"
    if [ -f "$default_theme" ]; then
        eval "$(oh-my-posh init zsh --config "$default_theme")"
        export OMP_CURRENT_THEME="atomic"
    elif command -v brew >/dev/null 2>&1; then
        # Fallback: theme not found locally, use the one bundled with brew's oh-my-posh install
        eval "$(oh-my-posh init zsh --config "$(brew --prefix oh-my-posh)/themes/atomic.omp.json")"
        export OMP_CURRENT_THEME="atomic"
    fi
    unset default_theme
fi

# --- ls aliases ---
# `nls` is a custom/third-party ls replacement, not guaranteed to be
# installed everywhere. Fall back to plain `ls` if it's missing so
# these aliases don't break your shell on a fresh machine.
if command -v nls >/dev/null 2>&1; then
    alias ls='nls --group-directories-first'
    alias ll='nls -lg --group-directories-first'
else
    alias ls='ls --group-directories-first'
    alias ll='ls -lAhF --group-directories-first'
fi

# Function to switch themes
function omp-theme() {
    if [ -z "$1" ]; then
        echo "Usage: omp-theme <theme-name>"
        echo "Available themes:"
        ls -1 "$OMP_THEMES_DIR"/*.omp.json 2>/dev/null | sed 's/.*\/\(.*\)\.omp\.json$/\1/' | column
        return 1
    fi

    local theme_file="$OMP_THEMES_DIR/$1.omp.json"
    if [ ! -f "$theme_file" ]; then
        echo "❌ Theme '$1' not found"
        echo "Available themes:"
        ls -1 "$OMP_THEMES_DIR"/*.omp.json 2>/dev/null | sed 's/.*\/\(.*\)\.omp\.json$/\1/' | column
        return 1
    fi

    echo "🔄 Switching to theme: $1"
    echo "export OMP_CURRENT_THEME=\"$1\"" > ~/.omp_theme
    eval "$(oh-my-posh init zsh --config "$theme_file" 2>/dev/null)"
    export OMP_CURRENT_THEME="$1"
    export OMP_LOADED="true"

    # Force prompt refresh
    if [[ -n "$ZLE" ]]; then
        zle reset-prompt 2>/dev/null || true
    fi
    echo "✅ Theme switched to: $1"
}

# Tab completion for omp-theme
_omp_theme_completion() {
    local -a themes
    themes=($(ls -1 "$OMP_THEMES_DIR"/*.omp.json 2>/dev/null | sed 's/.*\/\(.*\)\.omp\.json$/\1/'))
    compadd -a themes
}
compdef _omp_theme_completion omp-theme

# Aliases
alias omp-list='ls -1 "$OMP_THEMES_DIR"/*.omp.json 2>/dev/null | sed "s/.*\/\(.*\)\.omp\.json$/\1/" | column'
alias omp-current='echo "Current theme: ${OMP_CURRENT_THEME:-Not loaded}"'

# =========================================================
# NVM (Node Version Manager)
# =========================================================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                    # loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # loads nvm bash_completion
