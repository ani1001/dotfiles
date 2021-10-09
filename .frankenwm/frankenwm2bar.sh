#!/bin/bash

wm="frankenwm"
ff="/tmp/frankenwm.fifo"
[[ -p $ff ]] || mkfifo -m 600 "$ff"

# desktop names
ds=("1" "2" "3" "4" "5" "6" "7" "8" "9" "0")

# layout names
ms=("[T]" "[M]" "[B]" "[G]" "[F]" "[D]" "[E]")

while read -t 60 -r wmout || true; do
    if [[ $wmout =~ ^(([[:digit:]]+:)+[[:digit:]]+ ?)+$ ]]; then
        read -ra desktops <<< "$wmout" && unset r
        for desktop in "${desktops[@]}"; do
            IFS=':' read -r d w m c u <<< "$desktop"
            ((c)) && fg="%{F#FF597BC5}%{U#FF597BC5}" i="${ms[$m]}" \
            || fg="%{F#FFADADAD}%{U-}"
            ((u)) && w+='%{F#FFADADAD}%{U-}'
	    r+=" $fg${ds[$d]} [${w/#0/-}] "
	    #r+=" $fg${ds[$d]} "
        done
        r="${r%::*}"
    fi
    printf "%s%s%s\n" "%{l} $r" "%{c}%{F#FFADADAD}$i" "%{r}$(date +"%F %R") "
done < "$ff" | lemonbar -d -g x18xx -u 2 -B "#FF121212" -F "#FF579BC5" \
-f "-misc-fixed-*-*-*-*-13-*-*-*-*-*-*-*" &

# pass output to fifo
"$wm" > "$ff"
