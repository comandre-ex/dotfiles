#!/bin/bash
# ═══════════════════════════════════════════════════════════
# DOTFILES INSTALLER - Comandre's Config 2026
# ═══════════════════════════════════════════════════════════

set -e

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/.config/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

echo "╔══════════════════════════════════════════════════════╗"
echo "║          DOTFILES INSTALLER v2026                     ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""

# Función para crear respaldo
backup_config() {
    local target="$1"
    if [[ -e "$target" ]]; then
        echo "  📦 Respaldando $target"
        mkdir -p "$BACKUP_DIR"
        cp -r "$target" "$BACKUP_DIR/"
    fi
}

# ═══════════════════════════════════════════════════════════
# INSTALAR ZSH
# ═══════════════════════════════════════════════════════════
echo "➜ Instalando ZSH config..."

backup_config "$HOME/.zshrc"
cp "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

mkdir -p "$HOME/.config/starship"
cp "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship/starship.toml"

# ═══════════════════════════════════════════════════════════
# INSTALAR STARSHIP
# ═══════════════════════════════════════════════════════════
echo "➜ Instalando Starship..."
if ! command -v starship &>/dev/null; then
    echo "  📦 Instalando Starship..."
    cargo install starship || sudo pacman -S starship
fi

# ═══════════════════════════════════════════════════════════
# INSTALAR POLYBAR
# ═══════════════════════════════════════════════════════════
echo "➜ Instalando Polybar..."
backup_config "$HOME/.config/polybar"
mkdir -p "$HOME/.config/polybar/scripts"
cp -r "$DOTFILES_DIR/polybar/"* "$HOME/.config/polybar/"

# ═══════════════════════════════════════════════════════════
# INSTALAR KITTY
# ═══════════════════════════════════════════════════════════
echo "➜ Instalando Kitty..."
backup_config "$HOME/.config/kitty"
cp -r "$DOTFILES_DIR/kitty/"* "$HOME/.config/kitty/"

# ═══════════════════════════════════════════════════════════
# INSTALAR ROFI
# ═══════════════════════════════════════════════════════════
echo "➜ Instalando Rofi..."
backup_config "$HOME/.config/rofi"
cp -r "$DOTFILES_DIR/rofi/"* "$HOME/.config/rofi/"
chmod +x "$HOME/.config/rofi/scripts/"*

# ═══════════════════════════════════════════════════════════
# INSTALAR FZF
# ═══════════════════════════════════════════════════════════
echo "➜ Instalando FZF..."
if [[ ! -d "$HOME/.fzf" ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install" --all
fi

# ═══════════════════════════════════════════════════════════
# INSTALAR NEOVIM
# ═══════════════════════════════════════════════════════════
echo "➜ Instalando Neovim..."
if ! command -v nvim &>/dev/null; then
    echo "  📦 Instalando Neovim..."
    sudo pacman -S neovim || cargo install neovim
fi

# Copiar config de neovim
backup_config "$HOME/.config/nvim"
mkdir -p "$HOME/.config/nvim"
cp -r "$DOTFILES_DIR/nvim/"* "$HOME/.config/nvim/"

# ═══════════════════════════════════════════════════════════
# INSTALAR NEOFETCH
# ═══════════════════════════════════════════════════════════
echo "➜ Instalando Neofetch..."
if [[ -d "$DOTFILES_DIR/neofetch" ]]; then
    backup_config "$HOME/.config/neofetch"
    mkdir -p "$HOME/.config/neofetch"
    cp -r "$DOTFILES_DIR/neofetch/"* "$HOME/.config/neofetch/"
fi

# ═══════════════════════════════════════════════════════════
# INSTALAR GNOME
# ═══════════════════════════════════════════════════════════
echo "➜ Instalando GNOME..."
sudo pacman -S gnome-shell gnome-session gnome-control-center gnome-terminal --noconfirm || true

# ═══════════════════════════════════════════════════════════
# INSTALAR HERRAMIENTAS RUST
# ═══════════════════════════════════════════════════════════
echo "➜ Instalando herramientas Rust..."
cargo install lsd bat zoxide ripgrep fd-find 2>/dev/null || true

# ═══════════════════════════════════════════════════════════
# CREAR ENLACES SIMBÓLICOS
# ═══════════════════════════════════════════════════════════
echo "➜ Creando enlaces simbólicos..."

# Bin scripts
mkdir -p "$HOME/.bin"
for script in "$DOTFILES_DIR/.bin/"*; do
    if [[ -f "$script" ]]; then
        name=$(basename "$script")
        ln -sf "$script" "$HOME/.bin/$name"
    fi
done

# ═══════════════════════════════════════════════════════════
# ═══════════════════════════════════════════════════════════
# INSTALAR LIST-SERVICES
# ═══════════════════════════════════════════════════════════
echo "➜ Instalando list-services..."
ln -sf "$DOTFILES_DIR/.bin/list-services" "$HOME/.bin/list-services"
chmod +x "$DOTFILES_DIR/.bin/list-services"

# CONFIGURAR FONDO DE PANTALLA
# ═══════════════════════════════════════════════════════════
echo "➜ Configurando fondo de pantalla..."
if [[ -f "$DOTFILES_DIR/wallpapers/.fondo.png" ]]; then
    cp "$DOTFILES_DIR/wallpapers/.fondo.png" "$HOME/.fondo.png"
    feh --bg-scale "$HOME/.fondo.png"
fi

# ═══════════════════════════════════════════════════════════
# NOTA: Para instalar en root usa install-root.sh
# sudo ./install-root.sh
# ═══════════════════════════════════════════════════════════

# ═══════════════════════════════════════════════════════════
# FIN
# ═══════════════════════════════════════════════════════════
echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║  ✅ INSTALACIÓN COMPLETADA                            ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""
echo "  🎨 Respaldo guardado en: $BACKUP_DIR"
echo "  📝 Actualiza tu shell: exec zsh"
echo "  🎛️  Reinicia polybar: polybar main &"
echo "  🖼️  Fondo configurado"
echo "  🤖 Neofetch instalado"
echo ""
echo "  📌 Para root usa: sudo ./install-root.sh"