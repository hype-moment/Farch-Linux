#!/bin/bash
yad --posx=50 --posy=305 \
--fixed \
--button="!$HOME/.fvwm/yad/Icons/music.png":1 \
--button="!$HOME/.fvwm/yad/Icons/prev.png":2 \
--button="!$HOME/.fvwm/yad/Icons/play.png":3 \
--button="!$HOME/.fvwm/yad/Icons/pause.png":4 \
--button="!$HOME/.fvwm/yad/Icons/next.png":5 \
--button="!$HOME/.fvwm/yad/Icons/exit_mpd.png":6 \


foo=$?

if [[ $foo -eq 1 ]]; then
	mpd

elif [[ $foo -eq 2 ]]; then
	mpc prev

elif [[ $foo -eq 3 ]]; then
	mpc play

elif [[ $foo -eq 4 ]]; then
	mpc pause

elif [[ $foo -eq 5 ]]; then
	mpc next

elif [[ $foo -eq 6 ]]; then 
	pkill mpd & pkill yad

fi
