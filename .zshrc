# =========================
# Zsh Optimized Configuration
# =========================

# Disable CTRL+S / CTRL+Q flow control
stty -ixon

# Key bindings for navigation and history search
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
bindkey "^@" fzf-file-widget  # CTRL+SPACE for fzf

# =========================
# History settings
# =========================
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST="$HISTSIZE"
setopt HIST_FIND_NO_DUPS HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY SHARE_HISTORY APPEND_HISTORY HIST_IGNORE_SPACE INTERACTIVE_COMMENTS
setopt AUTO_CD CORRECT

# =========================
# Load aliases and functions
# =========================
[ -f ~/.bash_aliases ] && source ~/.bash_aliases
[ -f ~/.bash_functions ] && source ~/.bash_functions
[ -f ~/.dev_aliases ] && source ~/.dev_aliases

# =========================
# Plugins
# =========================
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fpath+=(~/.zsh/plugins/zsh-completions/src)

# =========================
# Bootora autocomplete
# =========================
fpath=("/home/lucas/.zsh/completions" $fpath)
autoload -Uz compinit
compinit -C  # -C skips security checks for speed

# =========================
# Bootora environment
# =========================
export PATH="$HOME/.local/bin:$PATH"
export BOOTORA_HOME="$HOME/.local/share/bootora"

# =========================
# SSH agent (only once per session)
# =========================
SSH_ENV="$HOME/.ssh/agent.env"

start_agent() {
    /usr/bin/ssh-agent -s | sed 's/^echo/#echo/' > "$SSH_ENV"
    chmod 600 "$SSH_ENV"
    source "$SSH_ENV" > /dev/null
    ssh-add ~/.ssh/*_rsa ~/.ssh/id_ed25519 ~/.ssh/*.key 2>/dev/null
}

load_agent() {
    if [ -f "$SSH_ENV" ]; then
        source "$SSH_ENV" > /dev/null
        if ! kill -0 "$SSH_AGENT_PID" 2>/dev/null; then
            start_agent
        fi
    else
        start_agent
    fi
}

# Only run once per real session
if [ -z "$TMUX" ] || [ -z "$SSH_AUTH_SOCK" ]; then
    load_agent
fi
export SSH_AUTH_SOCK

# =========================
# fzf lazy loading
# =========================
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

fzf_lazy() {
    [ -f /usr/share/fzf/shell/key-bindings.zsh ] && source /usr/share/fzf/shell/key-bindings.zsh
    [ -f /usr/share/fzf/shell/key-bindings.bash ] && source /usr/share/fzf/shell/key-bindings.bash
}
# load fzf only when pressing CTRL+T or first fzf command
zle -N fzf-file-widget fzf_lazy

# =========================
# Starship prompt lazy init
# =========================
if (( $+commands[starship] )); then
    eval "$(starship init zsh)"
fi
