#!/bin/bash

killall -q lemonbar
killall -q citrus

$HOME/.config/lemonbar/citrus | lemonbar -p -f '-misc-fixed-*-*-*-*-13-*-*-*-*-*-*-*' -u 2 \
	-F "#d8dee9" -B "#2e3440" -U "#ebcb8b" | $SHELL
