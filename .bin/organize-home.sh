#!/bin/bash
# organize-home.sh - Organiza directorios según estándar XDG
# Uso: ./organize-home.sh

set -e

echo "🔧 Organizando HOME según estándar XDG..."

# Crear estructura XDG si no existe
mkdir -p ~/.local/bin
mkdir -p ~/.local/share
mkdir -p ~/.cache
mkdir -p ~/Descargas
mkdir -p ~/Documentos/{Trabajo,Personal,Universidad}
mkdir -p ~/Documentos/Tech/{Scripts,Configuraciones,Notas}
mkdir -p ~/Imágenes/{Capturas,Fondos}
mkdir -p ~/Proyectos/{pentesting,programacion,github}

# Mover directorios duplicados
if [ -d "$HOME/Escritorio" ] && [ ! -L "$HOME/Escritorio" ]; then
    mv "$HOME/Escritorio" "$HOME/Desktop" 2>/dev/null || true
fi

# Mover Documentos a la estructura organizada
if [ -d "$HOME/Documentos" ]; then
    [ -d "$HOME/Documentos/CV" ] && mv "$HOME/Documentos/CV" "$HOME/Documentos/Personal/" 2>/dev/null || true
    [ -d "$HOME/Documentos/Trabajo" ] && mv "$HOME/Documentos/Trabajo" "$HOME/Documentos/Trabajo/" 2>/dev/null || true
fi

# Mover github a Proyectos
if [ -d "$HOME/github" ]; then
    [ -d "$HOME/github/redTeam" ] && mv "$HOME/github/redTeam" "$HOME/Proyectos/pentesting/" 2>/dev/null || true
fi

# Mover programacion a Proyectos
if [ -d "$HOME/programacion" ]; then
    [ -d "$HOME/programacion/pentesting" ] && mv "$HOME/programacion/pentesting" "$HOME/Proyectos/pentesting/" 2>/dev/null || true
fi

# Limpiar archivos huérfanos en home
find ~ -maxdepth 1 -type f -name ".*" -size 0 -delete 2>/dev/null || true

# Crear symlinks para compatibilidad
[ -d ~/Downloads ] || ln -sf ~/Descargas ~/Downloads 2>/dev/null || true

echo "✅ Organización completada."
echo ""
echo "📁 Estructura creada:"
echo "  ~/Descargas       -> XDG $XDG_DOWNLOAD_DIR"
echo "  ~/Documentos/     -> XDG $XDG_DOCUMENT_DIR"
echo "  ~/Imágenes/      -> XDG $XDG_PICTURES_DIR"
echo "  ~/Proyectos/     -> Proyectos personales"
echo "  ~/.local/bin      -> Binarios locales"
echo "  ~/.cache/        -> Cache XDG"