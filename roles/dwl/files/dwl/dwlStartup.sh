#!/bin/bash

# Kill already running dublicate process
_ps="waybar mako swaybg"
for _prs in $_ps; do
    if [ "$(pidof "${_prs}")" ]; then
         killall -9 "${_prs}"
    fi
 done

swaybg --output '*' --mode center  --image ~/Pictures/Wallpaper/purple.jpg
dunst &
waybar &

