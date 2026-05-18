# ⚙️ DOTFILES - Comandre's Config 2026

Personal dotfiles configuration for Kali Linux with bspwm, managed with symlinks.

## 📦 Included Configs

- **ZSH** - Enhanced shell with Starship prompt
- **Starship** - Minimal, blazing-fast prompt
- **Polybar** - Status bar for bspwm
- **Rofi** - Application launcher & power menu
- **Kitty** - GPU-accelerated terminal
- **Neovim** - NvChad-based editor (Dracula theme)
- **Neofetch** - System info display (config personalizada)
- **FZF** - Fuzzy finder
- **bspwm + sxhkd** - Window manager & hotkeys
- **Herramientas Rust** - lsd, bat, zoxide, ripgrep, fd

## 🚀 Installation

### Requisitos previos

```bash
# Asegúrate de tener git y curl
sudo apt install -y git curl
```

### User Installation

```bash
git clone https://github.com/tuusuario/dotfiles ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

Esto instalará / configurará:
- ZSH + Starship (via curl installer)
- Plugins zsh-autosuggestions y zsh-syntax-highlighting
- Kitty (via instalador oficial)
- Neovim AppImage (última versión, compatible con NvChad)
- Herramientas Rust: lsd, zoxide (cargo), bat, ripgrep, fd (apt)
- Symlinks `bat → batcat` y `fd → fdfind` en `~/.local/bin`
- bspwm, sxhkd, polybar, rofi, feh, picom, flameshot
- Scripts personalizados en `~/.bin/`
- Fondo de pantalla con feh

### Root Installation

```bash
cd ~/dotfiles
sudo ./install-root.sh
```

Crea symlinks en `/root/` apuntando a tu config de usuario. Root usará exactamente la misma configuración sin duplicar archivos:

| Destino (root) | Fuente (usuario) |
|---|---|
| `/root/.zshrc` | `~/.zshrc` |
| `/root/.config/starship` | `~/.config/starship` |
| `/root/.config/nvim` | `~/.config/nvim` |
| `/root/.config/polybar` | `~/.config/polybar` |
| `/root/.config/kitty` | `~/.config/kitty` |
| `/root/.config/rofi` | `~/.config/rofi` |
| `/root/.config/neofetch` | `~/.config/neofetch` |
| `/root/.bin` | `~/.bin` |
| `/usr/local/bin/list-services` | `~/.bin/list-services` |

## 📁 Structure

```
dotfiles/
├── install.sh          # User install script (Kali/apt)
├── install-root.sh     # Root install script (symlinks)
├── README.md
├── .zshrc              # ZSH configuration
├── starship.toml       # Starship prompt config
├── .Xmodmap            # Escape → backslash remap
├── .bin/               # Custom scripts
│   ├── list-services
│   ├── cleanup.sh
│   ├── organize-home.sh
│   ├── help
│   └── shortcuts
├── kitty/
│   ├── kitty.conf
│   └── colors.conf     # Catppuccin Mocha
├── polybar/
│   ├── config.ini
│   ├── colors.ini
│   ├── modules.ini
│   ├── workspace.ini
│   ├── launch.sh
│   └── scripts/
│       ├── power.sh
│       ├── vpn_ip.sh
│       └── audio.sh
├── rofi/
│   ├── config.rasi
│   ├── colors/
│   │   ├── onedark.rasi
│   │   └── catppuccin.rasi
│   ├── launchers/
│   ├── powermenu/
│   └── scripts/
├── nvim/               # NvChad config
│   ├── init.lua
│   ├── lazy-lock.json
│   └── lua/
│       ├── chadrc.lua
│       ├── options.lua
│       ├── mappings.lua
│       ├── autocmds.lua
│       └── configs/
│           ├── lspconfig.lua
│           ├── conform.lua
│           └── lazy.lua
├── neofetch/           # Config personalizada (archivo grande)
├── bspwm/
│   └── bspwmrc
├── sxhkd/
│   └── sxhkdrc
└── wallpapers/
    └── .fondo.png
```

## ⚠️ Notas específicas de Kali Linux

### bat y fd tienen nombres distintos

En Kali (Debian), `bat` se instala como `batcat` y `fd` como `fdfind`. El script crea symlinks automáticamente:

```bash
~/.local/bin/bat  → /usr/bin/batcat
~/.local/bin/fd   → /usr/bin/fdfind
```

Asegúrate de que `~/.local/bin` esté antes que `/usr/bin` en tu PATH (el `.zshrc` incluido ya lo maneja).

### Neovim

El `nvim` de apt en Kali suele ser demasiado antiguo para NvChad. El script instala la AppImage oficial en `/opt/nvim-linux-x86_64/` con un symlink en `/usr/local/bin/nvim`.

### zsh-syntax-highlighting

En Arch el plugin vive en `/usr/share/zsh/plugins/zsh-syntax-highlighting/`, en Kali en `/usr/share/zsh-syntax-highlighting/`. El script crea el symlink necesario para que el `.zshrc` funcione sin modificaciones.

### intelephense (LSP PHP)

El path de npm global está hardcodeado en `nvim/lua/options.lua`:

```lua
vim.env.PATH = vim.env.PATH .. ':/home/comandre/.npm-global/bin'
```

Si tu usuario en Kali es distinto a `comandre`, actualiza esa línea.

## 🔧 Custom Scripts (`~/.bin/`)

- `list-services` - Muestra servicios TCP/UDP activos con nombres (lee `/proc/net/tcp`)
- `cleanup.sh` - Limpieza del sistema
- `organize-home.sh` - Organiza el home
- `help` - Ayuda personalizada
- `shortcuts` - Muestra atajos de teclado

## 🎨 Temas y colores

| Componente | Tema |
|---|---|
| Neovim | Dracula (via NvChad) |
| Kitty | Catppuccin Mocha |
| Rofi | One Dark |
| Polybar | Catppuccin Mocha |
| Starship | Morado `#8839ef` |

## ⌨️ Atajos principales (sxhkd)

| Atajo | Acción |
|---|---|
| `Super + Enter` | Kitty |
| `Super + r` | Rofi launcher |
| `Super + Shift + f` | Firefox |
| `Super + h/j/k/l` | Mover foco (Vim) |
| `Super + Shift + h/j/k/l` | Intercambiar ventanas |
| `Super + f` | Pantalla completa |
| `Super + s` | Flotante |
| `Super + z` | Flameshot |
| `Super + 1-9` | Cambiar escritorio |
| `Super + Shift + 1-9` | Enviar ventana a escritorio |

## 📝 Notes

- Root usa symlinks, sin duplicación de configs
- Shell por defecto se cambia a zsh automáticamente (`chsh`)
- El fondo se setea con `feh --bg-scale`
- Polybar se lanza desde `bspwmrc`
- `.Xmodmap` remapea `Escape` a `backslash`

---

**Author:** Comandre  
**Year:** 2026  
**Distro:** Kali Linux (bspwm)
