#!/bin/zsh
swayidle -w timeout 500 'convert "$($HOME/.config/wallpaper/sfw.sh)"  \( -clone 0 -resize 2560x1440\^ -gravity center -extent 2560x1440 -scale 50% -blur 0x2.5 -resize 200%\)\( -clone 0 -resize 2560x1440 \) -delete 0 -gravity center -compose over -composite /tmp/lockscreen.png \
        && swaylock \
        --indicator \
        --indicator-radius 120 \
        --indicator-thickness 8 \
        --effect-blur 7x5 \
        --effect-vignette 0.3:0.3 \
        --grace 5 \
        --ring-color bb00cc \
        --key-hl-color 880033 \
        --line-color 00000000 \
        --inside-color 00000088 \
        --separator-color 00000000 \
        --fade-in 0.2 \
        --image /tmp/lockscreen.png -f' timeout 1800 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'