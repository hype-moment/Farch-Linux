#!/bin/bash

Repeat(){

REPEAT(){
rep=$(mpc | grep repeat | awk '{print $4}')
	
	if [[ $rep = on ]]; then
		echo ""
	fi
}

STATUS=$(mpc | sed -n 2p | awk '{print $1}' | sed 's/\[//g;s/]//g')

if [[ $STATUS = playing ]]; then
	echo "$(REPEAT)"
fi

}

Random(){

RANDOM(){
ran=$(mpc | grep repeat | awk '{print $6}')
	
	if [[ $ran = on ]]; then
		echo ""
	fi
}

STATUS=$(mpc | sed -n 2p | awk '{print $1}' | sed 's/\[//g;s/]//g')

if [[ $STATUS = playing ]]; then
	echo "$(RANDOM)"
fi

}

Artist(){
	ARTIST(){
		mpc | sed -n 1p | awk '{print $1" "$2}'
	}
STATUS=$(mpc | sed -n 2p | awk '{print $1}' | sed 's/\[//g;s/]//g')

if [[ $STATUS = playing ]]; then
	echo "|  $(ARTIST)"
fi

}

Music(){
	MUSIC(){
		mpc | sed -n 1p | sed 's/.* - //g;s/.mp3//g'
	}
STATUS=$(mpc | sed -n 2p | awk '{print $1}' | sed 's/\[//g;s/]//g')

if [[ $STATUS = playing ]]; then
	echo " $(MUSIC) |"
fi

}

case $1 in 
	repeat) Repeat 	;;
	random) Random 	;;
	artist) Artist 	;; 
	music) Music 	;;
esac