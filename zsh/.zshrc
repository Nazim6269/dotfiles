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
setopt autocd              # cd by typing a directory name
#setopt correct            # auto correct mistakes (off by default)
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # filename expansion for arguments like "anything=expression"
setopt nonomatch           # hide error if a glob pattern has no match
setopt notify              # report background job status immediately
setopt numericglobsort     # sort filenames numerically when possible
setopt promptsubst         # enable command substitution in prompt

WORDCHARS='_-' # don't treat these as word boundaries

# Hide the '%' EOL marker some terminals show
PROMPT_EOL_MARK=""

# =========================================================
# KEYBINDINGS
# =========================================================
bindkey -e                                        # emacs-style bindings
bindkey ' ' magic-space                            # history expansion on space
bindkey '^U' backward-kill-line                    # ctrl + U
bindkey '^[[3;5~' kill-word                        # ctrl + Delete
bindkey '^[[3~' delete-char                        # delete
bindkey '^[[1;5C' forward-word                     # ctrl + ->
bindkey '^[[1;5D' backward-word                     # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history     # page up
bindkey '^[[6~' end-of-buffer-or-history           # page down
bindkey '^[[H' beginning-of-line                   # home
bindkey '^[[F' end-of-line                         # end
bindkey '^[[Z' undo                                # shift + tab undo

# =========================================================
# COMPLETION SYSTEM
# =========================================================
autoload -Uz compinit
# Cache dir is portable across machines via $HOME, not hardcoded
compinit -d "${ZSH_COMPDUMP:-$HOME/.cache/zcompdump}"

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# =========================================================
# HISTORY
# =========================================================
HISTFILE="$HOME/.zsh_history"
HISTSIZE=5000
SAVEHIST=5000
setopt hist_expire_dups_first  # delete dupes first when HISTFILE exceeds HISTSIZE
setopt hist_ignore_dups        # ignore duplicate commands in history
setopt hist_ignore_space       # ignore commands that start with a space
setopt hist_verify             # confirm history-expanded command before running
#setopt share_history          # share history across sessions live (off by default)

alias history="history 0"      # show full history

# `time` command output format
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# =========================================================
# CHROOT DETECTION (Debian/Kali-style environments)
# =========================================================
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# =========================================================
# COLOR PROMPT DETECTION
# =========================================================
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# Force color prompt by default (assumes modern terminal emulator)
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

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
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'  # subtle grey suggestion text
        break
    fi
done
unset suggest_path zsh_autosuggestions_paths

# =========================================================
# COMMAND-NOT-FOUND HANDLER (Debian/Kali only — harmless elsewhere)
# =========================================================
if [ -f /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi

# =========================================================
# TOOLING: Bun, Homebrew, Atuin
# All paths below use $HOME instead of a hardcoded username, and each
# tool is loaded only if actually installed — safe to share across machines.
# =========================================================

# --- Bun ---
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# --- Homebrew (macOS default path OR Linuxbrew) ---
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"          # macOS (Apple Silicon)
elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"             # macOS (Intel)
elif [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"  # Linuxbrew
fi

# --- Atuin (shell history sync/search) ---
[ -f "$HOME/.atuin/bin/env" ] && . "$HOME/.atuin/bin/env"
command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh)"

## Oh oh-my-posh themes
eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/atomic.omp.json)"


alias ls='nls --group-directories-first'
alias ll='nls -lg --group-directories-first'
