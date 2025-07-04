# Configuration .zshrc avec couleurs et intégration git

# Activation des couleurs
autoload -U colors && colors

# Historique
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt hist_ignore_dups
setopt hist_ignore_space

# Autocomplétion
autoload -U compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Fonction pour afficher l'état git
git_prompt_info() {
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        local git_status=""
        local color=""
        
        # Vérifier l'état du repo
        if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
            git_status="✗"
            color="%{$fg[red]%}"
        else
            git_status="✓"
            color="%{$fg[green]%}"
        fi
        
        # Vérifier les commits en avance/retard
        local ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null)
        local behind=$(git rev-list --count HEAD..@{upstream} 2>/dev/null)
        
        if [ "$ahead" -gt 0 ] && [ "$behind" -gt 0 ]; then
            git_status="${git_status}⇵"
        elif [ "$ahead" -gt 0 ]; then
            git_status="${git_status}⇡"
        elif [ "$behind" -gt 0 ]; then
            git_status="${git_status}⇣"
        fi
        
        echo " ${color}[${branch} ${git_status}]%{$reset_color%}"
    fi
}

# Prompt personnalisé
setopt PROMPT_SUBST
PROMPT='%{$fg[cyan]%}[%n@%m]%{$reset_color%} %{$fg[yellow]%}%~%{$reset_color%}$(git_prompt_info) %{$fg[green]%}❯%{$reset_color%} '

# Couleurs pour ls
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# Alias utiles
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Alias git avec couleurs
alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit -am'
alias gp='git push'
alias gpl='git pull'
alias gd='git diff'
alias gdc='git diff --cached'
alias gl='git log --oneline --graph --decorate'
alias gla='git log --oneline --graph --decorate --all'
alias gb='git branch'
alias gba='git branch -a'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gst='git stash'
alias gsta='git stash apply'
alias gstd='git stash drop'
alias gstl='git stash list'

# Configuration git pour les couleurs
git config --global color.ui auto
git config --global color.branch auto
git config --global color.diff auto
git config --global color.status auto

# Fonction pour afficher un résumé git coloré
gitsum() {
    echo
    print -P "%{$fg[blue]%}=== Git Status ===%{$reset_color%}"
    git status --short
    echo
    print -P "%{$fg[blue]%}=== Recent Commits ===%{$reset_color%}"
    git log --oneline --graph --decorate -10
    echo
    print -P "%{$fg[blue]%}=== Branches ===%{$reset_color%}"
    git branch -a
}

# Activation de la coloration syntaxique (si zsh-syntax-highlighting est installé)
if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Suggestions automatiques (si zsh-autosuggestions est installé)
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Touches de navigation
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char

# Fonction pour changer de branche facilement
gcof() {
    local branch
    branch=$(git branch --all | grep -v HEAD | sed 's/^..//' | fzf --height 40%)
    if [ -n "$branch" ]; then
        git checkout $(echo "$branch" | sed 's#remotes/[^/]*/##')
    fi
}

# === FONCTIONS FZF AVANCÉES ===

# Recherche et édition rapide de fichiers
fe() {
    local files
    files=$(find . -type f -not -path '*/\.*' | fzf --multi --preview 'head -20 {}' --height 60%)
    [ -n "$files" ] && ${EDITOR:-vim} ${files}
}

# Changement de répertoire interactif
fcd() {
    local dir
    dir=$(find . -type d 2>/dev/null | fzf --height 40%)
    [ -n "$dir" ] && cd "$dir"
}

# Recherche dans l'historique et exécution
fh() {
    local cmd
    cmd=$(history 1 | cut -c 8- | fzf --height 40% --reverse --no-sort)
    [ -n "$cmd" ] && eval "$cmd"
}

# Kill process interactif
fkill() {
    local pid
    pid=$(ps -ef | sed 1d | fzf --height 40% --reverse | awk '{print $2}')
    [ -n "$pid" ] && kill -9 $pid
}

# Recherche et ouverture de fichiers avec preview
fv() {
    local file
    file=$(find . -type f | fzf --preview 'bat --style=numbers --color=always --line-range :500 {}' --height 70%)
    [ -n "$file" ] && ${EDITOR:-vim} "$file"
}

# Git log interactif avec diff
fgl() {
    local commit
    commit=$(git log --oneline --graph --color=always | fzf --ansi --preview 'git show --color=always {1}' --height 80%)
    [ -n "$commit" ] && git show $(echo "$commit" | awk '{print $1}')
}

# Recherche et copie de fichiers
fcp() {
    local src dest
    src=$(find . -type f | fzf --prompt "Source: " --height 40%)
    [ -n "$src" ] && {
        dest=$(find . -type d | fzf --prompt "Destination: " --height 40%)
        [ -n "$dest" ] && cp "$src" "$dest"
    }
}

# Recherche dans le contenu des fichiers
frg() {
    local line file
    if [ $# -eq 0 ]; then
        echo "Usage: frg <search_term>"
        return 1
    fi
    
    line=$(grep -rn "$1" . 2>/dev/null | fzf --preview 'echo {}' --height 60%)
    [ -n "$line" ] && {
        file=$(echo "$line" | cut -d: -f1)
        line_num=$(echo "$line" | cut -d: -f2)
        ${EDITOR:-vim} "+$line_num" "$file"
    }
}

# Connexion SSH interactive
fssh() {
    local host
    host=$(grep -E "^Host " ~/.ssh/config 2>/dev/null | awk '{print $2}' | fzf --height 40%)
    [ -n "$host" ] && ssh "$host"
}

# Recherche et installation de paquets (apt)
fap() {
    local package
    package=$(apt list 2>/dev/null | grep -v "WARNING" | fzf --height 60% --preview 'apt show {1}' | cut -d'/' -f1)
    [ -n "$package" ] && sudo apt install "$package"
}

# Recherche et suppression de fichiers
frm() {
    local files
    files=$(find . -type f | fzf --multi --prompt "Fichiers à supprimer: " --height 60%)
    [ -n "$files" ] && {
        echo "Supprimer ces fichiers ?"
        echo "$files"
        read -q "?Confirmer (y/n): " && echo && rm $files
    }
}

# Commandes docker interactives
fdoc() {
    local container
    container=$(docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}" | fzf --height 40% --header-lines=1)
    [ -n "$container" ] && docker exec -it $(echo "$container" | awk '{print $1}') /bin/bash
}

# Recherche et checkout de commit
fgco() {
    local commit
    commit=$(git log --oneline | fzf --height 40% --preview 'git show --color=always {1}')
    [ -n "$commit" ] && git checkout $(echo "$commit" | awk '{print $1}')
}

# Alias FZF utiles
alias f='fzf'
alias ff='fe'  # find files
alias fd='fcd' # find directory
alias fk='fkill' # find kill
alias fp='fzf --preview="head -50 {}"' # preview files

# Configuration FZF (couleurs et options)
export FZF_DEFAULT_OPTS="
    --height 40% 
    --layout=reverse 
    --border 
    --inline-info
    --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9
    --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9
    --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6
    --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4"

# Intégration avec git (si fzf est installé)
if command -v fzf >/dev/null 2>&1; then
    # Recherche de fichiers git
    alias gf='git ls-files | fzf --preview "git log --oneline --follow {}"'
    
    # Stash interactif
    alias gfs='git stash list | fzf --preview "git stash show -p {1}"'
fi

