#!/usr/bin/env bash

function run {
  if ! pgrep -f $1 ;
  then
    $@&
  fi
}

run nitrogen --restore
run picom
run lxpolkit
run urxvtd -q -o -f
run emacs --daemon
