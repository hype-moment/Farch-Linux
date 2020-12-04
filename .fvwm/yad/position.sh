#!/bin/bash

yad --posx=50 --posy=148 \
--fixed \
--button="Left !$HOME/.fvwm/yad/Icons/left.png":1 \
--button="Top !$HOME/.fvwm/yad/Icons/top.png":2 \
--button="Right !$HOME/.fvwm/yad/Icons/right.png":3 \
--button="Bottom !$HOME/.fvwm/yad/Icons/bottom.png":4 \
--button="Cancel !$HOME/.fvwm/yad/Icons/cancel.png":5 

foo=$?

[[ $foo -eq 5 ]] && exit 0

if [[ $foo -eq 1 ]]; then
sed -i 's/TitleAt.*/TitleAtLeft/g' ~/.fvwm/functions/window_decorrc && exit 0

elif [[ $foo -eq 2 ]]; then
sed -i 's/TitleAt.*/TitleAtTop/g' ~/.fvwm/functions/window_decorrc && exit 0

elif [[ $foo -eq 3 ]]; then
sed -i 's/TitleAt.*/TitleAtRight/g' ~/.fvwm/functions/window_decorrc && exit 0

elif [[ $foo -eq 4 ]]; then
sed -i 's/TitleAt.*/TitleAtBottom/g' ~/.fvwm/functions/window_decorrc && exit 0

fi