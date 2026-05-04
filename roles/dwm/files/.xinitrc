#!/usr/bin/bash

if [ "$(xrandr | grep 'DP-1-3 connected 3440x1440')" != "" ]; then
    xrandr --output eDP-1 --off --output DP-1-3 --primary --mode 3440x1440 --rate 99.99 --pos 0x0 --rotate normal
elif [ "$(xrandr | grep 'DP-3-3 connected 3440x1440')" != "" ]; then
    xrandr --output eDP-1 --off --output DP-3-3 --primary --mode 3440x1440 --rate 99.99 --pos 0x0 --rotate normal
fi

/usr/lib/mate-polkit/polkit-mate-authentication-agent-1&
feh --no-fehbg --bg-fill ~/Pictures/Wallpaper/just_a_thought.jpg&
picom --daemon --config ~/.config/picom/picom.conf&
dunst&
slstatus&
exec dwm

