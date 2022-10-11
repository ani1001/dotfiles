#!/bin/sh

nitrogen --restore &
picom -b &
lxpolkit &
slstatus &
#mpd &
urxvtd -q -o -f &
