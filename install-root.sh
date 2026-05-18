#!/bin/bash
# ═══════════════════════════════════════════════════════════
# ROOT INSTALLER - Symlinks to user config
# Usage: sudo ./install-root.sh
# ═══════════════════════════════════════════════════════════

set -e

if [[ $EUID -ne 0 ]]; then
    echo "❌ Este script debe ejecutarse como root (sudo)"
    echo "Usage: sudo $0"
    exit 1
fi

# Detect user from SUDO_USER or logname
if [[ -n "$SUDO_USER" ]]; then
    REAL_USER="$SUDO_USER"
elif [[ -n "$LOGNAME" && "$LOGNAME" != "root" ]]; then
    REAL_USER="$LOGNAME"
else
    REAL_USER=$(logname 2>/dev/null || whoami)
fi

USER_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)

if [[ -z "$USER_HOME" || "$USER_HOME" == "/root" ]]; then
    # Try to find user home by checking /home
    USER_HOME="/home/comandre"
    REAL_USER="comandre"
    if [[ ! -d "$USER_HOME" ]]; then
        echo "❌ No se pudo detectar el usuario"
        exit 1
    fi
fi

echo "╔══════════════════════════════════════════════════════╗"
echo "║          ROOT INSTALLER (SYMLINKS) v2026              ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""
echo "  👤 Usuario detectado: $SUDO_USER"
echo "  📁 Home: $USER_HOME"
echo ""

# ZSH config
echo "➜ Configurando ZSH + Starship..."
ln -sf "$USER_HOME/.zshrc" /root/.zshrc
mkdir -p /root/.config
ln -sf "$USER_HOME/.config/starship" /root/.config/starship
echo "  ✅ ZSH + Starship"

# Polybar
echo "➜ Configurando Polybar..."
ln -sf "$USER_HOME/.config/polybar" /root/.config/polybar
echo "  ✅ Polybar"

# Neofetch
if [[ -d "$USER_HOME/.config/neofetch" ]]; then
    echo "➜ Configurando Neofetch..."
    ln -sf "$USER_HOME/.config/neofetch" /root/.config/neofetch
    echo "  ✅ Neofetch"
fi

# Neovim
if [[ -d "$USER_HOME/.config/nvim" ]]; then
    echo "➜ Configurando Neovim..."
    rm -rf /root/.config/nvim
    ln -sf "$USER_HOME/.config/nvim" /root/.config/nvim
    echo "  ✅ Neovim"
fi

# Neovim base46 cache (theme cache)
if [[ -d "$USER_HOME/.local/share/nvim/base46" ]]; then
    echo "➜ Configurando Neovim base46 cache..."
    rm -rf /root/.local/share/nvim/base46
    mkdir -p /root/.local/share/nvim
    ln -sf "$USER_HOME/.local/share/nvim/base46" /root/.local/share/nvim/base46
    echo "  ✅ Neovim base46 cache"
fi

# FZF
if [[ -d "$USER_HOME/.fzf" ]]; then
    echo "➜ Configurando FZF..."
    ln -sf "$USER_HOME/.fzf" /root/.fzf
    echo "  ✅ FZF"
fi

# list-services
echo "➜ Configurando list-services..."
ln -sf "$USER_HOME/.bin/list-services" /bin/list-services
echo "  ✅ list-services"

# Bin scripts
if [[ -d "$USER_HOME/.bin" ]]; then
    echo "➜ Configurando Scripts..."
    ln -sf "$USER_HOME/.bin" /root/.bin
    echo "  ✅ Scripts"
fi

echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║  ✅ ROOT CONFIGURADO CON SYMLINKS                     ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""