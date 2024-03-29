#!/bin/sh

run() {
  if ! pgrep -f "$1" ;
  then
    "$@"&
  fi
}

run nitrogen --restore
run picom -b
run lxpolkit
run nm-applet
run volumeicon
run urxvtd -q -o -f
run emacs --daemon
