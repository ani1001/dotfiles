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
session=${1:-bspwm}

case $session in
    i3|i3wm           ) exec dbus-launch --auto-syntax --exit-with-session i3;;
    kde               ) exec startplasma-x11;;
    xfce|xfce4        ) exec startxfce4;;
    awesome           ) exec dbus-launch --auto-syntax --exit-with-session awesome;;
    bspwm             ) exec dbus-launch --auto-syntax --exit-with-session bspwm;;
    dwm               ) exec dbus-launch --auto-syntax --exit-with-session dwm;;
    herbstluftwm      ) exec dbus-launch --auto-syntax --exit-with-session herbstluftwm;;
    openbox           ) exec dbus-launch --auto-syntax --exit-with-session openbox-session;;
    qtile             ) exec dbus-launch --auto-syntax --exit-with-session $HOME/.local/bin/qtile start;;
    stumpwm           ) exec dbus-launch --auto-syntax --exit-with-session stumpwm;;
    spectrwm          ) exec dbus-launch --auto-syntax --exit-with-session spectrwm;;
    xmonad            ) exec dbus-launch --auto-syntax --exit-with-session xmonad;;
    # No known session, try to run it as command
    *                 ) exec $1;;
esac

# ...or the Window Manager of your choice
