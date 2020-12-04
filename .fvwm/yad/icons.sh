#!/bin/bash

yad --posx=50 --posy=225 \
--fixed \
--button="Blocks":1 \
--button="Cicles":2 \
--button="W10":3 \
--button="MacOS":4 \
--button="Classic":5 \
--button="Simple":6 \
--button="Cancel !$HOME/.fvwm/yad/Icons/cancel.png":7 

foo=$?

[[ $foo -eq 7 ]] && exit 0

if [[ $foo -eq 1 ]]; then
sed -i 's/icons\/.*/icons\/blocks/g' ~/.fvwm/config && exit 0

elif [[ $foo -eq 2 ]]; then
sed -i 's/icons\/.*/icons\/circles/g' ~/.fvwm/config && exit 0

elif [[ $foo -eq 3 ]]; then
sed -i 's/icons\/.*/icons\/w10/g' ~/.fvwm/config && exit 0

elif [[ $foo -eq 4 ]]; then
sed -i 's/icons\/.*/icons\/macos/g' ~/.fvwm/config && exit 0

elif [[ $foo -eq 5 ]]; then
sed -i 's/icons\/.*/icons\/classic/g' ~/.fvwm/config

elif [[ $foo -eq 6 ]]; then
sed -i 's/icons\/.*/icons\/wcircles/g' ~/.fvwm/config	

fi