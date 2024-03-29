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

# Sourcing xprofile from a session started with xinit
# Make sure this is before the 'exec' command or it won't be sourced.
[ -f /etc/xprofile ] && . /etc/xprofile
[ -f ~/.xprofile ] && . ~/.xprofile

# Set the default session here
session=${1:-fluxbox}

case $session in
    awesome           ) exec dbus-launch --auto-syntax --exit-with-session awesome;;
    berry             ) exec dbus-launch --auto-syntax --exit-with-session berry;;
    bspwm             ) exec dbus-launch --auto-syntax --exit-with-session bspwm;;
    cwm               ) exec dbus-launch --auto-syntax --exit-with-session cwm;;
    dwm               ) exec dbus-launch --auto-syntax --exit-with-session dwm;;
    fluxbox           ) exec dbus-launch --auto-syntax --exit-with-session startfluxbox;;
    frankenwm         ) exec dbus-launch --auto-syntax --exit-with-session frankenwm;;
    fvwm3             ) exec dbus-launch --auto-syntax --exit-with-session fvwm3;;
    herbstluftwm      ) exec dbus-launch --auto-syntax --exit-with-session herbstluftwm;;
    i3|i3wm           ) exec dbus-launch --auto-syntax --exit-with-session i3;;
    icewm             ) exec dbus-launch --auto-syntax --exit-with-session icewm-session;;
    leftwm            ) exec dbus-launch --auto-syntax --exit-with-session leftwm;;
    jwm               ) exec dbus-launch --auto-syntax --exit-with-session jwm;;
    openbox           ) exec dbus-launch --auto-syntax --exit-with-session openbox-session;;
    pekwm             ) exec dbus-launch --auto-syntax --exit-with-session pekwm;;
    qtile             ) exec dbus-launch --auto-syntax --exit-with-session qtile start;;
    stumpwm           ) exec dbus-launch --auto-syntax --exit-with-session stumpwm;;
    spectrwm          ) exec dbus-launch --auto-syntax --exit-with-session spectrwm;;
    xfce|xfce4        ) exec startxfce4;;
    xmonad            ) exec dbus-launch --auto-syntax --exit-with-session xmonad;;
    # No known session, try to run it as command
    *                 ) exec $1;;
esac

# ...or the Window Manager of your choice
