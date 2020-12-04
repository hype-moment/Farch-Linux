#!/bin/bash

Search(){

Entry(){
yad --licon ~/.fvwm/yad/Icons/google.png \
--no-buttons \
--entry \
--posx=50 --posy=852 \
--completion \
--fixed
}

go="$(Entry)"

if [ "$go" > "0" ]; then
     chromium http://www.google.co.uk/search?q="$go" 
fi

}

Search
