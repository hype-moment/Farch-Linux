#!/bin/bash

UPDATES=$(checkupdates 2> /dev/null | wc -l)

NOTIFY(){

UPS=$(checkupdates | awk '{print $1}')
UPSV=$(checkupdates | awk '{print $2}')
UPSNV=$(checkupdates | awk '{print $4}')


yad --width=380 --posx=1218 --posy=42 --text="New updates" \
--list --column "$UPS" --column "$UPSV" --column "$UPSNV" --grid-lines=vertical \
--button="Updade":1 --button="Cancel":2 \
--no-click

foo=$?

[[ $foo -eq 2 ]] && exit 0

if [[ $foo -eq 1 ]]; then
	xfce4-terminal -e "sudo pacman -Syu"
fi

}

if [[ $UPDATES > 0 ]]; then
	NOTIFY
fi