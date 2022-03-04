#!/bin/sh

nitrogen --restore &
picom -b &
lxpolkit &
slstatus &
emacs --daemon &
mpd &
urxvtd -q -o -f &
