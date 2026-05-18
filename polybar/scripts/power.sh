#!/bin/bash
# Power menu para polybar - Click abre rofi

case "$1" in
    --shutdown) systemctl poweroff ;;
    --reboot) systemctl reboot ;;
    --suspend) systemctl suspend ;;
    --lock) slock ;;
    --logout) bspc quit ;;
    *) ~/.config/rofi/scripts/powermenu_t1 ;;
esac