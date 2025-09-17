#!/bin/sh

if [ "$(xrandr | grep 'DP-0 connected')" != "" ]; then
    xrandr --output DP-0 --mode 3440x1440 --rate 143.92&
fi

/usr/lib/mate-polkit/polkit-mate-authentication-agent-1&
feh --no-fehbg --bg-fill ~/Pictures/Wallpaper/just_a_thought.jpg&
picom --config ~/.config/picom/picom.conf&
slstatus&
exec dwm

