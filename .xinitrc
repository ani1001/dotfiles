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

xrdb $HOME/.Xresources &
xrandr --output VGA1 --brightness 0.9 &
xset +fp $HOME/.local/share/fonts &
xset fp rehash &

## some applications that should be run in the background
# xscreensaver -no-splash &
# xsetroot -cursor_name left_ptr &

# Set the default session here
session=${1:-qtile}

case $session in
    i3|i3wm           ) exec i3;;
    kde               ) exec startplasma-x11;;
    xfce|xfce4        ) exec startxfce4;;
    dwm               ) exec dbus-launch dwm;;
    qtile             ) exec dbus-launch $HOME/.local/bin/qtile start;;
    xmonad            ) exec dbus-launch xmonad;;
    stumpwm           ) exec dbus-launch stumpwm;;
    # No known session, try to run it as command
    *                 ) exec $1;;
esac

# ...or the Window Manager of your choice
