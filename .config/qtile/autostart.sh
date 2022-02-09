#!/bin/sh

nitrogen --restore &
picom -b &
lxpolkit &
emacs --daemon &
mpd &
urxvtd -q -o -f &
