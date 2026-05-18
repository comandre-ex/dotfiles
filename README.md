# ⚙️ DOTFILES - Comandre's Config 2026

Personal dotfiles configuration for Arch Linux with i3, managed with symlinks.

## 📦 Included Configs

- **ZSH** - Enhanced shell with Starship prompt
- **Starship** - Minimal, blazing-fast prompt
- **Polybar** - Status bar for i3
- **Rofi** - Application launcher
- **Kitty** - GPU-accelerated terminal
- **Neovim** - Modern Vim editor
- **Neofetch** - System info display
- **FZF** - Fuzzy finder
- **GNOME** - Desktop environment packages

## 🚀 Installation

### User Installation
```bash
cd ~/DOTFILES
./install.sh
```

This will:
- Copy config files to `~/.config/`
- Install required packages (Neovim, Starship, etc.)
- Install Rust tools (lsd, bat, zoxide, ripgrep, fd)
- Create symlinks for custom scripts in `~/.bin/`
- Set up wallpaper

### Root Installation
```bash
cd ~/DOTFILES
sudo ./install-root.sh
```

This will create symlinks in `/root/` pointing to your user configs:
- `/root/.zshrc` → `/home/comandre/.zshrc`
- `/root/.config/*` → `/home/comandre/.config/*`
- `/root/.bin/` → `/home/comandre/.bin/`

Root's default shell is set to **zsh**.

## 📁 Structure

```
DOTFILES/
├── install.sh          # User install script
├── install-root.sh     # Root install script (symlinks)
├── .zshrc             # ZSH configuration
├── starship.toml      # Starship prompt config
├── .bin/              # Custom scripts
├── kitty/             # Kitty terminal config
├── polybar/           # Polybar status bar config
├── rofi/              # Rofi launcher config
├── nvim/              # Neovim config
├── neofetch/          # Neofetch config
└── wallpapers/        # Wallpapers
```

## 🔧 Custom Scripts

Located in `~/.bin/`:
- `cleanup.sh` - System cleanup
- `organize-home.sh` - Organize home directory
- `help` - Custom help command
- `shortcuts` - Show keyboard shortcuts
- `firefox-*` - Firefox tools

## 🎨 Features

- Starship prompt without read-only symbol
- Console login support
- Root config uses symlinks (no duplication)
- Support for both user and root environments
- i3 window manager ready

## 📝 Notes

- The `install-root.sh` script sets up symlinks so root uses the same config as your user
- Root's shell is zsh (configured automatically)
- GNOME packages are installed via the user install script
- Wallpaper is set using feh

---

**Author:** Comandre  
**Year:** 2026
