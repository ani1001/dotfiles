#!/bin/sh

nitrogen --restore &
picom &
lxpolkit &
mpd &
urxvtd -q -o -f &
emacs --daemon &
