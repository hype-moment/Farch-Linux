#!/bin/bash

yad --posx=1045 --posy=42 \
--fixed \
--button="!$HOME/.fvwm/yad/Icons/power.png":1 \
--button="!$HOME/.fvwm/yad/Icons/reboot.png":2 \
--button="!$HOME/.fvwm/yad/Icons/lock.png":3 \
--button="!$HOME/.fvwm/yad/Icons/hibernate.png":4 \
--button="!$HOME/.fvwm/yad/Icons/exit.png":5 \
--button="Cancel !$HOME/.fvwm/yad/Icons/power_cancel.png":6 

foo=$?

if [[ $foo -eq 1 ]]; then
	shutdown now

elif [[ $foo -eq 2 ]]; then
	reboot

elif [[ $foo -eq 3 ]]; then
	i3lock

elif [[ $foo -eq 4 ]]; then
	systemctl suspend

elif [[ $foo -eq 5 ]]; then
	pkill -u -9 $USER

elif [[ $foo -eq 6 ]]; then 
	exit 0

fi