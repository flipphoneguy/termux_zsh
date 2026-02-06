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

# --- The Prompt (Manjaro Style) ---
autoload -U colors && colors
# Green user, Cyan host, Yellow directory
# PROMPT="%B%{$fg[green]%}%n%{$reset_color%}@%{$fg[cyan]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%b$ "
# PROMPT="%B%{$fg[green]%}%~ %{$reset_color%}%b$ "

setopt PROMPT_SUBST
function precmd() {
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
PROMPT='%B%F{green}${PROMPT_PATH} %f%b%(!.#.$) '


# --- Tab Completion ---
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# --- Plugins (Manually Sourced) ---
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- Keybindings ---
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward


#added stuff
alias la='ls -a'
alias cset='termux-clipboard-set'
alias cget='termux-clipboard-get'
save() {
    echo "$*" | tee -a ~/.bashrc ~/.zshrc
    eval "$*"
}
EOF

# 4. Switch to Zsh immediately
chsh -s zsh
exec zsh
