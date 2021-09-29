#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

#starting utility applications at boot time
#run nm-applet &
picom --config $HOME/.config/picom/picom.conf &
#/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
run lxpolkit
#run volumeicon &
#nitrogen --random --set-zoom-fill &
run nitrogen --restore
