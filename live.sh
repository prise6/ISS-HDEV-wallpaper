#!/bin/bash

# variables

threshold="0.15"
collections="Collections"
default="default-wallpaper.jpg"
currentdate=`date +%Y%m%d-%H%M%S`
issfile=$collections/$currentdate.jpg
issLiveIsDown="issLiveIsDown.jpg"
issGrayWallpaper="gray-wallpaper.jpg"
issBlackWallpaper="black-wallpaper.jpg"
liveIsDown=0

# get one frame of live stream

ffmpeg -loglevel panic -y -i http://iphone-streaming.ustream.tv/uhls/17074538/streams/live/iphone/playlist.m3u8  -an -q:v 2 -frames:v 1 $issfile

failed=$?


if [ ${failed} -eq "0" ] 
then

	if ! $(file $issfile | grep -q  "1280x720")
	then
		echo "Dimensions don't fit"
		file $issfile
	fi

	rmsedown=`compare -metric RMSE $issLiveIsDown $issfile null: 2>&1 | grep -E -o '\((0|1)?(\.[0-9]*\))?' | sed 's/[()]//g'`
	rmsegray=`compare -metric RMSE $issGrayWallpaper $issfile null: 2>&1 | grep -E -o '\((0|1)?(\.[0-9]*\))?' | sed 's/[()]//g'`
	rmseblack=`compare -metric RMSE $issBlackWallpaper $issfile null: 2>&1 | grep -E -o '\((0|1)?(\.[0-9]*\))?' | sed 's/[()]//g'`


	if [[ ( -z $rmsedown ) || ( $(echo " $rmsedown < $threshold " | bc) -eq 1 ) ]]
	then
		echo "Live is down";
		liveIsDown=1
	elif [[ ( -z $rmsedown ) || ( $(echo " $rmseblack < $threshold " | bc) -eq 1 ) ]] 
	then
		echo "It's too dark";
		liveIsDown=1
	elif [[ ( -z $rmsedown ) || ( $(echo " $rmsegray < $threshold " | bc) -eq 1 ) ]]
	then
		echo "Live is down (gray)";
		liveIsDown=1
	fi

	if [ $liveIsDown = 1 ]
	then
		rm $issfile
		exit 1;
	fi

	
	if [[ $1 = "--wallpaper" ]]
	then
		convert $issfile -filter spline -resize 1920x -unsharp 0x4+0.4+0 $default

		if [[ $2 = "--with-location" ]]
		then
			location=`./location.sh`
			caption="`date +%d/%m/%Y\ -\ %H:%M` - $location"
			convert $default -gravity northWest \
	    	      -stroke '#000C' -strokewidth 2 -pointsize 15 -annotate 0 "$caption" \
	        	  -stroke  none   -fill white    -pointsize 15 -annotate 0 "$caption" \
	  				$default
	  	fi

		DISPLAY=:0.0 feh --bg-center $default

	elif [[ $1 = "--post-socials" ]]
	then

		location=`./location.sh $currentdate`
	  	conf_file='./conf.yaml'

	  	# instgram
		python ./post_instagram.py $conf_file $issfile "$location"	  	

	  	# twitter
	  	python ./post_twitter.py $conf_file $issfile "$location"
	fi
fi

exit 1;