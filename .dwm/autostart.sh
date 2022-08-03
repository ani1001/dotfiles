#!/bin/sh

nitrogen --restore &
picom &
lxpolkit &
slstatus &
mpd &
emacs --daemon &
urxvtd -q -o -f &
