#!/bin/bash

# variables

threshold="0.1"
collections="Collections"
default="default-wallpaper.jpg"
issfile=$collections/`date +%Y%m%d-%H%M%S`.jpg

# get one frame of live stream

ffmpeg -loglevel panic -y -i http://iphone-streaming.ustream.tv/uhls/17074538/streams/live/iphone/playlist.m3u8  -an -q:v 2 -frames:v 1 $issfile
# ffmpeg -y -i http://iphone-streaming.ustream.tv/uhls/17074538/streams/live/iphone/playlist.m3u8 -map 0:p:1 -an -q:v 2 -frames:v 1 $issfile

failed=$?

# process image
if [ ${failed} -eq "0" ] 
then

	if ! $(file $issfile | grep -q  "1280x720")
	then
		echo "Dimensions don't fit"
		file $issfile
	fi

	rmsedown=`compare -metric RMSE down.jpg $issfile null: 2>&1 | grep -E -o '\((0|1)?\.[0-9]*\)' | sed 's/[()]//g'`
	rmseblack=`compare -metric RMSE -size 1280x720 xc:#000 $issfile null: 2>&1 | grep -E -o '\((0|1)?\.[0-9]*\)' | sed 's/[()]//g'`


	if [ $(echo " $rmsedown < $threshold " | bc) -eq 1 ] 
	then
		echo "Live is down";
		exit 1;
	elif [ $(echo " $rmseblack < $threshold " | bc) -eq 1 ] 
	then
		echo "It's too dark"
		exit 1;
	fi

	convert $issfile -filter spline -resize 1920x -unsharp 0x4+0.4+0 $default

	feh --bg-center $default
fi
