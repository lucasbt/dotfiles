# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# =========================
# History settings (Bash)
# =========================
export HISTFILE=~/.bash_history
export HISTSIZE=10000
export HISTFILESIZE=10000

shopt -s histappend
shopt -s cmdhist
shopt -s lithist

export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="ls:cd:cd -:pwd:exit:clear"

# Incremental history
PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"

# =========================
# Load aliases and functions
# =========================
[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.functions ] && source ~/.functions
[ -f ~/.dev_aliases ] && source ~/.dev_aliases

# =========================
# Starship prompt
# =========================
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi

# fzf configuration
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

__fzf_lazy_load() {
  unbind 'C-t' 'C-r' 2>/dev/null
  source /usr/share/fzf/shell/key-bindings.bash
}

bind -x '"C-t":__fzf_lazy_load'
bind -x '"C-r":__fzf_lazy_load'

# Set up fzf key bindings and fuzzy completion
source <(fzf --bash)

# =========================
# Readline key bindings (Bash)
# =========================

# Navegação por palavras (Ctrl + → / ←)
bind '"\e[1;5C": forward-word'
bind '"\e[1;5D": backward-word'

# Busca no histórico com prefixo (↑ ↓)
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Alt + ← / →
bind '"\e[1;3D": beginning-of-line'
bind '"\e[1;3C": end-of-line'

# Home / End
bind '"\e[H": beginning-of-line'
bind '"\e[F": end-of-line'

# Delete
bind '"\e[3~": delete-char'

# =========================
# SSH agent (only once per session)
# =========================
SSH_ENV="$HOME/.ssh/agent.env"

start_agent() {
    /usr/bin/ssh-agent -s | sed 's/^echo/#echo/' > "$SSH_ENV"
    chmod 600 "$SSH_ENV"
    source "$SSH_ENV" >/dev/null

    for key in ~/.ssh/*_rsa ~/.ssh/id_ed25519 ~/.ssh/*.key; do
        [ -f "$key" ] && ssh-add "$key" 2>/dev/null
    done
}

load_agent() {
    if [ -f "$SSH_ENV" ]; then
        source "$SSH_ENV" >/dev/null
        if ! kill -0 "$SSH_AGENT_PID" 2>/dev/null; then
            start_agent
        fi
    else
        start_agent
    fi
}

if [ -z "$TMUX" ] || [ -z "$SSH_AUTH_SOCK" ]; then
    load_agent
fi

export SSH_AUTH_SOCK

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH=$PATH:/usr/local/go/bin
export GOPATH="$HOME/go"

export PATH="$HOME/.cargo/bin:$PATH"
. "$HOME/.cargo/env"

# =========================
# Bash completion
# =========================
if [ -f /usr/share/bash-completion/bash_completion ]; then
  source /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
  source /etc/bash_completion
fi