#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

xrdb -merge $HOME/.Xresources &
xrandr --output VGA-1 --brightness 0.9 &
xset +fp /home/anik/.local/share/fonts &
xset fp rehash &

## some applications that should be run in the background
# xscreensaver -no-splash &
# xclock -geometry 50x50-1+1 &
# xterm -geometry 80x50+494+51 &
# xterm -geometry 80x20+494-0 &
nitrogen --restore &
picom &
lxpolkit &
urxvtd -q -o -f &
xsetroot -cursor_name left_ptr &

# exec startxfce4
# exec awesome
# exec xmonad

# Here frankenwm is kept as default
session=${1:-frankenwm}

case $session in
    i3|i3wm           ) exec i3;;
    kde               ) exec startplasma-x11;;
    xfce|xfce4        ) exec startxfce4;;
    frankenwm         ) exec frankenwm;;
    # No known session, try to run it as command
    *                 ) exec $1;;
esac

# ...or the Window Manager of your choice
