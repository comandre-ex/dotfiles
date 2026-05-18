#!/bin/bash
# ═══════════════════════════════════════════════════════════
# DOTFILES INSTALLER - Comandre's Config 2026
# Adaptado para Kali Linux (apt)
# ═══════════════════════════════════════════════════════════

set -e

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/.config/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

echo "╔══════════════════════════════════════════════════════╗"
echo "║          DOTFILES INSTALLER v2026 (KALI)              ║"
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
# ACTUALIZAR APT
# ═══════════════════════════════════════════════════════════
echo "➜ Actualizando repositorios..."
sudo apt update -qq

# ═══════════════════════════════════════════════════════════
# INSTALAR ZSH
# ═══════════════════════════════════════════════════════════
echo "➜ Instalando ZSH..."
if ! command -v zsh &>/dev/null; then
    sudo apt install -y zsh
fi

backup_config "$HOME/.zshrc"
cp "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

mkdir -p "$HOME/.config/starship"
cp "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship/starship.toml"

# ═══════════════════════════════════════════════════════════
# INSTALAR STARSHIP
# ═══════════════════════════════════════════════════════════
echo "➜ Instalando Starship..."
if ! command -v starship &>/dev/null; then
    echo "  📦 Instalando Starship via curl..."
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
fi

# ═══════════════════════════════════════════════════════════
# INSTALAR PLUGINS ZSH
# ═══════════════════════════════════════════════════════════
echo "➜ Instalando plugins ZSH..."
# En Kali/Debian los paths son distintos a Arch
sudo apt install -y zsh-autosuggestions zsh-syntax-highlighting 2>/dev/null || true

# Kali los instala en /usr/share/zsh-autosuggestions y
# /usr/share/zsh-syntax-highlighting (NO en zsh/plugins/)
# El .zshrc ya apunta a /usr/share/zsh-autosuggestions — correcto para Kali.
# El path de syntax-highlighting sí difiere: hay que crear un symlink o parchear:
if [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
   [[ ! -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    sudo mkdir -p /usr/share/zsh/plugins/zsh-syntax-highlighting
    sudo ln -sf /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
        /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    echo "  ✅ Symlink syntax-highlighting creado"
fi

# ═══════════════════════════════════════════════════════════
# INSTALAR POLYBAR
# ═══════════════════════════════════════════════════════════
echo "➜ Instalando Polybar..."
if ! command -v polybar &>/dev/null; then
    sudo apt install -y polybar
fi
backup_config "$HOME/.config/polybar"
mkdir -p "$HOME/.config/polybar/scripts"
cp -r "$DOTFILES_DIR/polybar/"* "$HOME/.config/polybar/"
chmod +x "$HOME/.config/polybar/scripts/"* 2>/dev/null || true

# ═══════════════════════════════════════════════════════════
# INSTALAR KITTY
# ═══════════════════════════════════════════════════════════
echo "➜ Instalando Kitty..."
if ! command -v kitty &>/dev/null; then
    # apt puede tener versión vieja; se prefiere el instalador oficial
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
    mkdir -p "$HOME/.local/bin"
    ln -sf "$HOME/.local/kitty.app/bin/kitty" "$HOME/.local/bin/kitty"
    ln -sf "$HOME/.local/kitty.app/bin/kitten" "$HOME/.local/bin/kitten"
fi
backup_config "$HOME/.config/kitty"
mkdir -p "$HOME/.config/kitty"
cp -r "$DOTFILES_DIR/kitty/"* "$HOME/.config/kitty/"

# ═══════════════════════════════════════════════════════════
# INSTALAR ROFI
# ═══════════════════════════════════════════════════════════
echo "➜ Instalando Rofi..."
if ! command -v rofi &>/dev/null; then
    sudo apt install -y rofi
fi
backup_config "$HOME/.config/rofi"
mkdir -p "$HOME/.config/rofi"
cp -r "$DOTFILES_DIR/rofi/"* "$HOME/.config/rofi/"
chmod +x "$HOME/.config/rofi/scripts/"* 2>/dev/null || true

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
    echo "  📦 Instalando Neovim (AppImage)..."
    # apt de Kali puede tener nvim viejo; usamos la AppImage oficial
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
    rm -f nvim-linux-x86_64.tar.gz
fi

backup_config "$HOME/.config/nvim"
mkdir -p "$HOME/.config/nvim"
cp -r "$DOTFILES_DIR/nvim/"* "$HOME/.config/nvim/"

# ═══════════════════════════════════════════════════════════
# INSTALAR NEOFETCH / FASTFETCH
# ═══════════════════════════════════════════════════════════
echo "➜ Instalando Neofetch..."
# neofetch está deprecado upstream; en Kali sigue disponible por ahora
if ! command -v neofetch &>/dev/null; then
    sudo apt install -y neofetch 2>/dev/null || \
    sudo apt install -y fastfetch 2>/dev/null || true
fi
if [[ -d "$DOTFILES_DIR/neofetch" ]]; then
    backup_config "$HOME/.config/neofetch"
    mkdir -p "$HOME/.config/neofetch"
    cp -r "$DOTFILES_DIR/neofetch/"* "$HOME/.config/neofetch/"
fi

# ═══════════════════════════════════════════════════════════
# INSTALAR HERRAMIENTAS RUST (lsd, bat, zoxide, ripgrep, fd)
# ═══════════════════════════════════════════════════════════
echo "➜ Instalando herramientas Rust..."

# Instalar Rust si no está
if ! command -v cargo &>/dev/null; then
    echo "  📦 Instalando Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
fi

# En Kali muchas de estas están en apt y son más rápidas de instalar así
sudo apt install -y bat ripgrep fd-find 2>/dev/null || true

# bat en Debian/Kali se llama 'batcat' — crear alias/symlink
if command -v batcat &>/dev/null && ! command -v bat &>/dev/null; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(which batcat)" "$HOME/.local/bin/bat"
    echo "  ✅ Symlink bat → batcat creado"
fi

# fd en Debian/Kali se llama 'fdfind' — crear symlink
if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(which fdfind)" "$HOME/.local/bin/fd"
    echo "  ✅ Symlink fd → fdfind creado"
fi

# lsd y zoxide no están en apt, se instalan via cargo
cargo install lsd zoxide 2>/dev/null || true

# ═══════════════════════════════════════════════════════════
# DEPENDENCIAS EXTRA PARA EL ENTORNO
# ═══════════════════════════════════════════════════════════
echo "➜ Instalando dependencias del entorno..."
sudo apt install -y \
    bspwm sxhkd \
    feh xdotool xbindkeys \
    picom \
    pavucontrol \
    flameshot \
    xclip \
    slock \
    wmctrl \
    fonts-jetbrains-mono \
    2>/dev/null || true

# ═══════════════════════════════════════════════════════════
# CREAR ENLACES SIMBÓLICOS (.bin)
# ═══════════════════════════════════════════════════════════
echo "➜ Creando enlaces simbólicos..."
mkdir -p "$HOME/.bin"
for script in "$DOTFILES_DIR/.bin/"*; do
    if [[ -f "$script" ]]; then
        name=$(basename "$script")
        ln -sf "$script" "$HOME/.bin/$name"
    fi
done

# list-services
ln -sf "$DOTFILES_DIR/.bin/list-services" "$HOME/.bin/list-services" 2>/dev/null || true
chmod +x "$DOTFILES_DIR/.bin/"* 2>/dev/null || true

# ═══════════════════════════════════════════════════════════
# CONFIGURAR FONDO DE PANTALLA
# ═══════════════════════════════════════════════════════════
echo "➜ Configurando fondo de pantalla..."
if [[ -f "$DOTFILES_DIR/wallpapers/.fondo.png" ]]; then
    cp "$DOTFILES_DIR/wallpapers/.fondo.png" "$HOME/.fondo.png"
    command -v feh &>/dev/null && feh --bg-scale "$HOME/.fondo.png" || true
fi

# ═══════════════════════════════════════════════════════════
# CAMBIAR SHELL POR DEFECTO A ZSH
# ═══════════════════════════════════════════════════════════
echo "➜ Configurando ZSH como shell por defecto..."
if [[ "$SHELL" != "$(which zsh)" ]]; then
    chsh -s "$(which zsh)"
    echo "  ✅ Shell cambiado a zsh (efectivo en próximo login)"
fi

# ═══════════════════════════════════════════════════════════
# FIN
# ═══════════════════════════════════════════════════════════
echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║  ✅ INSTALACIÓN COMPLETADA (KALI)                     ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""
echo "  🎨 Respaldo guardado en: $BACKUP_DIR"
echo "  📝 Actualiza tu shell: exec zsh"
echo "  🎛️  Reinicia polybar: polybar main &"
echo "  🖼️  Fondo configurado"
echo "  🤖 Neofetch instalado"
echo ""
echo "  ⚠️  NOTAS KALI:"
echo "     • bat se llama 'batcat' → symlink en ~/.local/bin/bat"
echo "     • fd se llama 'fdfind'  → symlink en ~/.local/bin/fd"
echo "     • Asegúrate de que ~/.local/bin esté en tu PATH"
echo "     • nvim instalado en /opt/nvim-linux-x86_64"
echo ""
echo "  📌 Para root usa: sudo ./install-root.sh"
