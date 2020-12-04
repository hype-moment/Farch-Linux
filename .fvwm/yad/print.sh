#!/bin/bash

yad --posx=50 --posy=265 \
--fixed \
--button="!$HOME/.fvwm/yad/Icons/shot.png":1 \
--button="!$HOME/.fvwm/yad/Icons/cut.png":2 \
--button="!$HOME/.fvwm/yad/Icons/time.png":3 \
--button="!$HOME/.fvwm/yad/Icons/win.png":4 \
--button="Cancel !$HOME/.fvwm/yad/Icons/cancel.png":5 

foo=$?

[[ $foo -eq 5 ]] && exit 0

if [[ $foo -eq 1 ]]; then
scrot -d 1 'My_FVWM_%a-%d%b%y_%H.%M.png' -e 'viewnior ~/$f' && exit 0

elif [[ $foo -eq 2 ]]; then
scrot 'My_FVWM_%a-%d%b%y_%H.%M.png' --line style=dash,width=3,color="purple" --select -e 'viewnior ~/$f' && exit 0

elif [[ $foo -eq 3 ]]; then
notify-send ScreenShot "10 seconds" && scrot -d 10 'My_FVWM_%a-%d%b%y_%H.%M.png' -e 'viewnior ~/$f' && exit 0

elif [[ $foo -eq 4 ]]; then
scrot -d 2 -b -u 'My_Window_%a-%d%b%y_%H.%M.png' -e 'viewnior ~/$f' && exit 0

fi