#!/bin/bash

Value=$(cat ~/.fvwm/picom.conf | grep corner-radius | sed 's/.*= //g;s/;//g')
YAD=$(yad --posx=50 --posy=40 --scale --max-value=12 --value="$Value" --fixed)

	for i in "$YAD"; do
		if [[ $i -ge 1 ]];then
			sed -i "s/corner-radius.*/corner-radius = $i;/g" ~/.fvwm/picom.conf
		fi
	done 