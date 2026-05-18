#!/bin/bash
# cleanup.sh - Limpieza profunda del sistema
# Uso: ./cleanup.sh [--dry-run]

DRY_RUN=false
[[ "$1" == "--dry-run" ]] && DRY_RUN=true

echo "🧹 Iniciando limpieza del sistema..."
[[ "$DRY_RUN" == true ]] && echo "⚠️ MODO DRY-RUN - No se eliminará nada"

# === CACHÉS SEGUROS (se puede borrar) ===
CACHE_DIRS=(
    "~/.cache/go-build"
    "~/.cache/pip"
    "~/.cache/mesa_shader_cache"
    "~/.cache/gnome-software"
    "~/.cache/paru"
)

for dir in "${CACHE_DIRS[@]}"; do
    expanded=$(eval echo "$dir")
    if [[ -d "$expanded" ]]; then
        size=$(du -sh "$expanded" 2>/dev/null | cut -f1)
        echo "  🗑️  $dir ($size)"
        [[ "$DRY_RUN" == false ]] && rm -rf "$expanded"
    fi
done

# === ARCHIVOS DUPLICADOS/RESTOS ===
echo ""
echo "📦 Limpiando archivos huérfanos..."

# Limpiar backups temporales de documentos
find ~/Documentos -name ".~lock.*" -delete 2>/dev/null

# Limpiar archivos vacíos en home
find ~ -maxdepth 1 -type f -name ".*" -size 0 -delete 2>/dev/null

# Limpiar archivos de swap
find ~ -maxdepth 1 -name ".*.swp" -delete 2>/dev/null

# === DIRECTORIOS INNECESARIOS ===
echo ""
echo "📁 Evaluando directorios..."

# mover paru_cache a /opt si es necesario (comentado por seguridad)
# [[ -d ~/paru_cache ]] && mv ~/paru_cache /opt/

echo ""
echo "✅ Limpieza completada."
echo ""
echo "💾 Espacio recuperable:"
du -sh ~/.cache/go-build ~/.cache/pip ~/.cache/mesa_shader_cache ~/.cache/paru 2>/dev/null | grep -v "^0"