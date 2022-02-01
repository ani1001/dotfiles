#!/bin/sh

nitrogen --restore &
picom -b &
lxpolkit &
#emacs --daemon &
urxvtd -q -o -f &
