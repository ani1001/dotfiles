#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

# Set up an icon tray
# Terminate already running trayer instances
killall -q trayer

# Wait until the processes have been shut down
while pgrep -u $UID -x trayer > /dev/null; do sleep 1; done

run trayer --edge top \
--align right \
--widthtype percent \
--SetDockType true \
--SetPartialStrut true \
--expand true \
--width 5 \
--alpha 0 \
--transparent true \
--tint 0x282c34 \
--height 17

# Starting utility applications

run nitrogen --restore
run picom -b
run lxpolkit
run nm-applet
run volumeicon
run urxvtd -q -o -f
run emacs -daemon
