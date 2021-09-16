#!/bin/bash

killall -q lemonbar
killall -q citrus

$HOME/.config/lemonbar/citrus | lemonbar -p -F "#d8dee9" -B "#2e3440" -U "#ebcb8b" -u 2 \
	-f '-misc-fixed-*-*-*-*-13-*-*-*-*-*-*-*' | $SHELL
