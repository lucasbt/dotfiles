# =========================
# Zsh Optimized Configuration
# =========================

# Disable CTRL+S / CTRL+Q flow control
stty -ixon

# =========================
# fzf loading
# =========================
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# ----------------------------------------
# Navegação por palavras (Ctrl + → / ←)
# ----------------------------------------
bindkey "^[[1;5C" forward-word     # Ctrl + → para mover uma palavra à frente
bindkey "^[[1;5D" backward-word    # Ctrl + ← para mover uma palavra atrás

# ----------------------------------------
# Busca no histórico com início da linha (setas ↑ ↓)
# ----------------------------------------
bindkey "^[[A" history-beginning-search-backward  # Seta ↑ busca comandos anteriores com prefixo igual
bindkey "^[[B" history-beginning-search-forward   # Seta ↓ busca comandos seguintes com prefixo igual

# ----------------------------------------
# Mover para o início/fim da linha com Alt + ← / →
# (Pode variar dependendo do terminal; veja `cat -v`)
# ----------------------------------------
bindkey "\e[1;3D" beginning-of-line  # Alt + ← vai para o início da linha
bindkey "\e[1;3C" end-of-line        # Alt + → vai para o fim da linha

# ----------------------------------------
# Mover para início/fim da linha com Home/End
# ----------------------------------------
bindkey "^[[H" beginning-of-line     # Tecla Home
bindkey "^[[F" end-of-line           # Tecla End

# ----------------------------------------
# Deletar caractere sob o cursor (Del)
# ----------------------------------------
bindkey "^[[3~" delete-char          # Tecla Delete

# ----------------------------------------
# FZF - fuzzy file finder com Ctrl + Espaço
# ----------------------------------------
bindkey "^@" fzf-file-widget         # Ctrl + Espaço abre fzf


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
[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.functions ] && source ~/.functions
[ -f ~/.dev_aliases ] && source ~/.dev_aliases

# =========================
# Plugins
# =========================
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fpath+=(~/.zsh/plugins/zsh-completions/src)

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
    setopt nullglob
    /usr/bin/ssh-agent -s | sed 's/^echo/#echo/' > "$SSH_ENV"
    chmod 600 "$SSH_ENV"
    source "$SSH_ENV" > /dev/null

    # Adicionar chaves somente se existirem
    for key in ~/.ssh/*_rsa ~/.ssh/id_ed25519 ~/.ssh/*.key; do
        [ -f "$key" ] && ssh-add "$key" 2>/dev/null
    done
    unsetopt nullglob
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
# Starship prompt lazy init
# =========================
if (( $+commands[starship] )); then
    eval "$(starship init zsh)"
fi

# Added by Bootora
export PATH="/usr/local/go/bin:$PATH"
export GOPATH="~/go"
export PATH="~/.local/bin:$PATH"
export PATH="~/.cargo/bin:$PATH"

# =========================
# Bootora autocomplete
# =========================
fpath=(~/.zsh/completions $fpath)
autoload -Uz compinit
compinit -C  # -C skips security checks for speed

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
