#!/usr/bin/env bash

pkg install zsh git -y

git clone "https://github.com/zsh-users/zsh-autosuggestions" ~/.zsh/zsh-autosuggestions
git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" ~/.zsh/zsh-syntax-highlighting

cat << 'EOF' > ~/.zshrc
# --- History Settings ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt INC_APPEND_HISTORY

# --- The Prompt (Manjaro Style with Right Status + Timer) ---
autoload -U colors && colors
setopt PROMPT_SUBST

# Timer Hook: Record start time
function preexec() {
    timer=$SECONDS
}

function precmd() {
    # 1. Capture exit codes immediately (Manjaro style 0|1 logic)
    local RETVALS=("${pipestatus[@]}")
    local RET_STR=""

    # Check if all codes are 0 (success)
    local all_success=1
    for val in "${RETVALS[@]}"; do
        if [[ $val -ne 0 ]]; then
            all_success=0
            break
        fi
    done

    # 2. Timer Logic (Only show if > 30s)
    local TIMER_MSG=""
    if [[ -n $timer ]]; then
        local duration=$(($SECONDS - $timer))
        if [[ $duration -ge 30 ]]; then
            local min=$(($duration / 60))
            local sec=$(($duration % 60))
            if [[ $min -gt 0 ]]; then
                TIMER_MSG="%F{yellow}${min}m ${sec}s%f "
            else
                TIMER_MSG="%F{yellow}${sec}s%f "
            fi
        fi
        unset timer
    fi

    # 3. Build Right Prompt
    if [[ $all_success -eq 1 ]]; then
        # Success: Timer + Green Check
        RPROMPT="${TIMER_MSG}%F{green}✔%f"
    else
        # Failure: Timer + Red status codes
        RET_STR="${RETVALS[*]}"
        RPROMPT="${TIMER_MSG}%F{red}${RET_STR// /|}%f"
    fi

    # 4. Path Shortening Logic
    local PWD_STR="${PWD/#$HOME/~}"
    local parts=("${(@s:/:)PWD_STR}")
    local count=${#parts}

    if [[ "$PWD_STR" == "~"* ]]; then
        if (( count > 3 )); then
            PROMPT_PATH="~/.../${parts[-2]}/${parts[-1]}"
        else
            PROMPT_PATH="$PWD_STR"
        fi
    else
        if (( count > 3 )); then
            PROMPT_PATH=".../${parts[-2]}/${parts[-1]}"
        else
            PROMPT_PATH="$PWD_STR"
        fi
    fi
}

# Left Prompt: Path [Symbol]
PROMPT='%B%F{green}${PROMPT_PATH} %f%b%(!.#.$) '


# --- Tab Completion ---
autoload -Uz compinit
# On Termux, standard check can be noisy, -u suppresses insecure dir warnings
compinit -u

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# Better completion grouping
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format %F{yellow}-- %d --%f

# CRITICAL FIX: Disable file-sort for external storage (stat fails on Android)
zstyle ':completion:*' file-sort modification
zstyle ':completion:*' list-colors ''

# Fix for /sdcard and /storage paths - disable problematic stat calls
zstyle ':completion:*:(all-|)files' ignored-patterns ''
zstyle ':completion:*:*:*:*:*' file-patterns '%p:globbed-files' '*(-/):directories'

# Disable secure directory checks that fail on Android
zstyle ':completion:*' accept-exact-dirs true


# --- Plugins (Manually Sourced) ---
[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# --- Keybindings (Fixed for Prefix Search) ---
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Standard Termux codes
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search


# --- Path & Aliases ---
export PATH="$PREFIX/bin:$HOME/go/bin:$HOME/.cargo/bin:$PATH"

alias la='ls -a'
alias ll='ls -l'
alias cset='termux-clipboard-set'
alias cget='termux-clipboard-get'
alias share='termux-share -a send'

save() {
    echo "$*" | tee -a ~/.bashrc ~/.zshrc
    eval "$*"
}

EOF

# 4. Switch to Zsh immediately
chsh -s zsh
exec zsh
