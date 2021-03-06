#!/usr/bin/env bash

function run {
  if ! pgrep -f $1 ;
  then
    $@&
  fi
}

run nitrogen --restore
run picom -b
run lxpolkit
run mpd
run volumeicon
run nm-applet
run urxvtd -q -o -f
run emacs --daemon
