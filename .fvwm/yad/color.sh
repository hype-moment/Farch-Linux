Value=$(cat ~/.fvwm/functions/window_decorrc | grep Tint | awk '{print $2}')
YAD=$(yad --posx=50 --posy=42 --init-color=$Value --color --gtk-palette --fixed)

	for i in "$YAD"; do
		if [[ $i > 0 ]];then
			sed -i "s/Tint .*/Tint $i 100/g" ~/.fvwm/functions/window_decorrc
		fi
	done 