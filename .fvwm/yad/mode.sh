#!/bin/bash

yad --posx=50 --posy=115 \
--fixed \
--button="Dark !$HOME/.fvwm/yad/Icons/dark.png":1 \
--button="Light !$HOME/.fvwm/yad/Icons/light.png":2 \
--button="Cancel !$HOME/.fvwm/yad/Icons/cancel.png":3 

foo=$?

[[ $foo -eq 3 ]] && exit 0

if [[ $foo -eq 1 ]]; then
sed -i 's/gtk-theme-name=.*/gtk-theme-name=Midnight/g' ~/.config/gtk-3.0/settings.ini
sed -i 's/Colorset 2 bg.*/Colorset 2 bg #121212/g' ~/.fvwm/functions/window_decorrc
sed -i 's/gtk-theme-name=.*/gtk-theme-name="Midnight"/g' ~/.gtkrc-2.0
sed -i 's/Mini-menu-.*/Mini-menu-dark.rasi -show drun/g' ~/.config/tint2/tools.tint2rc
sed -i 's/background_color = .*/background_color = #121212 100/g' ~/.config/tint2/tint2rc
sed -i 's/background_color = .*/background_color = #121212 100/g' ~/.config/tint2/tools.tint2rc
pkill tint2
tint2 -c ~/.config/tint2/tools.tint2rc & tint2 -c ~/.config/tint2/tint2rc && exit 0

elif [[ $foo -eq 2 ]]; then
sed -i 's/gtk-theme-name=.*/gtk-theme-name=Midday/g' ~/.config/gtk-3.0/settings.ini
sed -i 's/Colorset 2 bg.*/Colorset 2 bg #F5F5F5/g' ~/.fvwm/functions/window_decorrc
sed -i 's/gtk-theme-name=.*/gtk-theme-name="Midday"/g' ~/.gtkrc-2.0
sed -i 's/Mini-menu-.*/Mini-menu-white.rasi -show drun/g' ~/.config/tint2/tools.tint2rc
sed -i 's/background_color = .*/background_color = #F5F5F5 100/g' ~/.config/tint2/tint2rc
sed -i 's/background_color = .*/background_color = #F5F5F5 100/g' ~/.config/tint2/tools.tint2rc
pkill tint2
tint2 -c ~/.config/tint2/tools.tint2rc & tint2 -c ~/.config/tint2/tint2rc && exit 0

fi