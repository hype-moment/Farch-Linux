#!/bin/bash

Value=$(cat ~/.fvwm/picom.conf | grep frame-opacity | awk '{print $3}' | sed 's/.*\.//g;s/;//g')
YAD=$(yad --posx=50 --posy=50 --scale --max-value=99 --value="$Value" --fixed)

	for i in "$YAD"; do
		if [[ $i > 0 ]];then
			sed -i "s/frame-opacity = 0.*/frame-opacity = 0.$i;/g" ~/.fvwm/picom.conf
		fi
	done 
