#!/usr/bin/env bash
# Extrae solo la IPv4 de tun0
IP=$(ip -4 addr show tun0 2>/dev/null | awk '/inet / {print $2}' | cut -d/ -f1)

if [[ -n "$IP" ]]; then
    # 󰖂 = Icono VPN (Nerd Font)
    echo "󰖂 ${IP}"
else
    # No imprime nada si tun0 está caído (Polybar oculta el módulo automáticamente)
    echo ""
fi

