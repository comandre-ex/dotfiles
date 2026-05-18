#!/bin/bash
# ═══════════════════════════════════════════════════════════
# ROOT INSTALLER - Symlinks to user config
# Adaptado para Kali Linux
# Usage: sudo ./install-root.sh
# ═══════════════════════════════════════════════════════════

set -e

if [[ $EUID -ne 0 ]]; then
    echo "❌ Este script debe ejecutarse como root (sudo)"
    echo "Usage: sudo $0"
    exit 1
fi

# Detectar usuario real
if [[ -n "$SUDO_USER" ]]; then
    REAL_USER="$SUDO_USER"
elif [[ -n "$LOGNAME" && "$LOGNAME" != "root" ]]; then
    REAL_USER="$LOGNAME"
else
    REAL_USER=$(logname 2>/dev/null || whoami)
fi

USER_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)

# Fallback: en Kali el usuario por defecto suele ser 'kali'
if [[ -z "$USER_HOME" || "$USER_HOME" == "/root" ]]; then
    for candidate in kali comandre; do
        if [[ -d "/home/$candidate" ]]; then
            USER_HOME="/home/$candidate"
            REAL_USER="$candidate"
            break
        fi
    done
fi

if [[ -z "$USER_HOME" || ! -d "$USER_HOME" ]]; then
    echo "❌ No se pudo detectar el home del usuario"
    exit 1
fi

echo "╔══════════════════════════════════════════════════════╗"
echo "║       ROOT INSTALLER (SYMLINKS) v2026 - KALI          ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""
echo "  👤 Usuario detectado: $REAL_USER"
echo "  📁 Home: $USER_HOME"
echo ""

mkdir -p /root/.config /root/.local/bin

# ── ZSH + Starship ──────────────────────────────────────────
echo "➜ Configurando ZSH + Starship..."
ln -sf "$USER_HOME/.zshrc" /root/.zshrc
ln -sf "$USER_HOME/.config/starship" /root/.config/starship
echo "  ✅ ZSH + Starship"

# ── Polybar ─────────────────────────────────────────────────
echo "➜ Configurando Polybar..."
ln -sf "$USER_HOME/.config/polybar" /root/.config/polybar
echo "  ✅ Polybar"

# ── Neofetch ────────────────────────────────────────────────
if [[ -d "$USER_HOME/.config/neofetch" ]]; then
    echo "➜ Configurando Neofetch..."
    ln -sf "$USER_HOME/.config/neofetch" /root/.config/neofetch
    echo "  ✅ Neofetch"
fi

# ── Neovim ──────────────────────────────────────────────────
if [[ -d "$USER_HOME/.config/nvim" ]]; then
    echo "➜ Configurando Neovim..."
    rm -rf /root/.config/nvim
    ln -sf "$USER_HOME/.config/nvim" /root/.config/nvim
    echo "  ✅ Neovim"
fi

# ── Neovim base46 cache ─────────────────────────────────────
if [[ -d "$USER_HOME/.local/share/nvim/base46" ]]; then
    echo "➜ Configurando Neovim base46 cache..."
    rm -rf /root/.local/share/nvim/base46
    mkdir -p /root/.local/share/nvim
    ln -sf "$USER_HOME/.local/share/nvim/base46" /root/.local/share/nvim/base46
    echo "  ✅ Neovim base46 cache"
fi

# ── Kitty ───────────────────────────────────────────────────
if [[ -d "$USER_HOME/.config/kitty" ]]; then
    echo "➜ Configurando Kitty..."
    rm -rf /root/.config/kitty
    ln -sf "$USER_HOME/.config/kitty" /root/.config/kitty
    echo "  ✅ Kitty"
fi

# ── Rofi ────────────────────────────────────────────────────
if [[ -d "$USER_HOME/.config/rofi" ]]; then
    echo "➜ Configurando Rofi..."
    rm -rf /root/.config/rofi
    ln -sf "$USER_HOME/.config/rofi" /root/.config/rofi
    echo "  ✅ Rofi"
fi

# ── FZF ─────────────────────────────────────────────────────
if [[ -d "$USER_HOME/.fzf" ]]; then
    echo "➜ Configurando FZF..."
    ln -sf "$USER_HOME/.fzf" /root/.fzf
    [[ -f "$USER_HOME/.fzf.zsh" ]] && ln -sf "$USER_HOME/.fzf.zsh" /root/.fzf.zsh
    echo "  ✅ FZF"
fi

# ── Symlinks bat/fd (Kali los renombra) ─────────────────────
echo "➜ Configurando symlinks bat/fd para root..."
if command -v batcat &>/dev/null && [[ ! -f /root/.local/bin/bat ]]; then
    ln -sf "$(which batcat)" /root/.local/bin/bat
    echo "  ✅ bat → batcat"
fi
if command -v fdfind &>/dev/null && [[ ! -f /root/.local/bin/fd ]]; then
    ln -sf "$(which fdfind)" /root/.local/bin/fd
    echo "  ✅ fd → fdfind"
fi

# ── list-services ───────────────────────────────────────────
echo "➜ Configurando list-services..."
if [[ -f "$USER_HOME/.bin/list-services" ]]; then
    ln -sf "$USER_HOME/.bin/list-services" /usr/local/bin/list-services
    chmod +x "$USER_HOME/.bin/list-services"
    echo "  ✅ list-services → /usr/local/bin"
fi

# ── Scripts .bin ────────────────────────────────────────────
if [[ -d "$USER_HOME/.bin" ]]; then
    echo "➜ Configurando Scripts..."
    ln -sf "$USER_HOME/.bin" /root/.bin
    echo "  ✅ Scripts"
fi

# ── Cargo/Rust (para que root use las mismas herramientas) ──
if [[ -f "$USER_HOME/.cargo/env" && ! -d /root/.cargo ]]; then
    echo "➜ Configurando Cargo para root..."
    ln -sf "$USER_HOME/.cargo" /root/.cargo
    echo "  ✅ Cargo (symlink)"
fi

# ── Cambiar shell de root a zsh ─────────────────────────────
echo "➜ Configurando ZSH como shell de root..."
ZSH_PATH=$(which zsh 2>/dev/null || echo "")
if [[ -n "$ZSH_PATH" ]]; then
    chsh -s "$ZSH_PATH" root
    echo "  ✅ Shell de root → zsh"
else
    echo "  ⚠️  zsh no encontrado, instálalo primero"
fi

echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║  ✅ ROOT CONFIGURADO CON SYMLINKS (KALI)              ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""
echo "  ⚠️  NOTAS KALI para root:"
echo "     • ~/.local/bin debe estar en PATH de root"
echo "     • Starship debe ser accesible: /usr/local/bin/starship"
echo "     • Ejecuta 'exec zsh' para recargar el shell"
echo ""
